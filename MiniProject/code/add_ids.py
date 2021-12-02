import pandas as pd
import scipy as sc

growth_data = pd.read_csv("../data/LogisticGrowthData.csv")
meta_data = pd.read_csv("../data/LogisticGrowthMetaData.csv")

growth_data.insert(0, "ID", growth_data.Species + "_" + growth_data.Temp.map(str) + "_" + \
    growth_data.Medium + "_" + growth_data.Citation)

# Replace IDs with a unique number for each combination
ids = range(1,len(growth_data.ID.unique()) + 5)
uniques = growth_data.ID.unique()
for i in range(0, len(growth_data.ID.unique())):
        growth_data['ID'] = growth_data.ID.replace(to_replace = uniques[i],\
                                 value =  ids[i])
        
growth_data.to_csv("../data/EditedDataSet.csv")