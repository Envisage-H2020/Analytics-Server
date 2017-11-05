from pymongo import MongoClient
import pandas as pd


# Open periodic table
def PeriodicTableCount(df):
    temp = df.loc[df['event'] == 'help.periodic_table']
    return temp.shape[0]  # Number of rows found = usage count


# Write formula
def WriteFormula(df, molecule):
    selects = df.loc[df['event'] == 'select.molecule']
    if 'event_id' in selects.columns:
        selects = selects.loc[selects['event_id'] == molecule]
    else:
        selects = selects.iloc[0:0]
    if selects.shape[0] > 0:
        checks = df.loc[df['event'] == 'check.bond']
        if 'event_id' in checks.columns:
            checks = checks.loc[checks['event_id'] == molecule]
        print(selects.shape, checks.shape)


mongoClient = MongoClient('127.0.0.1')
db = mongoClient.envisage

usersLookup = db.bonding.distinct('user_id')
for user in usersLookup:
    entryLookup = db.bonding.find({'user_id': user})
    dataBuffer = list()
    for entry in entryLookup:
        dataBuffer.append(entry)
    userDf = pd.DataFrame(dataBuffer)
    PeriodicTableCount(userDf)
    WriteFormula(userDf, 'HCl')




# Choose bond type

# Count attempts
