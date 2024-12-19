import sys, json, urllib.request, urllib.parse, urllib.error
import urllib.request

def Retrieve_Biosample_Summary(dataset, genome):
    try:
        url = "https://www.encodeproject.org/"+dataset+"/?format=json"
        dataDir="/data/projects/encode/json/exps/"+dataset
        json_data=open(dataDir+".json").read()
        data = json.loads(json_data)
    except:
        url = "https://www.encodeproject.org/"+dataset+"/?format=json"
        response = urllib.request.urlopen(url)
        data = json.loads(response.read())
    name=data["biosample_summary"]
    rfa=data["award"]["rfa"]
    lab=data["lab"]["title"]
    tag="NA"
    tags=data["internal_tags"]
    if "ENTEx" in tags:
        tag="ENTEx"
    lab=data["lab"]["title"]
    try:
        donor=data["replicates"][0]["library"]["biosample"]["donor"]["accession"]
        bio=data["replicates"][0]["library"]["biosample"]["accession"]
        target=data["target"]["label"]
        typ=data["biosample_ontology"]["classification"]
    except:
        donor="NA"
        bio="NA"
        target="NA"
        typ="NA"
    bed="NA"
    frip="NA"
    for entry in data["files"]:
        if entry["file_type"] == "bed narrowPeak" \
            and entry["status"] == "released" and entry["assembly"] == genome:
            if "preferred_default" in entry and entry["preferred_default"] == True:
                bed=entry["accession"]
    if bed != "NA":
        try:
            dataDir="/data/projects/encode/json/exps/"+dataset+"/"+bed
            json_data=open(dataDir+".json").read()
            data = json.loads(json_data)
        except:
            url = "https://www.encodeproject.org/"+bed+"/?format=json"
            response = urllib.request.urlopen(url)
            data = json.loads(response.read())    
        try:
            for qc in data["quality_metrics"]:
                if "frip" in qc:
                    frip=qc["frip"]
        except:
            frip="none"
    print((dataset+"\t"+bed+"\t"+name+"\t"+target+"\t"+str(frip)+"\t"+lab+"\t"+typ+"\t"+tag))

genome=sys.argv[1]

if genome == "hg38":
    species = "Homo+sapiens"
    genome = "GRCh38"
elif genome == "mm10":
    species = "Mus+musculus"
    genome = "mm10"

url="https://www.encodeproject.org/search/?type=Experiment&status=released"+ \
    "&perturbed=false&assay_title=TF+ChIP-seq&replicates.library.biosample"+ \
    ".donor.organism.scientific_name="+species+"&format=json&limit=all"

response = urllib.request.urlopen(url)
data = json.loads(response.read())

for entry in data["@graph"]:
    Retrieve_Biosample_Summary(entry["accession"], genome)
