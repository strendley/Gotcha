#!/usr/bin/env python3
# facial cropper
import cv2 as cv
import numpy as np
import glob
import os
import argparse
import time
import imutils as im
import sys
from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

#door variable (locked = true)
doorLocked = True
#new subdirectory name for cropped images
subDirectory = "cropped"
#webcam file path
webcam = ""
#directory for the pretrained classifier data
face_cascade = cv.CascadeClassifier('haarcascade_frontalface_default.xml')

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-c", "--cropPath", required=False, help="mode:crop directory of images")
    ap.add_argument("-w", "--webcamPath", required=False, help="mode:monitor webcam for faces")
    args = vars(ap.parse_args())
    
    exit(1)
    if args['cropPath'] != None:
        cropImages(args['cropPath'])
    elif args['webcamPath'] != None:
        monitorWebcam(args['webcamPath'])
    else:
        print("Please provide a webcam path with -w ' ' or image directory with -c ' '")

def cropImages(directoryOfFaces = "C:/Users/Tristen/Desktop/faces/"):
    #get list of images
    pics = glob.glob(directoryOfFaces + "*.jpg")
    try:
        os.mkdir(directoryOfFaces + subDirectory)
    except:
        print("directory already exists")
    for pic in pics:
        test = cv.imread(pic)
        faces = face_cascade.detectMultiScale(test, 1.3, 5)
        for (x,y,w,h) in faces:
            #either draw rectangles or crop image down to face
            #cv.rectangle(test, (x,y),(x+w,y+h), (0,255,0), 2)
            crop_img = test[y:y+h, x:x+h]

            #commented code to show image for debugging
            #cv.imshow('test',crop_img)
            #cv.waitKey()
            
            #write cropped image to subdirectory
            imageName = os.path.basename(pic)
            cv.imwrite(directoryOfFaces + subDirectory +"/" + imageName, crop_img)

def monitorWebcam(webcamPath = ""):
    while True:
        while(1): #TODO******motion sensor activated
            vs = im.VideoStream(src=0).start()
            time.sleep(2.0)
            frame = vs.read()
            faces = face_cascade.detectMultiScale(frame, 1.3, 5)
            for (x,y,w,h) in faces:
                #either draw rectangles or crop image down to face
                #cv.rectangle(test, (x,y),(x+w,y+h), (0,255,0), 2)
                crop_img = frame[y:y+h, x:x+h]
                predictions = []
                predictions.append(getprediction(crop_img, gotcha-233622, ICN8341606992171376246wq))
                for attempt in prediction: #TODO*****  fix this loop I can't test gcloud on my windows machine
                    if attempt > 80:
                        unlockDoor()
            time.sleep(300.0) #wait 300 seconds before locking door again
            lockDoor()
            
def lockDoor():
    doorLocked = True
    #TODO***** lock door here

def unlockDoor():
    doorLocked = False
    #TODO*** unlock door here
            
def get_prediction(content, project_id, model_id):
    prediction_client = automl_v1beta1.PredictionServiceClient()
    name = 'projects/{}/locations/us-central1/models/{}'.format(project_id, model_id)
    payload = {'image': {'image_bytes': content }}
    params = {}
    request = prediction_client.predict(name, payload, params)
    return request

if __name__ == '__main__':
    main()
