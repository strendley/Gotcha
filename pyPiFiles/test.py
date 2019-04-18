#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  
import subprocess
import re
import sys

def get_paired_devices():
    #p_devices = subprocess.Popen('./get_paired_devices.sh', shell=True, stdout=subprocess.PIPE)
    #p_devices.wait()
    # parse paired_devices.log
    pair_macs = []
    with open('paired_devices.log') as log: 
        lines = log.read().splitlines()
        for line in lines:
            mac = re.compile('([a-fA-F0-9]{2}[:|\-]?){6}').search(line)
            if mac:
                pair_macs.append(line[mac.start():mac.end()])
                
        del pair_macs[-1]   #remove last mac - raspberry pi bt address
        #print(pair_macs)
    
    log.close()
    return pair_macs
    
def is_phone_present():
    pair_macs = get_paired_devices()
    
    with open('paired_devices.log') as log: 
        for mac in range(0, len(pair_macs)):
            ping_addr = pair_macs[mac]
            p = subprocess.Popen('sudo l2ping -c 1 {}'.format(ping_addr), shell=True, stdout=subprocess.PIPE)
            print(sys.stdout.read())
        
is_phone_present()
