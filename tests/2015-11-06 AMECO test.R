require(fame)
require(data.table)
require(rlist)
require(dplyr)
require(pipeR)
require(devtools)
require(ecbapi)

DIR.PACKAGES <- "//gimecb01/data/ECB business areas/DGE/DED/Monitoring and Analysis/09. Fiscal Policies (FIP)/Analytical Projects/2015 Cizel_CCW_OB_SovereignRisk/DSA Data Pipeline/Packages by JCizel/ecbapi"
setwd(DIR.PACKAGES)

list.files()

load_all()


## Get all tests
datasets <- ecbapi:::get_datasets()


## Get static info
ecbapi:::get_static(
    source = 'ECB',
    dataset = 'ECB_AME1'
) ->
    ameco_static

ameco_static %>>%
    names


## Download the latest version of AMECO Dataset
ecbapi:::get_ameco() ->
  ameco

ecbapi:::get_ameco_long() ->
  ameco_long

ecbapi:::get_ameco_wide() ->
  ameco_wide


ecbapi:::get_ameco_wide("ZUTN")
