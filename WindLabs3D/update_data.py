from get_lab_data import GetLabData, RefreshDataInMongoDB
from calculate_bonding_features import CalculateBondingFeatures
from calculate_wind_features import CalculateWindFeatures
from write_to_csv import WriteToCsv
from data_cleaner import CleanData
# from generate_html import GenerateHTML

# Windlab
wind_app_key = 'REDACTED'
wind_api_key = 'REDACTED'
wind_master_key = 'REDACTED'

# Naming molecules
naming_app_key = 'REDACTED'
naming_api_key = 'REDACTED'
naming_master_key = 'REDACTED'

# Building organic molecules
organic_app_key = 'REDACTED'
organic_api_key = 'REDACTED'
organic_master_key = 'REDACTED'

# Building inorganic molecules (bonding)
bonding_app_key = 'REDACTED'
bonding_api_key = 'REDACTED'
bonding_master_key = 'REDACTED'

# Wind
goedle_app_key = 'REDACTED'
goedle_master_key = 'REDACTED'

headers = {'X-goedle-app-key': goedle_app_key,
           'X-goedle-master-key': goedle_master_key}

GetLabData(wind_app_key,
           wind_master_key,
           'WindLab.json', 'wind')
           
GetLabData(bonding_app_key,bonding_master_key,'BondingLab.json', 'bonding')

RefreshDataInMongoDB('BondingLab.json', 'bonding')

RefreshDataInMongoDB('WindLab.json', 'wind')

CalculateWindFeatures()
CalculateBondingFeatures()
WriteToCsv()
# GenerateHTML()
