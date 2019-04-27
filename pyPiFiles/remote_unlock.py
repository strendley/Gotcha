#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  
#  Description:
#   
#  Remote unlock triggered via motion sensor, verified by local face encodings 
#       & Bluetooth proximity of a registered user's smartphone MAC address
#  
#  Flutter app publishes to pi_configuration topic, pi is subscribed & parses new config, performs desired function
#
#  Must run before startup:
#  export GOOGLE_APPLICATION_CREDENTIALS="/home/pi/Desktop/pi_auth_keys/<file_name>.json"

import RPi.GPIO as GPIO
import time
import datetime
import picamera 
import base64
import subprocess
import sys
import face_recognition
import numpy
import re
import glob

from PIL import Image

from google.cloud import pubsub_v1
from google.cloud import firestore
from google.cloud import storage

subscriber_pi = pubsub_v1.SubscriberClient()
camera = picamera.PiCamera()
authorized_encodings = []

pir = 8     # Pin 8  : PIR
yellow = 10 # Pin 10 : yellow LED
lock = 12   # Pin 12 : door lock
green = 16  # Pin 16 : green LED
red = 18    # Pin 18 : red LED
blue = 22   # Pin 22 : blue LED
pair_switch = 24 #   : user pairing button

GPIO.setmode(GPIO.BOARD)      # set GPIO mode to correct physical numbering
GPIO.setup(pir, GPIO.IN)      # setup GPIO pin PIR as input
GPIO.setup(yellow, GPIO.OUT)  # setup led outputs 
GPIO.setup(lock, GPIO.OUT)   
GPIO.setup(green, GPIO.OUT)   
GPIO.setup(red, GPIO.OUT)   
GPIO.setup(blue, GPIO.OUT)
GPIO.setup(pair_switch, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Remote System Management:---------------------------------------------------------------------------------------------------:

# Message pulled from subscription 'pi_configurations'
# encoded_message is a byte string literal, utf-8
def callback1(encoded_message): 
    
    # TODO: encrypt(flutter)&decrypt payload 
    decoded_message = bytes.decode(encoded_message.data)
    
    # Check for each type of message
    #print(decoded_message)
    
    # Unlocks door 
    if '"door": "unlock"' in decoded_message:
      print('Door Unlocking\n')
      encoded_message.ack()
      unlocked()
      
    if '"faces": "update"' in decoded_message:
      print('Updating local authorized images\n')
      encoded_message.ack()
      update_local_faces()
    
    if '"tmp_picture": "test"' in decoded_message:
      print('Checking user photo against local encodings\n')
      encoded_message.ack()
      picture_test()
      
### System Resource Functions:-----------------------------------------------------------------------------------------------:
    
# takes photo and returns output  
def take_photo_picamera():
    camera.resolution = (1024, 768) 
    camera.rotation = 270
    output = numpy.empty((768,1024,3) , dtype = numpy.uint8)
    camera.capture(output, format = 'rgb')
    return output

def format_picture():
    output = take_photo_picamera()
    picture = Image.fromarray(output)
    timestamp = datetime.datetime.now().strftime('%d_%b_%H:%M:%S')
    name = 'door_img_{}.jpg'.format(timestamp)
    picture.save(name)
    return name
    
def delete_local_data():
    # reomove faces in current working directory
    remove_photos = 'rm -f door_img_*.jpg'
    remove_faces = 'rm -f face_*.jpg'
    p_faces = subprocess.Popen(remove_faces, shell=True, stdout=subprocess.PIPE)
    p_photos = subprocess.Popen(remove_photos, shell=True, stdout=subprocess.PIPE)
    
    p_faces.wait()
    p_photos.wait()

### Firebase & Internal Config functions:------------------------------------------------------------------------------------
def update_document(doc, field, value):
    db = firestore.Client()
    ref = db.collection(u'pi_config_states').document(u'{}'.format(doc))

    # Set the specified field
    ref.update({u'{}'.format(field): value})

# currently returns the entire document, need to parse further in applications
def get_db_value(document, field):
    db = firestore.Client()
    doc_ref = db.collection(u'pi_config_states').document(u'{}'.format(document))
    doc = doc_ref.get()
    config = '{}'.format(doc.to_dict()['{}'.format(field)])      
    return config

def locked():
    # Set pi_config_states -> pi_status -> door locked
    update_document('pi_status', 'door', 'locked')
  
    GPIO.output(lock, False)
    GPIO.output(red, False)
    GPIO.output(green, True)
    
def unlocked():
    # Set pi_config_states -> pi_status -> door unlocked
    update_document('pi_status', 'door', 'unlocked')
  
    GPIO.output(lock, True)
    GPIO.output(red,True)
    GPIO.output(green, False)
    
def on_lockdown():
    # getter for global home/away setting
    lockdown = get_db_value('settings', 'on_vacation')
    if 'true' in lockdown:
      return True
    else:
      return False
      
def is_user_home(user):
    # getter for auth user home/away settings
    # user can allow system to know which registered occupants are inside 
    home = get_db_value('is_home', user)
    if 'true' in home:
      return True
    else:
      return False
      

### Bluetooth Functions:-----------------------------------------------------------------------------------------------------
def pair_smartphone():
    p_pair = subprocess.Popen('./button_pair_auth.sh', shell=True, stdout=subprocess.PIPE)
    p_pair.wait()
    
def get_paired_devices():
    p_devices = subprocess.Popen('./get_paired_devices.sh', shell=True, stdout=subprocess.PIPE)
    p_devices.wait()
    # parse paired_devices.log
    pair_macs = []
    with open('paired_devices.log') as log: 
        lines = log.read().splitlines()
        for line in lines:
            mac = re.compile('([a-fA-F0-9]{2}[:|\-]?){6}').search(line)
            # pattern matched
            if mac:
                pair_macs.append(line[mac.start():mac.end()])
                
        del pair_macs[-1]   #last mac is raspberry pi mac address
        print('Paired macs:\n {}'.format(pair_macs))
    
    log.close()
    return pair_macs  # returns list of macs paired with the device

# RSSI data is proving to be difficult to obtain when device is connected, yet not discoverable
# user considered present if ping of paired device is successful (any bt range is acceptable)
def check_phone():
    # Check firebase field to store user (on/off) for 2nd factor by phone
    use_bt_auth = get_db_value('settings', 'use_bt_auth')
    if use_bt_auth == 'true':
        # get updated paired devices list and check if phone is in bt range
        pair_macs = get_paired_devices()
        
        # ping each mac in list
        for mac in range(0, len(pair_macs)):
            ping_addr = pair_macs[mac]
            print('Pinging paired devices')
            p = subprocess.run(['sudo', 'l2ping', '-c', '1', '{}'.format(ping_addr)], universal_newlines=True, check=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
            lines = p.stdout.split('\n')
            # If ping successful 
            if '1 sent, 1 received, 0% loss' in lines[2]:
                return True
            else: # Auth user not present
                return False
    else: # bt auth not used
        return True


### Face Authentication Functions:-------------------------------------------------------------------------------------------
# updates local face encodings from remote images in google cloud platform bucket resource
def update_local_faces():
    update_start = time.time()
    # remove all faces from /home/pi/Desktop/faces
    remove_faces = 'rm -f face_*.jpg'
    p_faces = subprocess.Popen(remove_faces, shell=True, stdout=subprocess.PIPE)
    p_faces.wait()
    print('All local authorized face images removed')
    
    # pull images from firebase storage, exclude *test*.jpg
    download_blob('gotcha-233622.appspot.com', 'face_')
    
    # Get all images from test directory (no test images)
    pics = glob.glob('/home/pi/Desktop/faces/face_*')
    
    # clear face encodings list
    authorized_encodings.clear()
    
    i = 0 # track image number in blob
    # crop the faces and create new encodings for each image, append to auth array
    for image in pics:
        
        # load image into user_face
        user_face = face_recognition.load_image_file(image)
        # recognize faces: should only be a single face, asserted in test image
        # all pi photos may contain more than one face
        face_locations = face_recognition.face_locations(user_face)
        
        # TODO: create single crop function - third use
        # crop image
        top,right,bottom,left = face_locations[0]
        
        # error if adding 50 pixel perimeter around face detected by library # use standard?
        face_image = user_face[top:bottom, left:right]
        pil_image = Image.fromarray(face_image)
        
        # save image
        path = 'face_{}.jpg'.format(i) 
        pil_image.save(path)
    
        # process image
        print('Encoding: %s ' % pics[i])
        cropped = face_recognition.load_image_file(path)
        # create encoding
        encoding = face_recognition.face_encodings(cropped)[0]
        # append encoding to global auth list
        authorized_encodings.append(encoding)
        #print(authorized_encodings)
        i += 1
    print('Editing and Encoding Update Cost: %s seconds' % (time.time() - update_start))
    
# downloads all pictures in bucket to local pi storage
def download_blob(bucket_name, prefix_):
    client = storage.Client()
    
    # Retrieve all blobs with a prefix matching the file.
    bucket = client.get_bucket(bucket_name)
        
    bucket_name = 'gotcha-233622.appspot.com'
    folder='/home/pi/Desktop/faces'
    delimiter='/'

    # List only face_*.jpg images in bucket
    blobs=bucket.list_blobs(prefix=prefix_, delimiter=delimiter)
    
    for blob in blobs:
       # get name of resident
       name = (blob.name)[len(prefix_):]
       #print(name)
       dest_path = '{}/{}'.format(folder, blob.name) 
       blob.download_to_filename(dest_path)
       #print('{}\'s face downloaded to {}.'.format(name, dest_path))

# determines if user at door is authentic
def is_auth(encoding):
    # compares encoding of face with authorized encodings on disk
    auth_name = ''
    # check global list
    for auth_encoding in authorized_encodings:
        match = face_recognition.compare_faces([auth_encoding], encoding)
        if match:
            # TODO
            # extract the name of the person from the face encoding
            return 'authorized'
            
    # not authenticated if still empty at end of testing
    if auth_name == '':
        return 'unknown'
    

# tests the temporary picture in firebase, update firebase field
def picture_test(): 
    # get test picture from blob, filter with 'test' prefix
    download_blob('gotcha-233622.appspot.com', 'test')
    
    # Get test image from faces folder on disk 
    img = glob.glob('/home/pi/Desktop/faces/test.*')
    
    # process image
    test_image = face_recognition.load_image_file(img[0])
    face_locations = face_recognition.face_locations(test_image)
    
    # assert single face in test image
    if(len(face_locations) == 1):
        
        # crop image
        top,right,bottom,left = face_locations[0]
        face_image = test_image[top:bottom, left:right]
        pil_image = Image.fromarray(face_image)
        
        # save image
        path = 'test_img.jpg'
        pil_image.save(path)

        #load
        cropped = face_recognition.load_image_file(path)
        
        # create encoding of test face
        test_encoding = face_recognition.face_encodings(cropped)[0]
        
        # test against authorized face encodings
        auth_name = is_auth(test_encoding)
        
        # remove test image
        #remove_faces = 'rm -f test_img.jpg'
        #p_faces = subprocess.Popen(remove_faces, shell=True, stdout=subprocess.PIPE)
        #p_faces.wait()
        
    else:
        update_document('image_test', 'testResult', 'Error: Multiple Faces')
    
    # update db with test_name
    if(not 'unknown' in auth_name):
      update_document('image_test', 'hasTested', 'true')
      update_document('image_test', 'testResult', '{}'.format(auth_name))
    else:
      update_document('image_test', 'hasTested', 'true')  
      update_document('image_test', 'testResult', 'unknown')

# Driver:--------------------------------------------------------------------------------------------------------------------:
def main():
  
    print("Sensor initializing\n")
    locked()
    GPIO.output(yellow, True)
    GPIO.output(blue, False)                    # Blue ON
    print("Armed & Ready to detect motion\n")
    print("Press Ctrl + C to end program\n")
	
    # Sensing motion infinitely
    try:
        # Open the subscription, passing the callback async with While loop
        future = subscriber_pi.subscribe('projects/gotcha-233622/subscriptions/pi_config_sub', callback1)
        
        
        while True:
            # Check if pairing button is pressed
            if GPIO.input(pair_switch) == False:
                time.sleep(0.5)
                print('Attempting to pair devices')
                pair_smartphone()
            
            # If motion is detected
            if GPIO.input(pir) == True:
                # Set pi_config_states -> motion -> detected : true
                update_document('pi_status', 'motion', True)
                
                GPIO.output(blue, True)          # Blue OFF - motion detected
                print("Motion Detected!")
                print("Taking photo")	
                GPIO.output(yellow, False)      # Yellow ON - picture being taken
               
                # Take photo and format picture
                name = format_picture()
                GPIO.output(yellow, True)       # Yellow OFF
                
                
                # load image taken at door
                face = face_recognition.load_image_file(name)
                # recognize faces
                face_locations = face_recognition.face_locations(face)
                
                
                # No need to predict while all occupants are away or on_vacation in firebase setting
                if (not on_lockdown()):
                    
                    # Check encodings only if faces are found at door
                    if(len(face_locations) > 0):
                      
                        # Set pi_config_states -> faces -> detected : true
                        update_document('pi_status', 'faces', True)
                        
                        # Crop all faces from photo
                        for face_location in face_locations:
                                i = 1                       # face id
                                top,right,bottom,left = face_location
                                face_image = face[top:bottom, left:right]
                                pil_image = Image.fromarray(face_image)
                                print(face_location)
                                
                                # save image to upload
                                path = 'face_{}.jpg'.format(i)  
                                pil_image.save(path)
                                
                                # load cropped image
                                cropped = face_recognition.load_image_file(path)
                                
                                # encoding of face at door - path to cropped image
                                door_encoding = face_recognition.face_encodings(cropped)[0]
                                
                                """TESTING"""
                                ''' load encodings to global array '''
                                update_local_faces()
                                ''' end '''
                                
                                # pass encoding to auth fn for test
                                key = is_auth(door_encoding)
                                
                                # SECTION: Authenticate photographed persons
                                
                                '''In Testing:
                                # If user is not home proceed to assess face credentials
                                #if (not is_user_home('{}'.format(key))): # var user is the '<user_name>'
                                '''
                                      
                                # if not marked unknown, user's encoding exists in system
                                if (not ('unknown' in key)) and (check_phone()): 
                                      
                                    # Unlock the door
                                    print('face_{} Authorized'.format(key))
                                    print('Door Unlocking')
                                    unlocked()
                                    
                                    # Allow user to enter before arming if enabled,
                                    # if disabled, assume user manually locks system to secure household
                                    enable_lock_timeout = get_db_value('settings', 'enable_lock_timeout')
                                    if enable_lock_timeout:
                                        time.sleep(180)
                                        locked()
                                        
                                #Else, unauthorized entry
                                else:
                                    print('NOT AUTHORIZED')
                                
                                # face counter++        
                                i += 1
                        
                        delete_local_data()
                        
                        ## Reset for next cycle
                        # Set pi_config_states -> faces -> detected : false
                        update_document('pi_status', 'faces', False)
                        # Set pi_config_states -> motion -> detected : true
                        update_document('pi_status', 'motion', False)
                        
                        # Blue LED ON to indicate motion sensor ready
                        GPIO.output(blue, False)
                        print("End of detection cycle")
                            
                    # No faces in image taken 
                    else:
                            print('No faces found')
                            print("End of detection cycle")
                            # Set pi_config_states -> motion -> detected : false
                            update_document('pi_status', 'motion', False)
                            
                            # Blue LED ON to indicate motion sensor ready
                            GPIO.output(blue, False)
            
            
    # End of testing TODO item: create and modify permissions for /etc/network/if-up.d/{bash_script_name.sh}
    # *.sh will execute this python script when the network becomes availiable - remove interrupt
            
    # At keyboard interrupt, cease to sense motion
    except KeyboardInterrupt: 
        pass # Do nothing, continue to finally
	
    # Cleanup
    finally:   
        GPIO.cleanup()          # Reset all GPIO
        print('Exiting motion script')

if __name__ == '__main__':
    main()
