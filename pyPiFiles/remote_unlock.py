#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  
#  Description:
#   
#  Remote unlock triggered via motion sensor, verified by local face encodings 
#       & Bluetooth proximity of a registered user's smartphone MAC address
#  
#  Manual unlock triggered by Flutter app publishing to topic, pi is subscribed, parses new config & performs desired function
#
#  Must run before startup:
#  export GOOGLE_APPLICATION_CREDENTIALS="/home/pi/Desktop/pi_auth_keys/<file_name>.json"


import RPi.GPIO as GPIO
import time
import datetime
import picamera 
import base64
#'''
import subprocess
import sys
import face_recognition
import numpy
import re
#import io

from PIL import Image
#'''
from google.cloud import pubsub_v1
from google.cloud import firestore

subscriber_door = pubsub_v1.SubscriberClient()
camera = picamera.PiCamera()

#project_id = 'gotcha-233622'
#model_id = 'ICN8341606992171376246'
#db = firestore.Client()

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


# Message pulled from subscription 'pi_configurations'
# encoded_message is a byte string literal, utf-8
def callback1(encoded_message): 

    decoded_message = bytes.decode(encoded_message.data)
    
    # Split json message by line, check for all conditions
    print(decoded_message)
    
    # Unlocks door 
    if '{"door": "unlock"}' in decoded_message:
      print('Door Unlocking\n')
      unlocked()
      
    if '{"faces": "update"}' in decoded_message:
      print('Updating local authorized images\n')
      # TODO:
      # update local feces & encodings -> db changed, pull images
    
    if '{"tmp_picture": "test"}' in decoded_message:
      print('Checking user photo against local encodings')
      # TODO:  
      # test the temporary picture in firebase, update firebase field
      # update_document('flutter_updates', 'picture_test', 'passed') # or 'failed'
      
    print(decoded_message)
    #Acknowledge message
    encoded_message.ack()
    
# Takes photo and returns output  
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

### Functions for locked and unlocked states, updating configuration states in db
def update_document(doc, field, value):
    db = firestore.Client()
    ref = db.collection(u'pi_config_states').document(u'{}'.format(doc))

    # Set the specified field
    ref.update({u'{}'.format(field): value})

'''
def check_user_requests():
    db = firestore.Client()
    requests_ref = db.collection(u'pi_config_states').document(u'{flutter_updates}')
    print(requests_ref)
'''

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


def delete_local_data():
    remove_faces = 'rm -f result_*.jpg'
    remove_photos = 'rm -f face_*.jpg'
    p_faces = subprocess.Popen(remove_faces, shell=True, stdout=subprocess.PIPE)
    p_photos = subprocess.Popen(remove_photos, shell=True, stdout=subprocess.PIPE)
    
    p_faces.wait()
    p_photos.wait()
    
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

# Consistent RSSI data is proving to be difficult to obtain when device is connected, yet not discoverable:
# User considered present if ping of paired device is successful
def is_phone_present():
    pair_macs = get_paired_devices()
    
    for mac in range(0, len(pair_macs)):
        ping_addr = pair_macs[mac]
        p = subprocess.run(['sudo', 'l2ping', '-c', '1', '{}'.format(ping_addr)], universal_newlines=True, check=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        lines = p.stdout.split('\n')
        if '1 sent, 1 received, 0% loss' in lines[2]:
            #print('ping successful')
            return True
        else # Auth user not present
            return False
    
def is_user_home():
    # getter for auth user home/away settings
    # user can allow system to know which registered occupants are inside 
    
    return False
    
def on_lockdown():
    # getter for vacation setting in app
    # disables all entry
    
    return False

def is_auth():
    # determines if user is authenticated
    # checks local storage of authorized face_encodings
    return True

# Driver
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
        future = subscriber_door.subscribe('projects/gotcha-233622/subscriptions/pi_config_sub', callback1)
        
        
        while True:
            # Check if pairing button is pressed
            if GPIO.input(pair_switch) == False:
                time.sleep(0.5)
                print('Attempting to pair devices')
                pair_smartphone()
            
            # If motion is detected
            if GPIO.input(pir) == True:
                # Set pi_config_states -> motion -> detected : true
                update_document('pi_status', 'motion', 'true')
                
                GPIO.output(blue, True)          # Blue OFF - motion detected
                print("Motion Detected!")
                print("Taking photo")	
                GPIO.output(yellow, False)      # Yellow ON - picture being taken
               
                # Take photo and format picture
                name = format_picture()
                GPIO.output(yellow, True)       # Yellow OFF
                
                # Find faces
                #name = 'sample.jpg'
                face = face_recognition.load_image_file(name)
                face_locations = face_recognition.face_locations(face)
                
                # No need to predict while all occupants are away from home 
                if (not on_lockdown()):
                    
                    # Check encodings only if faces are found
                    if(len(face_locations) > 0):
                      
                            # Set pi_config_states -> faces -> detected : true
                            update_document('pi_status', 'faces', 'true')
                            
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

                                    # If user is not home proceed to assess face credentials and ping phone
                                    if (not is_user_home()):
                                    
                                        # Authenticate photographed persons  
                                        if (is_auth()) and (is_phone_present()): 
                                              
                                                # Unlock the door
                                                print('face_{} Authorized with prediction score: {}'.format(i, score))
                                                print('Door Unlocking')
                                                unlocked()
                                                
                                                # Allow user to enter before arming
                                                #time.sleep(60)
                                                #locked()
                                                
                                        #Else, unauthorized entry
                                        else:
                                                print('face_{} Not Authorized with prediction score: {}'.format(i, score))
                                                locked()
                                    
                                    # face counter++        
                                    i += 1
                            
                            delete_local_data()
                            
                            ## Reset for next cycle
                            # Set pi_config_states -> faces -> detected : false
                            update_document('pi_status', 'faces', 'false')
                            # Set pi_config_states -> motion -> detected : true
                            update_document('pi_status', 'motion', 'false')
                            
                            # Blue LED ON to indicate motion sensor ready
                            GPIO.output(blue, False)
                            print("End of detection cycle")
                            
                    # No faces in image taken 
                    else:
                            print('No faces found')
                            print("End of detection cycle")
                            # Set pi_config_states -> motion -> detected : false
                            update_document('pi_status', 'motion', 'false')
                            
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
