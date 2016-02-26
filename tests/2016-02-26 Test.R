require(ecbapi)

ecbAvailability()

ecbDataset('EUROSTAT_BOP_01') ->
    data

data %>>% info
data %>>% info('BS_ITEM')


data %>>%
    subset(BS_ITEM == 'L23') %>>% (date) %>>% table



datasetId = 'EUROSTAT_BOP_01'

dataid2flowref(datasetId)
