from pymongo import MongoClient
mongoClient = MongoClient('127.0.0.1')
db = mongoClient.envisage

windLocales = db.wind.distinct("locale")
for item in windLocales:
    print(item)
bondingLocales = db.bonding.distinct("locale")
for item in bondingLocales:
    print(item)
