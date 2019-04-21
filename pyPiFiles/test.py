#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  
from google.cloud import firestore
        
def read_db_value(document, field):
    db = firestore.Client()
    doc_ref = db.collection(u'pi_config_states').document(u'{}'.format(document))
    doc = doc_ref.get()
    config = '{}'.format(doc.to_dict())       
    return config
    
read_db_value('settings', 'on_vacation')
