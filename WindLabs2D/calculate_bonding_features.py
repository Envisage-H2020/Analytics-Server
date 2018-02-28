from pymongo import MongoClient
from bonding_user import BondingUser
from bonding_encoder import BondingEncoder
import pandas as pd
import json


# Open periodic table
def PeriodicTableCount(df):
    temp = df.loc[df['event'] == 'help.periodic_table']
    return temp.shape[0]  # Number of rows found = usage count


# Write formula
def AttemptCountWriteFormula(df, molecule):
    if 'event_id' in df:
        events = df.loc[(df['event'] == 'check.bond') &
                        (df['event_id'] == molecule)]
        return events.shape[0]
    return 0


# Write formula
def WriteFormula(df, molecule):
    timesOnTask = list()
    if 'event_id' in df:
        events = df.loc[((df['event'] == 'select.molecule') |
                         (df['event'] == 'check.bond')) &
                        (df['event_id'] == molecule)]
        if events.shape[0] > 2:
            events.sort_values(['ts'], ascending=True)
            listOfTs = list()

            item1 = None
            item2 = None

            for row in events.itertuples():
                if item1 is None:
                    if row.event == 'select.molecule':
                        item1 = row
                elif item1.event == 'select.molecule' and \
                        row.event == 'select.molecule':
                    item1 = row
                elif item1.event == 'select.molecule' and \
                        row.event == 'check.bond':
                    item2 = row
                    listOfTs.append(item1.ts)
                    listOfTs.append(item2.ts)
                    item1 = None
                    item2 = None

            if len(listOfTs) % 2 != 0:
                listOfTs = listOfTs[:-1]

            if len(listOfTs) > 0:
                for i in range(0, len(listOfTs), 2):
                    timeOnTask = abs((listOfTs[i + 1] - listOfTs[i]))
                    timesOnTask.append(timeOnTask)
        # if len(timesOnTask) > 0:
            # print(timesOnTask)
            # print(listOfTs)
    return timesOnTask


# Choose bond
def ChooseBond(df, molecule):
    timesOnTask = list()
    if 'event_id' in df:
        events = df.loc[((df['event'] == 'check.bond') |
                         (df['event'] == 'check.bond_type')) &
                        (df['event_id'] == molecule)]
        if events.shape[0] > 2:
            events.sort_values(['ts'], ascending=True)
            listOfTs = list()

            item1 = None
            item2 = None

            for row in events.itertuples():
                if item1 is None:
                    if row.event == 'check.bond':
                        item1 = row
                elif item1.event == 'check.bond' and \
                        row.event == 'check.bond':
                    item1 = row
                elif item1.event == 'check.bond' and \
                        row.event == 'check.bond_type':
                    item2 = row
                    listOfTs.append(item1.ts)
                    listOfTs.append(item2.ts)
                    item1 = None
                    item2 = None

            if len(listOfTs) % 2 != 0:
                listOfTs = listOfTs[:-1]

            if len(listOfTs) > 0:
                for i in range(0, len(listOfTs), 2):
                    timeOnTask = abs((listOfTs[i + 1] - listOfTs[i]))
                    timesOnTask.append(timeOnTask)
        # if len(timesOnTask) > 0:
            # print(timesOnTask)
            # print(listOfTs)
    return timesOnTask


def CalculateBondingFeatures():
    mongoClient = MongoClient('127.0.0.1')
    db = mongoClient.envisage

    molecules = ["HCl", "H2O", "NaF", "NaCl", "KBr", "CH4", "CaCl2", "CF4"]

    bondingUsers = list()
    usersLookup = db.bonding.distinct('user_id')
    for user in usersLookup:
        # Prepare user object
        bondingUser = BondingUser(user)

        # Get all entries from user
        entryLookup = db.bonding.find({'user_id': user})
        dataBuffer = list()
        for entry in entryLookup:
            dataBuffer.append(entry)
        userDf = pd.DataFrame(dataBuffer)

        # Periodic table help task
        bondingUser.periodicTableCount = PeriodicTableCount(userDf)

        # Write formula task
        completionCounts = 0
        writeFormula = dict()
        for molecule in molecules:
            key = 'writeFormula' + molecule
            attempts = WriteFormula(userDf, molecule)
            completionCounts += len(attempts)
            writeFormula[key] = attempts
        # if completionCounts > 0:
            # print("--- Write Formula ---")
            # print(completionCounts)
        bondingUser.writeFormula = writeFormula
        # Completion Count: Write formula
        bondingUser.completionCountWriteFormula = completionCounts

        # Choose bond type task
        completionCounts = 0
        chooseBond = dict()
        for molecule in molecules:
            key = 'chooseBond' + molecule
            attempts = ChooseBond(userDf, molecule)
            completionCounts += len(attempts)
            chooseBond[key] = attempts
        # if completionCounts > 0:
            # print("--- Choose Bond ---")
            # print(completionCounts)
        bondingUser.chooseBond = chooseBond
        # Completion Count: Choose Bond
        bondingUser.completionCountChooseBond = completionCounts

        # Attempt Count: Write Formula
        attemptCounts = 0
        attemptCountsWriteFormulas = dict()
        for molecule in molecules:
            key = 'attemptsWriteFormula' + molecule
            attempts = AttemptCountWriteFormula(userDf, molecule)
            attemptCounts += attempts
            attemptCountsWriteFormulas[key] = attempts
        # if attemptCounts > 0:
            # print("--- Attempts ---")
            # print(attemptCounts)
        bondingUser.attemptCountsWriteFormulas = attemptCountsWriteFormulas
        bondingUser.attemptCountsWriteFormula = attemptCounts

        # Assign user to dict
        # bondingUsers[user] = bondingUser
        bondingUsers.append(bondingUser)

    file = open('bondingData.json', 'w')
    jsonData = json.dumps(bondingUsers, cls=BondingEncoder, indent=4)
    file.write(jsonData)
    myList = json.loads(jsonData)

    mongoClient = MongoClient('127.0.0.1')
    db = mongoClient.envisage
    db.bondingUser.delete_many({})
    for entry in myList:
        db.bondingUser.insert_one(entry)
