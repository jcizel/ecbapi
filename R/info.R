##' Get further information on the dataset
##'
##' @title info: get further information on the dataset 
##' @param data data Input dataset, which must be an output of "ecbDataset" or "ecbSeries" functions!
##' @return data.table with info on the dataset dimensions
##' @author Janko Cizel
##' @export
info <- function(data){
    if (!"dsd" %in% (attributes(data) %>>% names)){
        stop('Input dataset must be an output of "ecbDataset" or "ecbSeries" functions!')
    }

    data %>>% attributes %>>% (dsd) ->
        dsd

    dsd %>>% (key) ->
        keyinfo

    message("This are the available dimension to expand upon (i.e. to specify them as 'colId'):")
    print(keyinfo)

    return(keyinfo %>>% invisible)
}
