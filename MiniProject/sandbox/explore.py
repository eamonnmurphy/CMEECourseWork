import pandas as pd
import scipy as sc
import matplotlib.pylab as plt
import seaborn as sns

data = pd.read_csv("../data/LogisticGrowthData.csv")
print("Loaded {} columns".format(len(data.columns.values)))

print(data.columns.values)

pd.read_csv("../data/LogisticGrowthMetaData.csv")

data.head()

print(data.PopBio_units.unique())
print(data.Time_units.unique())

data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + \
    data.Medium + "_" + data.Citation)

print(data.ID.unique())

data_subset = data[data['ID']=='Chryseobacterium.balustinum_5_TSB_Bae, Y.M., Zheng, L., Hyun, J.E., Jung, K.S., Heu, S. and Lee, S.Y., 2014. Growth characteristics and biofilm formation of various spoilage bacteria isolated from fresh produce. Journal of food science, 79(10), pp.M2072-M2080.']
data_subset.head()

sns.lmplot("Time", "PopBio", data = data_subset, fit_reg = False)
plt.show()