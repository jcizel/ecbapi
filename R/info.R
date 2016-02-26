##' Get further information on the dataset
##'
##' @title info: get further information on the dataset 
##' @param data data Input dataset, which must be an output of "ecbDataset" or "ecbSeries" functions!
##' @return data.table with info on the dataset dimensions
##' @author Janko Cizel
##' @export
info <- function(data, dim = NULL){
    if (!"dsd" %in% (attributes(data) %>>% names)){
        stop('Input dataset must be an output of "ecbDataset" or "ecbSeries" functions!')
    }

    data %>>% attributes %>>% (dsd) ->
        dsd

    dsd %>>% (key) ->
        keyinfo

    message("This are the available dimension to expand upon (i.e. to specify them as 'colId'):")
    print(keyinfo)

    result = list()
    
    if (!is.null(dim)){
        dsd %>>% (codelists) %>>% (.[[keyinfo[varcode == dim][['codelist']]]]) %>>%
            setkey(id) ->
            lookup      
        
        data %>>% (.[[dim]]) %>>% table %>>%
            as.data.table %>>%
            rename(id = .) %>>%
            setkey(id) %>>%
            (lookup[.]) %>>%
            arrange(-N) ->
            diminfo

        message(sprintf("Additiona information on the dimension %s", dim))
        print(diminfo)
        result[['diminfo']] <- diminfo        
    }

    result[['keyinfo']] <- keyinfo
    
    return(result %>>% invisible)
}
