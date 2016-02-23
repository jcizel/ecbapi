##' Reshape ecbDataset or ecbSeries outputs into a wide format
##'
##' 
##' @title ecbReshape: Reshape ecbDataset or ecbSeries outputs into a wide format
##' @param data Input dataset, which must be an output of "ecbDataset" or "ecbSeries" functions!
##' @param colId Name of a dimension that is to be transformed into columns
##' @return data.table in a wide format
##' @author Janko Cizel
##' @export
ecbReshape <-
    function(
             data,
             colId
             ){
        if (!"dsd" %in% (attributes(data) %>>% names)){
            stop('Input dataset must be an output of "ecbDataset" or "ecbSeries" functions!')
        }
        
        ## ecbDataset('ECB_AME1') ->
        ##     data

        data %>>% attributes %>>% (dsd) ->
            dsd

        dsd %>>% (key) ->
            keyinfo

        message("This are the available dimension to expand upon (i.e. to specify them as 'colId'):")
        print(keyinfo)        

        w = colId

        keyinfo %>>% (varcode) %>>%
            setdiff(w) ->
            ids

        c(
            ids,
            sprintf("%s.LAB",ids) 
        ) ->
            sel

        sprintf("%s + date ~ %s",
                sel %>>% paste(collapse = " + "),
                w) %>>%
            as.formula ->
            f

        message("Dataset reshaping will be done according to the following formula:")
        print(f)
        
        data %>>%
            dcast.data.table(
                f,
                value.var = 'value'
            ) ->
            data_wide

        data %>>% attributes %>>% (dsd) %>>% (codelists) %>>% (.[[keyinfo[varcode == w][['codelist']]]]) ->
            lookup


        attr(data_wide,'dsd') <- dsd
        attr(data_wide,'lookup') <- lookup
        attr(data_wide,'reshape.formula') <- f

        return(data_wide)
    }


## ecbDataset('ECB_AME1') ->
##     dt

## dt %>>% info

## dt %>>% ecbReshape('AME_ITEM') %>>%
##     subset(AME_REF_AREA == "SVN")
    
