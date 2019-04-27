#!/usr/bin/env python
import face_recognition
import numpy
import subprocess
import glob
import time
from google.cloud import firestore
from google.cloud import storage

from PIL import Image

authorized_encodings = []

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
      
# determines if user at door is authentic
def is_auth(encoding):
    # compares encoding of face with authorized encodings on disk
    auth_name = ''
    # check global list
    for auth_encoding in authorized_encodings:
        match = face_recognition.compare_faces(auth_encoding, encoding)
        if match:
            # TODO
            # extract the name of the person from the face encoding
            return 'authorized'
            
    # not authenticated if still empty at end of testing
    if auth_name == '':
        return 'unknown'
    
update_local_faces()
picture_test()
