##' Download entire dataset from ECB SDW.
##'
##' 
##' @title get_dataset: download entire dataset from ECB SDW 
##' @param datasetId Dataset ID, typically in the following format:
##'     EXT_[3-letter flowRef (see below)][#]
##' @param flowRef Optional argument. By default it is assumed that flowRef is
##'     contained in the datasetId code (see above).
##' @return Downloaded dataset. It contains a DSD attribute, which can be useful
##'     in labeling data series.
##' @author Janko Cizel
##' 
get_dataset <-
    function(
             datasetId = 'ECB_AME1',
             flowRef= substr(datasetId,5,7)
             ){
        ## Get desired dataset
        get_data(dataset = flowRef) ->
            data

        get_datastructure(dataset = datasetId) ->
            dsd

        idref <- (dsd[[1L]] %>>% (varcode))

        cbind(
            id = (data %>>%
                  select(
                      one_of(idref)
                  ) %>>%
                  (dt~do.call('paste', c(dt,list(sep = '.'))))),
            data %>>%
                select(
                    one_of(idref),
                    date,
                    value
                ) 
        ) ->
            data

        l <- list()
        for (x in idref){
            dsd[[2L]][[dsd[[1L]][varcode == x][['codelist']]]] ->
                lookup    
        (lookup %>>%
         setkey(id))[data %>>%
                         setkeyv(x)] %>>%
            (name) ->
            l[[x]]   
        }

        names(l) <-
            sprintf("%s.LAB",
                    names(l))

        ## l %>>%
        ##     (dt~do.call('paste', c(dt,list(sep = '|')))) ->
        ##     label
        

        cbind(
            data %>>% select(-date,-value),
            l %>>% as.data.table,
            data %>>% select(date,value)            
        ) %>>%
            mutate(
                value = value %>>% as.numeric
            ) ->
            data_res

        attr(data_res,
             'dsd') <- dsd
        
        return(data_res)
    }

## get_dataset(datasetId = 'ECB_AME1') ->
##     data

## attributes(data) %>>% (dsd) %>>% str(2)

