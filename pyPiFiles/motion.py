#!/usr/bin/python

import RPi.GPIO as GPIO
import time
import os
GPIO.setmode(GPIO.BOARD) # Set GPIO to pin numbering
pir = 8 #Assign pin 8 to PIR
led = 10 #Assign pin 10 to LED
GPIO.setup(pir, GPIO.IN) #Setup GPIO pin PIR as input
GPIO.setup(led, GPIO.OUT) # Setup GPIO pin for LED as output
print("Sensor initializing") #Give sensor time to start up
time.sleep(2)
print("Active")
print("Press Ctrl+c to end program")

try: 
    while True:
        if GPIO.input(pir) == True:
            print("Motion Detected!")
            os.system("python3 pic.py")
            GPIO.output(led, True) #Turn on LED
            time.sleep(4) #Keep LED on 4 seconds
            GPIO.output(led, False) #Turn off LED
            time.sleep(0.1)

except KeyboardInterrupt: 
    pass # Do noting, continue to finally

finally:
    GPIO.output(led, False) #Turn off LED in case left on
    GPIO.cleanup() # reset all GPIO
    print("program ENDED")
