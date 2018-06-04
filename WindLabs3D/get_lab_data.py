# import os
import requests
import bz2
import json
from pymongo import MongoClient


def GetLabData(appKey, masterKey, filePath, mongoCollection):
    goedle_app_key = appKey
    goedle_master_key = masterKey
    headers = {'X-goedle-app-key': goedle_app_key,
               'X-goedle-master-key': goedle_master_key}

    # print(headers['X-goedle-app-key'])
    # print(headers['X-goedle-master-key'])

    # workingDir = os.getcwd()
    file = open(filePath, 'wb')
    for yea in range(2017, 2019):
        year = str(yea)
        for mon in range(1, 12):
            if(mon < 10):
                month = ''.join(['0', str(mon)])
            else:
                month = str(mon)
        	#(16,19 is the available range)
            for da in range(1, 32):
                if(da < 10):
                    day = ''.join(['0', str(da)])
                else:
                    day = str(da)
                requestUrl = ''.join(['https://api.goedle.io/apps/',
                                      goedle_app_key, '/data/',
                                      year, '/', month, '/', day])
                                      
                
                print('working on:'+day+' '+month+' '+year)
                # print(requestUrl)
                r = requests.get(requestUrl, headers=headers)
                #print(r.status_code)
                
                if(r.status_code == 200):
                    #print(r.status_code)
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
    RefreshDataInMongoDB(filePath, mongoCollection)


def RefreshDataInMongoDB(filePath, mongoCollection):
    mongoClient = MongoClient('127.0.0.1')
    db = mongoClient.envisage
    db[mongoCollection].delete_many({})
    jsonFile = open(filePath, "r")
    #jsonData = jsonFile.read().split('\n')
    print('Inserting into database...')
    for fileLine in open(filePath, "r"):
        jsonLine = fileLine.split('\n')
        for line in jsonLine:
            #print(line)
            try:
                dbObject = json.loads(line)
                db[mongoCollection].insert_one(dbObject)
            except Exception:
                "Failed to load line as JSON"
