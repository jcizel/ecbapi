options(width = 80)

PATH = '/Users/jankocizel/Documents/Dropbox/Data/ECB Data'
load(file = sprintf('%s/bsi.RData',PATH))


data <- ivf_data %>>% copy
static <- ivf_static %>>% copy

static_names_old <- static %>>% names

names(static) <- static %>>% names %>>%
gsub(pattern = ".+\\[(CL_)(.+)\\]", replacement = '\\2')



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



PATH = '/Users/jankocizel/cizel/Data/ECB Data'
load(file = sprintf('%s/all_data.RData',PATH))


data <- bsi_data %>>% copy
static <- bsi_static %>>% copy

names(static) <- static %>>% names %>>%
gsub(pattern = ".+\\[(CL_)(.+)\\]", replacement = '\\2')

data %>>% names %>>%
grep(
    pattern = 'TITLE',
    value = TRUE
) ->
    var_title

data %>>%
names %>>%
setdiff(
    c(var_title, 'date', 'value')
) %>>%
list.map({
    message(.)
    summarize_attribute(data = data, var=., static = static)
})
