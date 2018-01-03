import os
import requests
import bz2
import json
from pymongo import MongoClient

goedle_app_key = '90e167a8ba993ab18f52ec7fdb44fdea'
goedle_master_key = 'f461126b1ec2a7be13213bae67dd3f37'

headers = {'X-goedle-app-key': goedle_app_key,
           'X-goedle-master-key': goedle_master_key}

#print(headers['X-goedle-app-key'])
#print(headers['X-goedle-master-key'])

workingDir = os.getcwd()
filepath = "WindData.json"
file = open(filepath, 'wb')
for yea in range(2017, 2018):
    year = str(yea)
    for mon in range(1, 12):
        if(mon < 10):
            month = ''.join(['0', str(mon)])
        else:
            month = str(mon)

        for da in range(1, 32):
            if(da < 10):
                day = ''.join(['0', str(da)])
            else:
                day = str(da)
            requestUrl = ''.join(['https://api.goedle.io/apps/',
                                  goedle_app_key, '/data/',
                                  year, '/', month, '/', day])
            # print(requestUrl)
            r = requests.get(requestUrl, headers=headers)
            print(r.status_code)
            if(r.status_code == 200):
                print(r.status_code)
                try:
                    compressedData = r.content
                    # workingDir = os.getcwd()
                    # filepath = ''.join([workingDir,'/',year, '-',
                    # month, '-', day,'.envisageData.txt'])
                    # print(filepath)
                    # file = open(filepath, 'wb')
                    if(bz2.decompress(compressedData) != b''):
                        file.write(bz2.decompress(compressedData) + b"\n")

                except ValueError:
                    print("Data not valid bz2...")

mongoClient = MongoClient('127.0.0.1')
db = mongoClient.envisage
jsonFile = open(filepath, "r")
jsonData = jsonFile.read().split('\n')
for line in jsonData:
    print(line)
    dbObject = json.loads(line)
    db.wind.insert_one(dbObject)
