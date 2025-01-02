#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys, json, urllib.request, urllib.parse, urllib.error
import base64
import os.path
import os
from requests.auth import HTTPBasicAuth
import requests

def Process_Token():
    credentials=open("/home/moorej3/.encode.txt")
    credArray=next(credentials).rstrip().split("\t")
    return credArray[0], credArray[1]

def Download_File(name, extension, usrname, psswd, outputDir):
    if not os.path.exists(outputDir+"/"+name+"."+extension):
        print("dowloading "+name+" ...")
        url="https://www.encodeproject.org/files/"+name+"/@@download/"+name+"."+extension
        r = requests.get(url, auth=HTTPBasicAuth(usrname, psswd))
        outputFile=open(outputDir+"/"+name+"."+extension, "wb")
        outputFile.write(r.content)
        outputFile.close()

usrname, psswd = Process_Token()
base64string = base64.b64encode(bytes('%s:%s' % (usrname,psswd),'ascii'))
creds = base64string.decode('utf-8')

accession = sys.argv[1]
extension = sys.argv[2]
outputDir = sys.argv[3]
Download_File(accession, extension, usrname, psswd, outputDir)
