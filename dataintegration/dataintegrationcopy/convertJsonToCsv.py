# et bibliotek at methoder relateret
# til json formattet, vi skal bruge
import json

files = ["Bonding.json", "NamingMoleculeData.json",
         "OrganicData.json", "WindData.json"]

# files = ["Bonding.json", "NamingMoleculeData.json",
#          "OrganicData.json"]
# files = ["WindData.json"]

for file in files:
    print("Starting on file:" + file)
    filepath = file  # den fil vi åbner
    headers = set([])  # et sted til at samle headerne
    values = []  # et sted til værdierne
    with open(filepath) as f:
        for line in f:
            parsedJson = json.loads(line)
            # print(parsedJson);
            values.append(parsedJson)
            for header in parsedJson.keys():
                # print('header '+header)
                headers.add(header)
    outfile = open(file + ".csv", 'w')
    outfile.write('\t'.join(sorted(headers)) + '\n')
    counter = 0
    for value in values:
        counter += 1
        print(counter)
        # print('----------------')
        curLine = []
        for head in sorted(headers):

            if head in value:
                # print(' head = ' + str(head) +
                #       ' value[head] = ' + str(value[head]))
                curLine.append(str(value[head]))
            else:
                curLine.append('')
        outfile.write('\t'.join(curLine) + '\n')
    outfile.close()
