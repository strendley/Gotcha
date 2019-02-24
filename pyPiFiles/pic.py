import smtplib, ssl
from time import sleep
from picamera import PiCamera
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders

camera = PiCamera()

camera.start_preview()
camera.capture('motion.jpg')
camera.stop_preview()

def send_email():
    toaddr = 'stbrb@mst.edu'
    me = 'gcwzf4@mst.edu'
    subject = 'George\'s PI is EMAILING YOU!!!! MUAHHAHAHAH'

    msg = MIMEMultipart()
    msg['Subject'] = subject
    msg['From'] = me
    msg['To'] = toaddr
    msg.preabmble = 'test'

    part = MIMEBase('application', 'octet-stream')
    part.set_payload(open('motion.jpg', 'rb').read())
    encoders.encode_base64(part)
    part.add_header('Content-Dispostion', 'attachment; filename="motion.jpg"')
    msg.attach(part)

    try:
        s = smtplib.SMTP('smtp.gmail.com', 587) 
        s.ehlo()
        s.starttls()
        s.ehlo
        s.login(user = 'gcwzf4@mst.edu', password='Sectan123!@')
        s.sendmail(me, toaddr, msg.as_string())
        s.quit()

    except SMTPException as error:
        print ("ERROR")

send_email()
