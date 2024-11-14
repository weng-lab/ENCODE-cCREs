import sys, json, urllib.request, urllib.parse, urllib.error
import urllib.request
import base64

def Process_Token():
    credentials=open("/zata/zippy/moorej3/.encode.txt")
    credArray=next(credentials).rstrip().split("\t")
    return credArray[0], credArray[1]

def Retrieve_Biosample_Summary(dataset, genome, creds):
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
    name=data["biosample_summary"]
    try:
        typ=data["biosample_ontology"]["classification"]
    except:
        typ="NA"
    lab=data["lab"]["title"]
    try:
        donor=data["replicates"][0]["library"]["biosample"]["donor"]["accession"]
        bio=data["replicates"][0]["library"]["biosample"]["accession"]
        target=data["target"]["label"]
    except:
        donor="NA"
        bio="NA"
        target="NA"
    bed="NA"
    frip="NA"
    for entry in data["files"]:
        if entry["file_type"] == "bed narrowPeak" \
            and entry["status"] == "released" and entry["assembly"] == genome:
            if "preferred_default" in entry and entry["preferred_default"] == True:
                bed=entry["accession"]
                for qc in entry["quality_metrics"]:
                    if "frip" in qc:
                        frip = str(round(qc["frip"],4))
    rfa=data["award"]["rfa"]
    print((dataset+"\t"+bed+"\t"+name+"\t"+target+"\t"+rfa+"\t"+lab+"\t"+typ+"\t"+frip))

genome=sys.argv[1]
target=sys.argv[2]

usrname, psswd = Process_Token()
base64string = base64.b64encode(bytes('%s:%s' % (usrname,psswd),'ascii'))
creds = base64string.decode('utf-8')

if genome == "hg38":
    species = "Homo+sapiens"
    genome = "GRCh38"
elif genome == "mm10":
    species = "Mus+musculus"
    genome = "mm10"


url="https://www.encodeproject.org/search/?type=Experiment&control_type!=*&status=released" + \
    "&perturbed=false&target.label=" + target + \
    "&assay_title=Mint-ChIP-seq&assay_title=Histone+ChIP-seq" + \
    "&replicates.library.biosample.donor.organism.scientific_name=Homo+sapiens&format=json&limit=all"

request = urllib.request.Request(url)
request.add_header("Authorization", "Basic %s" % creds)
response = urllib.request.urlopen(request)
data = json.loads(response.read())

for entry in data["@graph"]:
    Retrieve_Biosample_Summary(entry["accession"], genome, creds)
