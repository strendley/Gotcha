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
from google.cloud import Blob

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
      print('Checking user photo against local encodings')
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
    name = 'face_{}.jpg'.format(timestamp)
    picture.save(name)
    return name
    
def delete_local_data():
    remove_faces = 'rm -f result_*.jpg'
    remove_photos = 'rm -f face_*.jpg'
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

def get_db_value(document, field):
    db = firestore.Client()
    doc_ref = db.collection(u'pi_config_states').document(u'{}'.format(document))
    doc = doc_ref.get()
    config = '{}'.format(doc.to_dict())       
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
    if use_bt_auth:
        # get updated paired devices list and check if phone is in bt range
        pair_macs = get_paired_devices()
        
        # ping each mac in list
        for mac in range(0, len(pair_macs)):
            ping_addr = pair_macs[mac]
            p = subprocess.run(['sudo', 'l2ping', '-c', '1', '{}'.format(ping_addr)], universal_newlines=True, check=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
            lines = p.stdout.split('\n')
            # If ping successful 
            if '1 sent, 1 received, 0% loss' in lines[2]:
                return True
            else: # Auth user not present
                return False


### Face Authentication Functions:-------------------------------------------------------------------------------------------

# updates local face encodings from remote images in firebase
def update_local_faces():
    # pull images from firebase storage, exclude *test*.jpg
    download_blob('gotcha-233622.appspot.com', 'face_')
    
    # Get all images from test directory (no test images)
    pics = glob.glob('/home/pi/Desktop/faces/face_*')
    
    # clear face encodings list
    authorized_encodings.clear()
    
    # create new encodings for each image, append to auth array
    for img in pics:
        #print(pics[0])
        input_file = pics[img]
        # process image
        image = face_recognition.load_image_file(input_file)
        # create encoding
        encoding = face_recognition.face_encodings(image)[0]
        # append encoding to global auth list
        authorized_encodings.append(encoding)
    
# downloads all pictures in bucket to local pi storage
def download_blob(bucket_name, prefix):
    client = storage.Client()
    
    # Retrieve all blobs with a prefix matching the file.
    bucket = client.get_bucket(bucket_name)
        
    bucket_name = 'gotcha-233622.appspot.com'
    folder='/home/pi/Desktop/faces'
    delimiter='/'
    prefix_ = 'face_'

    # List only face_*.jpg images in bucket
    blobs=bucket.list_blobs(prefix=prefix_, delimiter=delimiter)
    
    for blob in blobs:
       # get name of resident
       name = (blob.name)[len(prefix_):]
       print(name)
       dest_path = '{}/{}'.format(folder, blob.name) 
       blob.download_to_filename(dest_path)
       #print('{}\'s face downloaded to {}.'.format(name, dest_path))

# UNDER CONSTRUCTION:______------------++++++++++++___________-------------+++++++++++++________----------++++++++++

# determines if user at door is authentic
def is_auth(encoding):
    # compares encoding of face with authorized encodings on disk
    key_string = ''
    
    for auth_encoding in authorized_encodings:
        match = face_recognition.compare_faces(auth_encoding, face_encoding)
        if match:
            auth_name = ''
            return auth_name
    

# tests the temporary picture in firebase, update firebase field
def picture_test(): 
    # get test picture from blob, filter with 'test' prefix
    download_blob('gotcha-233622.appspot.com', 'test')
    
    # Get test image from faces folder on disk 
    img = glob.glob('/home/pi/Desktop/faces/test*')
    
    # crop the image
    input_file = pics[img]
    # process image
    image = face_recognition.load_image_file(input_file)
    face_locations = face_recognition.face_locations(image)
    
    # assert single face in test image
    if(len(face_locations) > 0 and len(face_locations) < 2):
        
        # crop image
        top,right,bottom,left = face_location
        face_image = face[top-50:bottom+50, left-50:right+50]
        pil_image = Image.fromarray(face_image)
        
        # save image to upload
        path = 'result_{}.jpg' 
        pil_image.save(path)
    
        # encoding of test face
        test_encoding = face_recognition.face_encodings(path)[0]
        
        # remove the .jpg or seek alternative to local save
    
        # test against authorized face encodings
        auth_name = is_auth(test_encoding)
        
    else:
        #update_document('image_test', 'testResult', 'error')
    
    # update db with test_name
    if(not 'unknown' in auth_name ):  # compare the face encoding with face encodings on disk
      update_document('image_test', 'hasTested', 'true')
      update_document('image_test', 'testResult', '{}'.format(test_name))
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
                                face_image = face[top-50:bottom+50, left-50:right+50]
                                pil_image = Image.fromarray(face_image)
                                print(face_location)
                                
                                # save image to upload
                                path = 'result_{}.jpg'.format(i)  
                                pil_image.save(path)
                                
                                # encoding of face at door - path to cropped image
                                door_encoding = face_recognition.face_encodings(path)[0]
                                
                                # pass encoding to auth fn for test
                                key = is_auth(door_encoding)
                                
                                
                                # If user is not home proceed to assess face credentials and ping phone # add option to disable as well?
                                if (not is_user_home('{}'.format(user))): # var user is the '<user_name>'
                                
                                    # Authenticate photographed persons  
                                    # variable 'name' is path to photo
                                    if (not ('unknown' in key)) and (check_phone()): 
                                          
                                        # Unlock the door
                                        print('face_{} Authorized'.format(face_encoding_name))
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
