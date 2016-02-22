get_matching_series <-
    function(
             datasetId = 'ECB_AME1',
             flowRef= substr(datasetId,5,7),
             pattern = ".GBR....."
             ){

        get_datastructure(dataset = datasetId) ->
            dsd

        dsd[['key']] %>>%
            (varcode) %>>%
            (~ . -> idref) %>>%
            (~ . %>>% length -> query.len) %>>%
            sprintf(fmt = "[%s]") %>>%
            paste(collapse = '.') ->
            query.req

        rep('',times = query.len)  %>>%
            paste(collapse = '.') ->
            query.all

        message("NOTE! The naming convention for the series in this dataset is the following:\n")
        message(query.req,"\n")
        message("For example, to search for all matching series in the dataset one can type the following query:\n")
        message(sprintf("get_matching_series(datasetId = '%s',pattern = '%s')",
                        datasetId,
                        query.all),
                "\n")
        message('To restrict search on particular dimensions, simply add desired names in that dimension, like so (the following assumes one restricts the first dimension to "x"):\n')
        message(sprintf("get_matching_series(datasetId = '%s',pattern = '%s')",
                        datasetId,
                        paste0('x',query.all)),
                "\n")        
        message('To see all available codes for a particular dimension, examine the result of the following call:\n')
        message(sprintf("get_datastructure(dataset = '%s')",
                        datasetId))


        get_multiple_series(
            dataset = flowRef,
            series_ids = pattern
        ) ->
            data


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




