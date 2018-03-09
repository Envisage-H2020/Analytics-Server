from pymongo import MongoClient
from bson.objectid import ObjectId
import pandas as pd
import json
import statistics

def Results(df):
    overRatio = None
    correctRatio = None
    underRatio = None
    score = None
    profit = None
    name = 'None'
    
    result = dict()
    over = list()
    correct = list()
    under = list()
    
    if 'event_id' in df:
        events = df.loc[(df['event'] == 'game.result')]
        for i in range(0, events.shape[0]):
            if events.loc[events.index[i],'event_id'] == "overpower":
                try: 
                    overRatio = float(events.loc[events.index[i],'event_value']) 
                except ValueError:
                    overRatio = ""
            if events.loc[events.index[i],'event_id'] == "underpower": 
                try: 
                    underRatio = float(events.loc[events.index[i],'event_value']) 
                except ValueError:
                    underRatio = ""
            if events.loc[events.index[i],'event_id'] == "correct_power": 
                try: 
                    correctRatio = float(events.loc[events.index[i],'event_value']) 
                except ValueError:
                    correctRatio = ""
            if events.loc[events.index[i],'event_id'] == "score": 
                score = float(events.loc[events.index[i],'event_value'])
            if events.loc[events.index[i],'event_id'] == "profit": 
                profit = float(events.loc[events.index[i],'event_value']) > 0.0  
                
        events = df.loc[(df['event'] == 'identify')]
        if (events.shape[0] > 0):
            if ('first_name' in events):
                try:
                    for i in range(0, events.shape[0]):
                        name = str(events.loc[events.index[i],'first_name'])
                except Exception as e:
                    print("Name error: %s" % e)
                    name = 'None'
            else:
                print('Encountered identify event, but no name data encountered.')  
        else:
            print('No name data encountered.')
            
        
            
    #using old code exclusively to determine median time on task - which seems to be 9 by default?? 
    if 'event_id' in df:
        events = df.loc[(df['event'] == 'game.state') &
                        (df['event_id'] == 'powerUsage')]
        events.sort_values(['ts'], ascending=False)
        for i in range(0, events.shape[0]):
            if i < events.shape[0] - 1:
                ts = events.loc[events.index[i], 'ts']
                tsBefore = events.loc[events.index[i + 1], 'ts']
                time = tsBefore - ts
                time = abs((float(time)))
                if events.loc[events.index[i + 1],
                              'event_value'] == "-Over power":
                    over.append(time)
                if events.loc[events.index[i + 1],
                              'event_value'] == "-Correct power":
                    correct.append(time)
                if events.loc[events.index[i + 1],
                              'event_value'] == "-Under power":
                    under.append(time)
    wrongTimes = under
    wrongTimes.extend(over)
    medianTimeOnTask = 0
    if len(wrongTimes) > 0:
        medianTimeOnTask = statistics.median(wrongTimes)
    #if medianTimeOnTask > 100:
    #    medianTimeOnTask = 9  # This is the average in the current dataset
        
    #if overRatio + correctRatio + underRatio > 0.99:
    #values may not equal 100% exactly, so normalise them
    try: 
        total = overRatio + correctRatio + underRatio
        if total > 0:
            overRatio = overRatio * 100.0 / total
            correctRatio = correctRatio * 100.0 / total
            underRatio = underRatio * 100.0 / total
            total = overRatio + correctRatio + underRatio
        result['over'] = overRatio
        result['correct'] = correctRatio
        result['under'] = underRatio
        result['medianTimeOnTask'] = medianTimeOnTask
        result['score'] = score
        result['profit'] = profit
        result['name'] = name
        print("Processed : %s" % name);
    except TypeError:
        #we have some null values!
        return result
           
    # print(medianTimeOnTask)
    
    return result

def State(df):

    result = dict()
    
    environment = ""
    map = ""
    turbine = ""
    binary = ""
    
    environment_options = {'fields' : '0,0,0,0,1',
                         'seashore' : '0,0,0,1,0',
                        'mountains' : '0,0,1,0,0'
    }
    
    map_options = {'1' : '0,0,0,0,0,0,0,0,0,1',
                   '2' : '0,0,0,0,0,0,0,0,1,0',
                   '3' : '0,0,0,0,0,0,0,1,0,0',
                   '4' : '0,0,0,0,0,0,1,0,0,0',
                   '5' : '0,0,0,0,0,1,0,0,0,0',
                   '6' : '0,0,0,0,1,0,0,0,0,0',
                   '7' : '0,0,0,1,0,0,0,0,0,0',
                   '8' : '0,0,1,0,0,0,0,0,0,0',
    }
    
    turbine_options = {'A' : '0,0,1,1,1',
                   'B' : '0,0,0.41747572815534,0.5,0.5',
                   'C' : '0,0,0.00970873786407768,0,0',
                   'D' : '0,0,0.41747572815534,0.5,0.5',
                   'E' : '0,0,0.223300970873786,0.5,0.25',
                   'F' : '0,0,0,0.105263157894737,0',
                   'G' : '0,0,0.41747572815534,0.973684210526316,0.75',
                   'H' : '0,0,0.223300970873786,0.5,0.25',
                   'I' : '0,0,0,0.105263157894737,0',
    }
    
    if 'event_id' in df:
        events = df.loc[(df['event'] == 'choose.environment')]
        if (events.shape[0] > 0):
            try:
                for i in range(0, events.shape[0]):
                    environment = events.loc[events.index[i],'event_id']              
            except KeyError:
                environment = ""
        
        events = df.loc[(df['event'] == 'click.map_pointer')]
        if (events.shape[0] > 0):
            try:
                for i in range(0, events.shape[0]):
                    map = events.loc[events.index[i],'event_id']
            except KeyError:
                map = ""
            
        events = df.loc[(df['event'] == 'select.turbine_type')]
        if (events.shape[0] > 0):
            try:
                for i in range(0, events.shape[0]):
                    turbine = events.loc[events.index[i],'event_id']
            except KeyError:
                name = ""

        binary += environment_options.get(environment, '') + ','
        binary += map_options.get(map, '') + ','
        binary += turbine_options.get(turbine, '')
        
        result['environment'] = environment
        result['map'] = map
        result['turbine'] = turbine
        result['binary'] = binary
        
        
    return result

def CalculateWindFeatures():
    mongoClient = MongoClient('127.0.0.1')
    db = mongoClient.envisage

    windUsers = list()
    usersLookup = db.wind.distinct('user_id')
     
    print('Calculating wind features...')
    for user in usersLookup:
        # Prepare user object
        windUser = dict()
                
        # Get all entries from user
        entryLookup = db.wind.find({'user_id': user})
        dataBuffer = list()
        for entry in entryLookup:
            dataBuffer.append(entry)
        userDf = pd.DataFrame(dataBuffer)
           
        #Filter out any entries from a different version of the game
        if 'build_nr' in userDf:
            try:  
                if userDf.build_nr.isin(['5']).unique().all():                   
                    #ASSUME: cleaning script divides user by unique usernames:
                    # Create new user and determine end-game results
                    windUser['userId'] = user
                    windUser['results'] = Results(userDf)
                    windUser['state'] = State(userDf)
                    
                    # Reached correct power
                    if 'event_value' in userDf:
                        windUser['correctPower'] = \
                            True in userDf.event_value.isin(['-Correct power']).unique()
                    # Turbine on/off
                    if 'event' in userDf:
                        windUser['turbineOnOff'] = \
                            (True in userDf.event.isin(['disable.turbine']).unique() or
                                True in userDf.event.isin(['enable.turbine']).unique())
                    # Repaired turbine
                    if 'event' in userDf:
                        windUser['repairedTurbine'] = \
                            True in userDf.event.isin(['repair.turbine']).unique()
                    # Changed simulation speed
                    if 'event' in userDf:
                        windUser['changedSimSpeed'] = \
                            True in userDf.event.isin(['configure.simulation_speed']).unique()           
                    windUsers.append(windUser)
            except Exception as e:
                print ("Somthing went wrong: %s" % e)
    #print(json.dumps(windUsers, indent=4))
    print('Inserting users into database...')
    
    
    db.windUser.delete_many({})
    try:     
        #for windUser in windUsers:
            #windUser['_id'] = ObjectId()
            #db.windUser.insert_one(windUser)
        db.windUser.insert_many(windUsers)
    except Exception as e:
        print ("Somthing went wrong with inserting users into the database: %s" % e)