#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  Cloudinary image upload triggered by motion sensor
#  

import RPi.GPIO as GPIO
import time
import datetime
import subprocess

from twilio.rest import Client

import cloudinary
import cloudinary.uploader
import cloudinary.api

pir = 8 # Assign pin 8 to PIR
led = 10 # Assign pin 10 to LED

GPIO.setmode(GPIO.BOARD)    # set GPIO mode to correct board numbering
GPIO.setup(pir, GPIO.IN)    # setup GPIO pin PIR as input
GPIO.setup(led, GPIO.OUT)   # setup GPIO pin for LED as output

src_phone = "+15733045559"	# 'Purchased' (trial) Twilio phone number
dest_phone = "+15736730302"


# Twilio credentials
twilio_account_sid = "ACfcdff70258ab4367b08df0f0fcd0358d"
twilio_auth_token = "redacted"
twilio_client = Client(twilio_account_sid, twilio_auth_token)


# Cloudinary credentials
cloudinary_cloud_name = "gotcha"
cloudinary_api_key = "562151361162454"
cloudinary_api_secret = "redacted"
cloudinary.config(cloud_name = cloudinary_cloud_name, api_key = cloudinary_api_key , api_secret = cloudinary_api_secret)


# Run subprocess and wait to finish photo output to file
def take_photo():
	# timestamp the photo 
    timestamp = datetime.datetime.now().strftime('%d_%b_%Hh_%Mm_%Ss')
    name = timestamp + '.jpg'
    take_photo_cmd = 'raspistill -w 1024 -h 768 -o ' + name
    process = subprocess.Popen(take_photo_cmd, shell=True, stdout=subprocess.PIPE)
    process.wait()
    
    file_location = '/home/pi/Desktop/gotcha_python_drivers/' + timestamp +'.jpg'
    # return path to photo on disk as string 
    return file_location 

# Upload image via path, return public url
def upload_to_cloudinary(file_name):
    response = cloudinary.uploader.upload(file_name,tags="rpi")
    return response['url']
    
# Sends mms via Twilio, picture is delivered to dest_phone in messages
def send_mms(dest_phone, message, media_url):
    twilio_client.messages.create(
                                    to = dest_phone,
                                    from_ = src_phone,
                                    body = 'Motion Detected!!",
                                    media_url = media_url)

# Driver
def main():
    
    print("Sensor initializing") # Warm-up sensor
    time.sleep(2)
    print("Ready to detect motion")
    print("Press Ctrl + C to end program")
	
	# Sensing motion infinitely
    try: 
        while True:
            # If motion is detected
            if GPIO.input(pir) == True:
                print("Motion Detected!")
                GPIO.output(led, True)          # turn on LED
					
                photo_location = take_photo()	# take photo, get path
                
                # Upload to Cloudinary
                #public_url = upload_to_cloudinary(photo_location)
                print("Image uploaded to Cloudinary")
                
                # Delete local copy 
                remove_cmd = 'rm ' + photo_location
                process = subprocess.Popen(remove_cmd, shell=True, stdout=subprocess.PIPE)
                
                # Send MMS to user via Twilio
                #send_mms(dest_phone, message, public_url)
                #print("MMS sent to +1-573-673-0302")                 
                
                GPIO.output(led, False)         # turn off LED
                time.sleep(0.1)
                print("End of detection cycle")
	
	# At keyboard interrupt, cease to sense motion
    except KeyboardInterrupt: 
        pass # Do nothing, continue to finally
	
	# Cleanup
    finally:
        GPIO.output(led, False) # Turn off LED
        GPIO.cleanup()          # Reset all GPIO
        print('Exiting motion script')

if __name__ == '__main__':
    main()

