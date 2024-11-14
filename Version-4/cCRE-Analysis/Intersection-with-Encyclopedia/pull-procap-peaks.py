import sys, json, urllib.request, urllib.parse, urllib.error
import urllib.request
import base64

def Process_Token():
    credentials=open("/home/moorej3/.encode.txt")
    credArray=next(credentials).rstrip().split("\t")
    return credArray[0], credArray[1]

def Retrieve_Biosample_Summary(dataset, creds):
    try:
        url = "https://www.encodeproject.org/"+dataset+"/?format=json"
        dataDir="/data/projects/encode/json/exps/"+dataset
        json_data=open(dataDir+".json").read()
        data = json.loads(json_data)
    except:
        url = "https://www.encodeproject.org/"+dataset+"/?format=json"
        request = urllib.request.Request(url)
        request.add_header("Authorization", "Basic %s" % creds)
        response = urllib.request.urlopen(request)
        data = json.loads(response.read())
    name=data["biosample_ontology"]["term_name"]
    bidirect = "NA"
    unidirect = "NA"
    for entry in data["files"]:
        if entry["output_type"] == "bidirectional peaks":
            bidirect = entry["accession"]
        elif entry["output_type"] == "unidirectional peaks":
            unidirect = entry["accession"]
    print((dataset+"\t"+unidirect+"\t"+bidirect+"\t"+name))


usrname, psswd = Process_Token()
base64string = base64.b64encode(bytes('%s:%s' % (usrname,psswd),'ascii'))
creds = base64string.decode('utf-8')

url="https://www.encodeproject.org/search/?type=Experiment&control_type!=*&status=released&perturbed=false&assay_title=PRO-cap&format=json&limit=all"

request = urllib.request.Request(url)
request.add_header("Authorization", "Basic %s" % creds)
response = urllib.request.urlopen(request)
data = json.loads(response.read())

for entry in data["@graph"]:
    Retrieve_Biosample_Summary(entry["accession"], creds)
