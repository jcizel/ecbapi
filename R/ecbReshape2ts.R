##' Reshape the outputs of 'ecbDataset' or 'ecbSeries' functions into a
##' series-based wide format 
##'
##'
##' @title ecbReshape2ts 
##' @param data Input dataset, which must be an output of "ecbDataset" or "ecbSeries" functions!
##' @return data.table in a wide format
##' @author Janko Cizel
##' @export
ecbReshape2ts <-
    function(
             data
             ){
        if (!"dsd" %in% (attributes(data) %>>% names)){
            stop('Input dataset must be an output of "ecbDataset" or "ecbSeries" functions!')
        }
        

        data %>>% attributes %>>% (dsd) ->
            dsd

        dsd %>>% (key) ->
            keyinfo



        sprintf("date ~ id") %>>%
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


        attr(data_wide,'keyinfo') <- keyinfo
        attr(data_wide,'dsd') <- dsd
        attr(data_wide,'reshape.formula') <- f

        return(data_wide)
    }
