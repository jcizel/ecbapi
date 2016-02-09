summarize_attribute <- function(
    data = NULL,
    var = NULL,
    static = NULL
){
    static %>>% names -> n

    static %>>%
    list.map({
        . %>>% setkey(id)
    })

    ## Find the lookup table with matching information
    n %>>%
    list.map({
        grepl(
            pattern = .,
            x = var
        ) ->
            o
        list(condition = o)
    }) %>>%
    list.filter(condition == TRUE) %>>%
    names ->
        lookup_table_name

    ## If the lookup table not found, join all lookup info together, and use
    ## this as the lookup
    if (length(lookup_table_name) == 0){
        message('Matching lookup table not found. Looking up information in all static tables...')
        static %>>%
        rbindlist %>>%
        setkey(id) %>>%
        unique ->
            lookup_table_new

        data %>>% (.[[var]]) %>>% table %>>% as.data.table %>>%
        setnames(old = '.', new = 'id') %>>%
        setkey(id) %>>%
        (lookup_table_new[.]) %>>%
        arrange(-N) ->
            out        
    } else if (length(lookup_table_name) > 1 ){
        lookup_table_name %>>%
        sprintf(fmt = "^%s$") %>>%
        list.map({
            grepl(
                pattern = .,
                x = var
            ) ->
                o
            list(condition = o)
        }) %>>%
        list.filter(condition == TRUE) %>>%
        names %>>%
        gsub(pattern = '(\\^)(.+)\\$', replacement = '\\2')->
            lookup_table_name_2

        data %>>% (.[[var]]) %>>% table %>>% as.data.table %>>%
        setnames(old = '.', new = 'id') %>>%
        setkey(id) %>>%
        (static[[lookup_table_name_2]][.]) %>>%
        arrange(-N) ->
            out                
    }
    else if (length(lookup_table_name) == 1) {
        data %>>% (.[[var]]) %>>% table %>>% as.data.table %>>%
        setnames(old = '.', new = 'id') %>>%
        setkey(id) %>>%
        (static[[lookup_table_name]][.]) %>>%
        arrange(-N) ->
            out        
    }   

    return(out)
}
