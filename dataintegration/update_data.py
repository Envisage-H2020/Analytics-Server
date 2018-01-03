from get_lab_data import GetLabData, RefreshDataInMongoDB
from calculate_bonding_features import CalculateBondingFeatures
from calculate_wind_features import CalculateWindFeatures
from write_to_csv import WriteToCsv
from generate_html import GenerateHTML

# Windlab
wind_app_key = '90e167a8ba993ab18f52ec7fdb44fdea'
wind_api_key = '218f2f9f41d9f86da2fb4bd74eea4ce7'
wind_master_key = 'f461126b1ec2a7be13213bae67dd3f37'

# Naming molecules
naming_app_key = '68a75926033f70179b19a9ccd135d5ff'
naming_api_key = '4b90b2efc419286827c2fde682b463eb'
naming_master_key = '366eeac924d437418b35b74945beb346'

# Building organic molecules
organic_app_key = 'dfe7477e650834992e8f4361d4236dd9'
organic_api_key = '6a9ef3b319b01ba2dfd495639fd48994'
organic_master_key = 'aefd30c303d96aedc713990b6ac1e617'

# Building inorganic molecules (bonding)
bonding_app_key = '1be7657730b3f55161a1a38dbec10096'
bonding_api_key = '335ee0f08c401bd1ef2c3c925a7a64f0'
bonding_master_key = 'faf156e496225274c8cfc1a91f6d1a4d'

# Wind
goedle_app_key = '90e167a8ba993ab18f52ec7fdb44fdea'
goedle_master_key = 'f461126b1ec2a7be13213bae67dd3f37'

headers = {'X-goedle-app-key': goedle_app_key,
           'X-goedle-master-key': goedle_master_key}

GetLabData(wind_app_key,
           wind_master_key,
           'WindLab.json', 'wind')
GetLabData(bonding_app_key,
           bonding_master_key,
           'BondingLab.json', 'bonding')

RefreshDataInMongoDB('BondingLab.json', 'bonding')
CalculateWindFeatures()
CalculateBondingFeatures()
WriteToCsv()
GenerateHTML()
