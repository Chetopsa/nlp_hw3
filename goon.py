# circle jerk
from datasets import load_dataset
import numpy as np
import pandas as pd
import polars as pl
import os


  #####
 ########  
##########                                       #######
##########                                       #     ###     
##################################################        ##
                                                            #    
                                                  ###########  
                                                            #
##################################################        ## 
##########                                       #      ###
##########                                       ####### 
 ########
  ######
ds = load_dataset("stanfordnlp/sst2")
train = ds["train"]
val = ds["validation"]
test = ds["test"]

train.to_json("TrainingData.json")
val.to_json("ValidationData.json")
test.to_json("TestingData.json")



pl_train = pl.read_ndjson('./TrainingData.json' ).to_pandas()
print (pl_train.head())

