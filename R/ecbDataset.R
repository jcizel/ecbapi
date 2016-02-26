##' Download a specified dataset from the ECB SDW
##'
##' @title ecbDataset: download entire dataset from the ECB SDW 
##' @param datasetId Dataset ID, typically in the following format:
##'     EXT_[3-letter flowRef (see below)][#]
##' @return Downloaded dataset. It contains a DSD attribute, which can be useful
####'     in labeling data series.
##' @author Janko Cizel
##' @export
ecbDataset <-
    function(
             datasetId = 'ECB_AME1'
             ){
        message(rep("*",70))
        message("ECB SDW Downloader")
        message("By Janko Cizel, 2016. All rights reserved.")
        message("www.jankocizel.com")
        message(rep("*",70))

        get_dataset(datasetId = datasetId) ->
            data

        message(rep("*",70))
        message("Thank you for using the package.")
        message("In case of errors or suggestions do not hesitate to contact me via:\n")
        message('www.jankocizel.com')
        message(rep("*",70))

        return(data)
    }


## Test:
## ecbDataset(datasetId = 'ECB_AME1')

##' @export
dataid2flowref <- function(datasetId = 'ECB_AME1'){
    gsub("(.+)_(.+)(_[0-9]+)$","\\2",datasetId) ->    
        flowref

    return(flowref)
}

##' @export
dataid2provider <- function(datasetId = 'ECB_AME1'){
    gsub("(.+)_(.+)(_[0-9]+)$","\\1",datasetId) ->    
        flowref    

    return(flowref)
}
