import sys, json, urllib.request, urllib.parse, urllib.error
import base64

def Process_Token():
    credentials=open("/zata/zippy/moorej3/.encode.txt")
    credArray=next(credentials).rstrip().split("\t")
    return credArray[0], credArray[1]

def Retrieve_Biosample_Summary(dataset, bigWig, creds):
    try:
        dataDir="/data/projects/encode/json/exps/"+dataset
        json_data=open(dataDir+".json").read()
        data = json.loads(json_data)
    except:
        url = "https://www.encodeproject.org/"+dataset+"/?format=json"
        request = urllib.request.Request(url)
        request.add_header("Authorization", "Basic %s" % creds)
        response = urllib.request.urlopen(request)
        data = json.loads(response.read())
    
    summary = data["biosample_summary"]
    bioType = data["biosample_ontology"]["classification"]

    nameArray = []
    sexArray = []
    stageArray = []
    donorArray = []
    treatmentArray = []
    diseaseArray = []

    if bioType == "cell line":
        if "cancer cell" in data["biosample_ontology"]["cell_slims"]:
            print(dataset+"\t"+bigWig+"\t"+"cancer cell")
        elif "stem cell" in data["biosample_ontology"]["cell_slims"]:
            print(dataset+"\t"+bigWig+"\t"+"stem cell")
        else:
            print(dataset+"\t"+bigWig+"\t"+"other cell")
    elif bioType == "tissue":
        for rep in data["replicates"]:
            stage = rep["library"]["biosample"]["donor"]["life_stage"]
        print(dataset+"\t"+bigWig+"\t"+stage+" tissue")
    else:
        print(dataset+"\t"+bigWig+"\t"+bioType)



usrname, psswd = Process_Token()
base64string = base64.b64encode(bytes('%s:%s' % (usrname,psswd),'ascii'))
creds = base64string.decode('utf-8')

for line in open(sys.argv[1]):
        line=line.rstrip().split("\t")
        typ = Retrieve_Biosample_Summary(line[0],line[2], creds)
