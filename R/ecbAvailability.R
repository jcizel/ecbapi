##' See the available datasets at the ECB SDW
##'
##'
##' @title ecbAvailability: See which datasets are available via the ECB SDW 
##' @return data.table with the available datasets.
##' @author Janko Cizel
##' @export
ecbAvailability <-
    function(){
        message(rep("*",70))
        message("ECB SDW Downloader")
        message("By Janko Cizel, 2016. All rights reserved.")
        message("www.jankocizel.com")
        message(rep("*",70))
        
        get_datasets(source = 'ECB') ->
            data
        
        message(rep("*",70))
        message("The following datasets are currently available via the ECB SDW API:")
        print(data %>>%
                  mutate(
                      name = name %>>% substr(1,50)
                  ) %>>%
                  select(datasetId = id, datasetName = name))

        message(rep("*",70))
        
        message("To download entire dataset, use the following query:\n")
        message(sprintf("ecbDataset(datasetId = '[Input datasetId]')\n"))

        message("To download only matching series from a dataset, use the following query:\n")
        message(sprintf("ecbSeries(datasetId = '[Input datasetId]',pattern = '[series pattern]')\n"))

        message(rep("*",70))
        message("Thank you for using the package.")
        message("In case of errors or suggestions do not hesitate to contact me via:\n")
        message('www.jankocizel.com')
        message(rep("*",70))
        
        return(data %>>% invisible)
    }

## Test:
## ecbAvailability()
