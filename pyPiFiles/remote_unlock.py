#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  Remote unlock triggered via motion sensor and verified by AutoML API
#  

import RPi.GPIO as GPIO
import time
import datetime
import subprocess
import sys
import face_recognition
import picamera 
import numpy
import io

from PIL import Image

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

project_id = 'gotcha-233622'
model_id = 'ICN8341606992171376246'

pir = 8 # Assign pin 8 to PIR
yellow = 10 # Assign pin 10 to yellow LED
lock = 12 # Assign pin 12 to door lock
green = 16 # Assign pin 16 to green LED
red = 18 # Assign pin 18 to red LED

GPIO.setmode(GPIO.BOARD)    # set GPIO mode to correct physical numbering
GPIO.setup(pir, GPIO.IN)    # setup GPIO pin PIR as input
GPIO.setup(yellow, GPIO.OUT)   # setup GPIO pin for LED as output
GPIO.setup(lock, GPIO.OUT)   # setup GPIO pin for door lock as output
GPIO.setup(green, GPIO.OUT)   # setup GPIO pin for LED as output
GPIO.setup(red, GPIO.OUT)   # setup GPIO pin for LED as output

# Run subprocess and wait to finish photo output to file
def take_photo_raspistill():
    # timestamp the photo 
    timestamp = datetime.datetime.now().strftime('%d_%b_%Hh_%Mm_%Ss')
    name = timestamp + '.jpg'
    take_photo_cmd = 'raspistill -w 1024 -h 768 -o ' + name
    process = subprocess.Popen(take_photo_cmd, shell=True, stdout=subprocess.PIPE)
    process.wait()
    
    file_location = '/home/pi/Desktop/gotcha_python_drivers/' + timestamp +'.jpg'
    # return path to photo on disk
    return file_location 
  
def take_photo_picamera():
    camera = picamera.PiCamera()
    camera.resolution = (1024, 768) 
    camera.rotation = 270
    output = numpy.empty((768,1024,3) , dtype = numpy.uint8)
    camera.capture(output, format = 'rgb')
    return output
  
 
def get_prediction(content, project_id, model_id):
  prediction_client = automl_v1beta1.PredictionServiceClient()

  name = 'projects/{}/locations/us-central1/models/{}'.format(project_id, model_id)
  payload = {'image': {'image_bytes': content }}
  params = {}
  request = prediction_client.predict(name, payload, params)
  return request  # waits till request is returned


# Driver
def main():
    
    print("Sensor initializing") # Warm-up sensor
    #time.sleep(2)
    #GPIO.output(lock, False)
    #GPIO.output(yellow, True)          # yellow indicates sensor ready
    #GPIO.output(green, True)        
    #GPIO.output(red, True)
    print("Armed & Ready to detect motion")
    print("Press Ctrl + C to end program")
	
    # Sensing motion infinitely
    try: 
        while True:
            # If motion is detected
            #if GPIO.input(pir) == True:
                print("Motion Detected!")
                GPIO.output(yellow, False) # shut off sensor to indicate verification process underway
		
                print("Taking photo")			
                #photo_location = take_photo()	# take photo, get path

                #image = face_recognition.load_image_file(photo_location)
                '''
                output = take_photo_picamera()
                picture = Image.fromarray(output)
                picture.save('tristen_face.jpg')
                '''
                
                face = face_recognition.load_image_file('tristen_face.jpg')
                face_locations = face_recognition.face_locations(face)
                
                #print(len(face_locations))
                
                for face_location in face_locations:
                        
                        top,right,bottom,left = face_location
                        face_image = face[top-50:bottom+50, left-50:right+50]
                        pil_image = Image.fromarray(face_image)
                        pil_image.save("result.jpg")
                        
                #img_byte_array = io.BytesIO()
                #pil_image.save(img_byte_array, format = 'PNG')
                #img_byte_array = img_byte_array.getvalue()
                
                with open('run.jpg', 'rb') as ff:
                        content = ff.read()
                
                print(get_prediction(content, project_id, model_id))
                        
               
                exit(1)
                #print(face_locations[0])
                
                
                # Get Prediction
                # print (get_prediction(content, project_id,  model_id))
                
                # Unlock door if prediction reliable and wait for entrance
                #GPIO.output(lock, True)         # unlock door
                #GPIO.output(green, False)        # green ON
                
                # Else reject and do not wait 
                #GPIO.output(red, False)          # red is on by default
                
                # Delete local copy 
                #remove_cmd = 'rm ' + photo_location
                #process = subprocess.Popen(remove_cmd, shell=True, stdout=subprocess.PIPE)

                
                
                GPIO.output(yellow, True)
                print("End of detection cycle")
	
    # At keyboard interrupt, cease to sense motion
    except KeyboardInterrupt: 
        pass # Do nothing, continue to finally
	
    # Cleanup
    finally:
        #GPIO.setmode(GPIO.BOARD)
        GPIO.cleanup()          # Reset all GPIO
        print('Exiting motion script')

if __name__ == '__main__':
    main()
