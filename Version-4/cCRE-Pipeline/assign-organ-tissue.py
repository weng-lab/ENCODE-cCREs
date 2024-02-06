#Jill Moore
#UMass Chan


import sys, json, urllib

def Retrieve_Biosample_Summary(dataset,bigWig):
#    url = "https://www.encodeproject.org/"+dataset+"/?format=json"
    dataDir="/data/projects/encode/json/exps/"+dataset
    json_data=open(dataDir+".json").read()
    data = json.loads(json_data) 
    try: 
        name=data["biosample_summary"]
    except:
        name="NA"
    try:
        rfa=data["award"]["rfa"]
    except:
        rfa="NA"
    try:
        typ=data["biosample_ontology"]["classification"]
    except:
        typ="NA"
    try:
        data["biosample_ontology"]["organ_slims"].sort()
        organ=";".join(data["biosample_ontology"]["organ_slims"])
    except:
        organ="NA"
    return typ, name, rfa, organ

genome = sys.argv[2]
for line in open(sys.argv[1]):
    
    line=line.rstrip().split("\t")
    typ, name, rfa, organ = Retrieve_Biosample_Summary(line[0].rstrip(),line[1])

    if genome == "GRCh38":
        if "blood vessel" in organ:
            organ = "blood vessel"
        elif "blood" in organ:
            organ = "blood"
        elif "brain" in organ:
            organ = "brain"
        elif "large intestine" in organ:
            organ = "large intestine"
        elif "kidney" in organ:
            organ = "kidney"
        elif "musculature of body" in organ:
            organ = "muscle"
        elif "skin of body" in organ:
            organ = "skin"
        elif "small intestine" in organ:
            organ = "small intestine"
        elif "ovary" in organ:
            organ = "ovary"
        elif "mammary gland" in organ:
            organ = "breast"
        elif "lung" in organ:
            organ = "lung"
        elif "heart" in organ:
            organ = "heart"
        elif "adipose" in organ:
            organ = "adipose"
        elif "adrenal" in organ:
            organ = "adrenal gland"
        elif "bone marrow" in organ:
            organ = "bone marrow"
        elif "breast" in organ:
            organ = "breast"
        elif "liver" in organ:
            organ = "liver"
        elif "thymus" in organ:
            organ = "thymus"
        elif "thyroid" in organ:
            organ = "thyroid"
        elif "spleen" in organ:
            organ = "spleen"
        elif "uterus" in organ:
            organ = "uterus"
        elif "placenta" in organ:
            organ = "placenta"
        elif "prostate" in organ:
            organ = "prostate"
        elif "testis" in organ:
            organ = "testis"
        elif "nerve" in organ:
            organ = "nerve"
        elif "Peyer" in name:
            organ = "small intestine"
        elif "pancreas" in organ:
            organ = "pancreas"
        elif "mouth" in organ:
            organ = "mouth"
        elif "esophagus" in organ:
            organ = "esophagus"
        elif "eye" in organ:
            organ = "eye"
        elif "penis" in organ:
            organ = "penis"
        elif "extraembryonic component" in organ:
            organ = "embryo"
        elif "embryo" in organ:
            organ = "embryo"
        elif "limb" in name:
            organ = "limb"
        elif "bone element" in organ:
            organ = "bone"
        elif "nose" in organ:
            organ = "nose"
        elif "connective tissue" in organ:
            organ = "connective tissue"
       
        if organ == "":
            if "neur" in name:
                organ = "brain"
            elif "cardio" in name:
                organ = "heart"
            elif "T cell" in name or "helper" in name or "DOHH2" in name or "SU-DHL-6" in name:
                organ = "blood"
            elif "Calu3" in name:
                organ = "lung"

            elif "endothelial" in name:
                organ = "endothelial"
            elif "GM" in name: #ATAC specific
                organ = "blood"       
            else:
                organ = "UNASSIGNED"

    elif genome == "mm10":
        if "thymus" in organ:
            organ = "thymus"
        elif "adrenal" in organ:
            organ = "adrenal gland"
        elif "blood" in organ:
            organ = "blood"        
        elif "liver" in organ:
            organ = "liver"  
        elif "spleen" in organ:
            organ = "spleen" 
        elif "testis" in organ:
            organ = "testis" 
        elif "musculature of body" in organ:
            organ = "muscle" 
        elif "bone marrow" in organ:
            organ = "bone marrow"   
        elif "ovary" in organ:
            organ = "ovary" 
        elif "large intestine" in organ:
            organ = "large intestine"  
        elif "small intestine" in organ:
            organ = "small intestine"  
        elif "adipose" in organ:
            organ = "adipose"
        elif "placenta" in organ:
            organ = "placenta"   
        elif "connective tissue" in organ:
            organ = "connective tissue" 
        elif "epithelium" in organ:
            organ = "epithelium"
        if organ == "":
            if "erythroid" in name:
                organ = "blood marrow"
            elif "cortex" in name:
                organ = "brain"
            elif "Muller" in name:
                organ = "eye"
            elif "leukemia" in name:
                organ = "blood marrow"
                                      
    print("\t".join(line)+"\t"+typ+"\t"+rfa, "\t", organ)
