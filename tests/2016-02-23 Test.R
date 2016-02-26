

ecbDataset('ECB_EXR1') -> dt

dt %>>% info
dt %>>% info('FREQ')
dt %>>% info('CURRENCY')
dt %>>% info('CURRENCY_DENOM')
dt %>>% info('EXR_TYPE')
dt %>>% info('EXR_SUFFIX')

dt %>>%
    subset(CURRENCY_DENOM == 'EUR') %>>%
    subset(FREQ == 'D') %>>%
    subset(EXR_TYPE == 'EN00') %>>%
    subset(EXR_SUFFIX == 'A') %>>%
    subset(date == '2016-02-23')
    (date) %>>% table
