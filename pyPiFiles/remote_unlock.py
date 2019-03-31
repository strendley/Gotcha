#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  
#  Description:
#   
#  Remote unlock triggered via motion sensor and verified by AutoML API 
#       & Bluetooth proximity of a registered user's smartphone MAC address
#  
#  Manual operation of the lock (firestore update) availiable through flutter app
#
#  Must run before startup: TODO - (write bash script, load at network connection after boot)
#  export GOOGLE_APPLICATION_CREDENTIALS="/home/pi/Desktop/pi_auth_keys/george_credentials.json"


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

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2
from google.cloud import pubsub_v1
from google.cloud import firestore

#subscriber_door = pubsub_v1.SubscriberClient()

project_id = 'gotcha-233622'
model_id = 'ICN8341606992171376246'
camera = picamera.PiCamera()
db = firestore.Client()

pir = 8     # Pin 8  : PIR
yellow = 10 # Pin 10 : yellow LED
lock = 12   # Pin 12 : door lock
green = 16  # Pin 16 : green LED
red = 18    # Pin 18 : red LED
blue = 22   # Pin 22 : blue LED

GPIO.setmode(GPIO.BOARD)      # set GPIO mode to correct physical numbering
GPIO.setup(pir, GPIO.IN)      # setup GPIO pin PIR as input
GPIO.setup(yellow, GPIO.OUT)  # setup led outputs 
GPIO.setup(lock, GPIO.OUT)   
GPIO.setup(green, GPIO.OUT)   
GPIO.setup(red, GPIO.OUT)   
GPIO.setup(blue, GPIO.OUT)

'''
# Example: Message pulled from subscription 'door_sub'
# encoded_message is a byte string literal, utf-8
def callback1(encoded_message): #encoded in, 

    decoded_message = bytes.decode(encoded_message.data)
     
    # Unlocks door 
    if decoded_message == '{"door": "unlock"}':
      print('Door Unlocking\n')
      unlocked()
      
    print(decoded_message)
    #Acknowledge message
    encoded_message.ack()
    
# Open the subscription, passing the callback async with While loop
    #future = subscriber_door.subscribe('projects/gotcha-233622/subscriptions/pi_door_sub', callback1)
'''

# Takes photo and returns output  
def take_photo_picamera():
    camera.resolution = (1024, 768) 
    camera.rotation = 270
    output = numpy.empty((768,1024,3) , dtype = numpy.uint8)
    camera.capture(output, format = 'rgb')
    return output
  
# Contacts AutoML Vision and gets json response
def get_prediction(content, project_id, model_id):
    prediction_client = automl_v1beta1.PredictionServiceClient()

    name = 'projects/{}/locations/us-central1/models/{}'.format(project_id, model_id)
    payload = {'image': {'image_bytes': content }}
    params = {}
    request = prediction_client.predict(name, payload, params)
    return request  # waits till request is returned
  
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
    door_ref = db.collection(u'pi_config_states').document(u'{}'.format(doc))

    # Set the specified field
    door_ref.update({u'{}'.format(field): value})

def check_user_requests():
    db = firestore.Client()
    requests_ref = db.collection(u'pi_config_states').document(u'{flutter_request}')
    print(requests_ref)
    
'''
# Listen for updates
def on_snapshot(doc_snapshot, changes, read_time):
        for doc in doc_snapshot:
          print(doc.to_dict())
        
def listen_requests():
    doc_ref = db.collection(u'pi_config_states').document(u'flutter_request')
    doc_watch = doc_ref.on_snapshot(on_snapshot)
    print(doc_watch)
'''

def locked():
    # Set pi_config_states -> door -> locked : true
    update_document('door', 'locked', True)
  
    GPIO.output(lock, False)
    GPIO.output(red, False)
    GPIO.output(green, True)
    
def unlocked():
    # Set pi_config_states -> door -> locked : false
    update_document('door', 'locked', False)
  
    GPIO.output(lock, True)
    GPIO.output(red,True)
    GPIO.output(green, False)


def delete_local_data():
    remove_faces = 'rm -f result_*.jpg'
    remove_photos = 'rm -f face_*.jpg'
    process1 = subprocess.Popen(remove_faces, shell=True, stdout=subprocess.PIPE)
    process2 = subprocess.Popen(remove_photos, shell=True, stdout=subprocess.PIPE)
    process1.wait()
    process2.wait()

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
        
        while True:
            # If motion is detected
            if GPIO.input(pir) == True:
                # Set pi_config_states -> motion -> detected : true
                update_document('motion', 'detected', True)
                
                GPIO.output(blue, True)          # Blue OFF - motion detected
                print("Motion Detected!")
                print("Taking photo")	
                GPIO.output(yellow, False)      # Yellow ON - picture being taken
                
                # Take photo and format picture
                name = format_picture()
                GPIO.output(yellow, True)       # Yellow OFF
                
                # Find faces
                #name = 'luke_hat.jpg'
                face = face_recognition.load_image_file(name)
                face_locations = face_recognition.face_locations(face)
                
                # If faces found, get_prediction()
                if(len(face_locations) > 0):
                  
                        # Set pi_config_states -> faces -> detected : true
                        update_document('faces', 'detected', True)
                        
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

                                # Read .jpg file as bytes
                                with open(path, 'rb') as ff:
                                        content = ff.read()
                                
                                # AutoML request
                                json_response = get_prediction(content, project_id, model_id)
                                print(json_response)
                                json_str = str(json_response)
                                
                                # Regex for score 
                                match = re.search('([0-9]*\.[0-9]+|[0-9]+)', json_str)
                                score = match.group(0)
                                
                                #If score is above 89.999%, unlock door          #TODO: Require user's phone in close proximity -> bluetooth MAC
                                if float(score) > 0.8999999999999999:
                                        # Unlock the door
                                        print('face_{} Authorized with prediction score: {}'.format(i,score))
                                        print('Door Unlocking')
                                        unlocked()
                                        
                                #Else, unauthorized entry
                                else:
                                        print('face_{} Not Authorized with prediction score: {}'.format(i,score))
                                        locked()
                                
                                # face counter++        
                                i += 1
                        
                        delete_local_data()
                        
                        # Turn Blue LED ON to indicate motion sensor ready
                        GPIO.output(blue, False)
                        print("End of detection cycle")
                        
                # No faces in image taken 
                else:
                        # Set pi_config_states -> faces -> detected : false
                        update_document('faces', 'detected', False)
                        
                        print('No faces found')
                        print("End of detection cycle")
                        
                        # Turn Blue LED ON to indicate motion sensor ready
                        GPIO.output(blue, False)
                        
            else: 
                # Set pi_config_states -> motion -> detected : false
                update_document('motion', 'detected', False)
                # Set pi_config_states -> faces -> detected : false
                update_document('faces', 'detected', False)
                
            
    # At keyboard interrupt, cease to sense motion
    except KeyboardInterrupt: 
        pass # Do nothing, continue to finally
	
    # Cleanup
    finally:   
        GPIO.cleanup()          # Reset all GPIO
        print('Exiting motion script')

if __name__ == '__main__':
    main()
