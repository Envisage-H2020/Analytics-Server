from pymongo import MongoClient
import pandas as pd
import json
import statistics


def PowerRatios(df):
    result = dict()
    over = list()
    correct = list()
    under = list()
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
    if medianTimeOnTask > 100:
        medianTimeOnTask = 9  # This is the average in the current dataset
    overSum = sum(over)
    correctSum = sum(correct)
    underSum = sum(under)
    totalSum = overSum + correctSum + underSum
    overRatio = 0
    correctRatio = 0
    underRatio = 0
    if overSum > 0:
        overRatio = overSum / totalSum
    if correctSum > 0:
        correctRatio = correctSum / totalSum
    if underSum > 0:
        underRatio = underSum / totalSum
    if overRatio + correctRatio + underRatio > 0.99:
        result['over'] = overRatio
        result['correct'] = correctRatio
        result['under'] = underRatio
        result['medianTimeOnTask'] = medianTimeOnTask
        # print(medianTimeOnTask)
    return result


def CalculateWindFeatures():
    mongoClient = MongoClient('127.0.0.1')
    db = mongoClient.envisage

    windUsers = list()
    usersLookup = db.wind.distinct('user_id')

    for user in usersLookup:
        # Prepare user object
        windUser = dict()

        # Get all entries from user
        entryLookup = db.wind.find({'user_id': user})
        dataBuffer = list()
        for entry in entryLookup:
            dataBuffer.append(entry)
        userDf = pd.DataFrame(dataBuffer)
        # Power status ratios
        windUser['userId'] = user
        windUser['powerStats'] = PowerRatios(userDf)
        # Reached correct power
        if 'event_value' in userDf:
            windUser['correctPower'] = \
                True in userDf.event_value.isin(['-Correct power']).unique()
        # Added turbine
        if 'event' in userDf:
            windUser['addTurbine'] = \
                True in userDf.event.isin(['add.turbine']).unique()
        # Turbine on/off
        if 'event' in userDf:
            windUser['turbineOnOff'] = \
                (True in userDf.event.isin(['disable.turbine']).unique() or
                    True in userDf.event.isin(['enable.turbine']).unique())
        # Repaired turbine
        if 'event' in userDf:
            windUser['repairedTurbine'] = \
                True in userDf.event.isin(['repair.turbine']).unique()
        # Changed wind speed
        if 'event' in userDf:
            windUser['changedWind'] = \
                True in userDf.event.isin(['configure.wind_speed']).unique()
        # Changed power requirements
        if 'event' in userDf:
            windUser['changedPower'] = \
                True in userDf.event.isin(['configure.power']).unique()
        # Changed simulation speed
        if 'event' in userDf:
            windUser['changedSimSpeed'] = \
                True in userDf.event.isin(['configure.simulation_speed']).unique()
        windUsers.append(windUser)

    print(json.dumps(windUsers, indent=4))
    db.windUser.delete_many({})
    db.windUser.insert_many(windUsers)
