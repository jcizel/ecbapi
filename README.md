ecbapi: R Interface to the ECB Statistical Data Warehouse
======================

**This repository** provides an R interface to the [ECB SDW](http://sdw.ecb.europa.eu).

##Installation
```r
install.packages('devtools') ## Only if you don't have it installed yet..
devtools::install_github("jcizel/ecbapi")
require(ecbapi)

## THIS RETURNS THE FOLLOWING:
## **********************************************************************
## ECB SDW Downloader
## By Janko Cizel, 2016. All rights reserved.
## www.jankocizel.com
## **********************************************************************
## Default ECB SDW access point (external):
## https://sdw-wsrest.ecb.europa.eu
## **********************************************************************
## To view all available datasets, use the following query:
## ecbAvailability()
## To download entire dataset, use the following query:
## ecbDataset(datasetId = '[Input datasetId]')
## To download only matching series from a dataset, use the following query:
## ecbSeries(datasetId = '[Input datasetId]',pattern = '[series pattern]')
## **********************************************************************
## Thank you for using the package.
## In case of errors or suggestions do not hesitate to contact me via:
## www.jankocizel.com
## **********************************************************************
```

## Quick Demonstration

```r
## By default the package relies on the external ECB SDW site.
## To change to the internal version, type the following:
## options(sdw.loc = 'internal')

## Step 1: View all available datasets:
ecbAvailability()
## THIS RETURNS THE FOLLOWING:
## **********************************************************************
## The following datasets are currently available via the ECB SDW API:
##           datasetId                                        datasetName
##  1:        ECB_AME1                                              AMECO
##  2:        ECB_BKN1                               Banknotes Statistics
##  3:        ECB_BLS1                     Bank Lending Survey Statistics
##  4:        ECB_BOP1 Balance of Payments, I.I.P. and Reserve Assets Sta
##  5:        ECB_BSI1                                Balance Sheet Items
##  6:        ECB_CBD1            Statistics on Consolidated Banking Data
##  7:        ECB_CBD2            Statistics on Consolidated Banking Data
##  8:        ECB_CCP1           Central Counterparty Clearing Statistics
##  9:        ECB_CPP3               Commercial property price statistics
## 10:        ECB_DCM1                                           Dealogic
## 11:         ECB_DD1                                       Derived Data
## 12:        ECB_EON1                                Internal Eonia Rate
## 13:        ECB_ESA1                            ESA95 National Accounts
## 14:        ECB_EXR1                                     Exchange Rates
## 15:        ECB_FCT1                                           Forecast
## 16:        ECB_FMD2 Financial market data (not related to foreign exch
## 17:        ECB_FVC1 Financial Vehicle Corporation Assets and Liabiliti
## 18:        ECB_GST1                              Government Statistics
## 19:        ECB_ICP1                         Indices of Consumer Prices
## 20:        ECB_IFI1                Indicators of Financial Integration
## 21:        ECB_ILM1                      Internal Liquidity Management
## 22:        ECB_IRS1 Interest Rate Statistics (2004 EU Member States &
## 23:        ECB_IVF1                                   Investment Funds
## 24:        ECB_LIG1                   Large Insurance Group Statistics
## 25:        ECB_MFI1      MFI - List of monetary financial institutions
## 26:        ECB_MIR1                       MFI Interest Rate Statistics
## 27:        ECB_MMS1                                Money Market Survey
## 28:        ECB_OFI1                     Other Financial Intermediaries
## 29:        ECB_PSS1                     Payment and Settlement Systems
## 30:        ECB_RAI1                         Risk Assessment Indicators
## 31:        ECB_RIR2                              Retail Interest Rates
## 32:        ECB_RPP1              Residential Property Price Indicators
## 33:        ECB_RTD1 Real Time Database (context of Euro Area Business
## 34:        ECB_SAFE Survey on the Access to Finance of Small and Mediu
## 35:        ECB_SEC1                                         Securities
## 36:        ECB_SEE1           Securities Exchange (trading) Statistics
## 37:        ECB_SHS6                      Securities Holding Statistics
## 38:        ECB_SSI1          Banking Structural Statistical Indicators
## 39:        ECB_SSS1                   Securities Settlement Statistics
## 40:        ECB_STP1        Short-Term European Paper Statistics (STEP)
## 41:        ECB_STS1                              Short-Term Statistics
## 42:        ECB_TGB1                                    Target Balances
## 43:        ECB_TRD1                                     External Trade
## 44:        ECB_WTS1 Overall, Import, Export and Double Export Weights
## 45: EUROSTAT_BOP_01                       Eurostat Balance of Payments
##           datasetId                                        datasetName
## **********************************************************************
## To download entire dataset, use the following query:
## ecbDataset(datasetId = '[Input datasetId]')
## To download only matching series from a dataset, use the following query:
## ecbSeries(datasetId = '[Input datasetId]',pattern = '[series pattern]')
## **********************************************************************
## Thank you for using the package.
## In case of errors or suggestions do not hesitate to contact me via:
## www.jankocizel.com
## **********************************************************************
{% raw %}
{% endraw %}
## Step 2: Download desired dataset. For example, if we want the AMECO db:
ecbDataset(datasetId = 'ECB_AME1') ->
data
data %>>% str
## THIS RETURNS THE FOLLOWING:
## Classes ‘data.table’ and 'data.frame': 4184 obs. of  17 variables:
##  $ id                    : chr  "A.AUT.1.0.0.0.OVGD" "A.AUT.1.0.0.0.OVGD" "A.AUT.1.0.0.0.OVGD" "A.AUT.1.0.0.0.OVGD" ...
##  $ FREQ                  : chr  "A" "A" "A" "A" ...
##  $ AME_REF_AREA          : chr  "AUT" "AUT" "AUT" "AUT" ...
##  $ AME_TRANSFORMATION    : chr  "1" "1" "1" "1" ...
##  $ AME_AGG_METHOD        : chr  "0" "0" "0" "0" ...
##  $ AME_UNIT              : chr  "0" "0" "0" "0" ...
##  $ AME_REFERENCE         : chr  "0" "0" "0" "0" ...
##  $ AME_ITEM              : chr  "OVGD" "OVGD" "OVGD" "OVGD" ...
##  $ FREQ.LAB              : chr  "Annual" "Annual" "Annual" "Annual" ...
##  $ AME_REF_AREA.LAB      : chr  "Austria" "Austria" "Austria" "Austria" ...
##  $ AME_TRANSFORMATION.LAB: chr  "Original data and moving arithmetic mean"
##  $ AME_AGG_METHOD.LAB    : chr  "Standard aggregation" "Standard aggregation"
##  $ AME_UNIT.LAB          : chr  "National currency" "National currency" "National currency" "National currency" ...
##  $ AME_REFERENCE.LAB     : chr  "No reference" "No reference" "No reference" "No reference" ...
##  $ AME_ITEM.LAB          : chr  "Gross domestic product at 2010 market prices" "Gross domestic product at 2010 market prices" "Gross domestic product at 2010 market prices" "Gross domestic product at 2010 market prices" ...
##  $ date                  : chr  "1960" "1961" "1962" "1963" ...
##  $ value                 : num  69.4 73.1 74.9 77.9 82.6 ...
##  - attr(*, "sorted")= chr "AME_ITEM"
##  - attr(*, ".internal.selfref")=<externalptr>
##  - attr(*, "dsd")=List of 2)))

## Step 2 (alternative): Download only matching series from the desired dataset.
## For example, download all available ZUTN series in AMECO:
ecbSeries(datasetId = 'ECB_AME1',pattern = "......ZUTN")

## Classes ‘data.table’ and 'data.frame': 1204 obs. of  17 variables:
##  $ id                    : chr  "A.AUT.1.0.0.0.ZUTN" "A.AUT.1.0.0.0.ZUTN" "A.AUT.1.0.0.0.ZUTN" "A.AUT.1.0.0.0.ZUTN" ...
##  $ FREQ                  : chr  "A" "A" "A" "A" ...
##  $ AME_REF_AREA          : chr  "AUT" "AUT" "AUT" "AUT" ...
##  $ AME_TRANSFORMATION    : chr  "1" "1" "1" "1" ...
##  $ AME_AGG_METHOD        : chr  "0" "0" "0" "0" ...
##  $ AME_UNIT              : chr  "0" "0" "0" "0" ...
##  $ AME_REFERENCE         : chr  "0" "0" "0" "0" ...
##  $ AME_ITEM              : chr  "ZUTN" "ZUTN" "ZUTN" "ZUTN" ...
##  $ FREQ.LAB              : chr  "Annual" "Annual" "Annual" "Annual" ...
##  $ AME_REF_AREA.LAB      : chr  "Austria" "Austria" "Austria" "Austria" ...
##  $ AME_TRANSFORMATION.LAB: chr  "Original data and moving arithmetic mean" "Original data and moving arithmetic mean" "Original data and moving arithmetic mean" "Original data and moving arithmetic mean" ...
##  $ AME_AGG_METHOD.LAB    : chr  "Standard aggregation" "Standard aggregation" "Standard aggregation" "Standard aggregation" ...
##  $ AME_UNIT.LAB          : chr  "National currency" "National currency" "National currency" "National currency" ...
##  $ AME_REFERENCE.LAB     : chr  "No reference" "No reference" "No reference" "No reference" ...
##  $ AME_ITEM.LAB          : chr  "Unemployment rate - total - Member States - definition EUROSTAT" "Unemployment rate - total - Member States - definition EUROSTAT" "Unemployment rate - total - Member States - definition EUROSTAT" "Unemployment rate - total - Member States - definition EUROSTAT" ...
##  $ date                  : chr  "1960" "1961" "1962" "1963" ...
##  $ value                 : num  2.6 2 2 2.2 2.1 2 1.9 2 2.1 2.1 ...
##  - attr(*, "sorted")= chr "AME_ITEM"
##  - attr(*, ".internal.selfref")=<externalptr>
##  - attr(*, "dsd")=List of 2

ecbSeries(datasetId = 'ECB_AME1',pattern = ".FRA.....ZUTN") ## Only France
## Classes ‘data.table’ and 'data.frame': 58 obs. of  17 variables:
##  $ id                    : chr  "A.FRA.1.0.0.0.ZUTN" "A.FRA.1.0.0.0.ZUTN" "A.FRA.1.0.0.0.ZUTN" "A.FRA.1.0.0.0.ZUTN" ...
##  $ FREQ                  : chr  "A" "A" "A" "A" ...
##  $ AME_REF_AREA          : chr  "FRA" "FRA" "FRA" "FRA" ...
##  $ AME_TRANSFORMATION    : chr  "1" "1" "1" "1" ...
##  $ AME_AGG_METHOD        : chr  "0" "0" "0" "0" ...
##  $ AME_UNIT              : chr  "0" "0" "0" "0" ...
##  $ AME_REFERENCE         : chr  "0" "0" "0" "0" ...
##  $ AME_ITEM              : chr  "ZUTN" "ZUTN" "ZUTN" "ZUTN" ...
##  $ FREQ.LAB              : chr  "Annual" "Annual" "Annual" "Annual" ...
##  $ AME_REF_AREA.LAB      : chr  "France" "France" "France" "France" ...
##  $ AME_TRANSFORMATION.LAB: chr  "Original data and moving arithmetic mean" "Original data and moving arithmetic mean" "Original data and moving arithmetic mean" "Original data and moving arithmetic mean" ...
##  $ AME_AGG_METHOD.LAB    : chr  "Standard aggregation" "Standard aggregation" "Standard aggregation" "Standard aggregation" ...
##  $ AME_UNIT.LAB          : chr  "National currency" "National currency" "National currency" "National currency" ...
##  $ AME_REFERENCE.LAB     : chr  "No reference" "No reference" "No reference" "No reference" ...
##  $ AME_ITEM.LAB          : chr  "Unemployment rate - total - Member States - definition EUROSTAT" "Unemployment rate - total - Member States - definition EUROSTAT" "Unemployment rate - total - Member States - definition EUROSTAT" "Unemployment rate - total - Member States - definition EUROSTAT" ...
##  $ date                  : chr  "1960" "1961" "1962" "1963" ...
##  $ value                 : num  1.6 1.4 1.6 1.6 1.2 1.5 1.6 2.1 2.6 2.2 ...
##  - attr(*, "sorted")= chr "AME_ITEM"
##  - attr(*, ".internal.selfref")=<externalptr>
##  - attr(*, "dsd")=List of
```
