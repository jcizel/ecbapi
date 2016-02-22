require(ecbapi)

## Get all available datasets provided by the ECB
get_datasets(source = 'ECB')

##                  id agencyID                                                             name
##  1:        ECB_AME1      ECB                                                            AMECO
##  2:        ECB_BKN1      ECB                                             Banknotes Statistics
##  3:        ECB_BLS1      ECB                                   Bank Lending Survey Statistics
##  4:        ECB_BOP1      ECB        Balance of Payments, I.I.P. and Reserve Assets Statistics
##  5:        ECB_BSI1      ECB                                              Balance Sheet Items
##  6:        ECB_CBD1      ECB                          Statistics on Consolidated Banking Data
##  7:        ECB_CBD2      ECB                          Statistics on Consolidated Banking Data
##  8:        ECB_CCP1      ECB                         Central Counterparty Clearing Statistics
##  9:        ECB_CPP3      ECB                             Commercial property price statistics
## 10:        ECB_DCM1      ECB                                                         Dealogic
## ....

## Get desired dataset
get_data(dataset = 'CPP') ->
    data

## Get data structure definition
##
## Instructions:
##  - go to http://sdw.ecb.europa.eu
##  - click "Site Map"
##  - text search "ameco"
##  - follow the link "AME - AMECO"
##  - click "DSD" link at the top half of the page
##  - click "Download SDMX 2.1 Schema of the ECB_AME1 DSD"
##  - copy the resulting URL and paste it as the argument of the
##"get_datastructure" function

get_datastructure(dataset = 'ECB_CPP3') ->
    dsd


idref <- (dsd[[1L]] %>>% (varcode))

cbind(
    id = (data %>>%
          select(
              one_of(idref)
          ) %>>%
          (dt~do.call('paste', c(dt,list(sep = '.'))))),
    data %>>%
        select(
            one_of(idref),
            date,
            value
        ) 
) ->
    data

l <- list()
for (x in idref){
    dsd[[2L]][[dsd[[1L]][varcode == x][['codelist']]]] ->
        lookup    
(lookup %>>%
 setkey(id))[data %>>%
                 setkeyv(x)] %>>%
    (name) ->
    l[[x]]   
}

l %>>%
    (dt~do.call('paste', c(dt,list(sep = '|')))) ->
    label

cbind(
    data,
    label = label
) %>>%
    select(
        id,label,date,value
    ) %>>%
    mutate(
        value = value %>>% as.numeric
    ) ->
    data_res


idref <- (dsd[[1L]] %>>% (varcode))


## Get static information about the dataset
get_static(
    source = 'ECB',
    dataset = 'ECB_AME1'
) ->
    ameco_static

get_multiple_series(dataset = 'AME', series_id = "*")
