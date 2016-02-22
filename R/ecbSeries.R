##' Download specified data series from the ECB SDW
##'
##' @title ecbSeries: download matching data series from the ECB SDW
##' @param datasetId Dataset ID, typically in the following format:
##'     EXT_[3-letter flowRef (see below)][#]
##' @param pattern Pattern specifying the data series names to be downloaded
##' @return Downloaded dataset. It contains a DSD attribute, which can be useful
##'     in labeling data series.
##' @author Janko Cizel
##' @export
ecbSeries <-
    function(
             datasetId = 'ECB_AME1',
             pattern = ".GBR.....ZUTN"
             ){
        message(rep("*",70))
        message("ECB SDW Downloader")
        message("By Janko Cizel, 2016. All rights reserved.")
        message("www.jankocizel.com")
        message(rep("*",70))

        try(get_matching_series(datasetId = datasetId,
                                pattern = pattern)) ->
            data

        if ("try-error" %in% class(data)){
            message("Execution of the function resulted in an error. A likely source of error is that you misspecified the series pattern. Note that the number of dots in the supplied pattern must match the number of dimensions in the dataset. To further explore the dimensions in the dataset, use the following call:")
            message(sprintf("get_datastructure(dataset = '%s')",
                            datasetId))
        }
        
        message(rep("*",70))
        message("Thank you for using the package.")
        message("In case of errors or suggestions do not hesitate to contact me via:\n")
        message('www.jankocizel.com')
        message(rep("*",70))

        return(data)
    }


## ecbSeries(
##     datasetId = 'ECB_AME1',
##     pattern = ".GBR.....ZUTN"
## ) ->
##     data
