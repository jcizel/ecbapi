options(width = 80)

PATH = '/Users/jankocizel/cizel/Data/ECB Data'
load(file = sprintf('%s/all_data.RData',PATH))


data <- ivf_data %>>% copy
static <- ivf_static %>>% copy

static_names_old <- static %>>% names

names(static) <- static %>>% names %>>%
gsub(pattern = ".+\\[(CL_)(.+)\\]", replacement = '\\2')



data %>>% names %>>% dput
static %>>% names

c("UNIT_MULT", "DECIMALS", "UNIT", "COLLECTION", 
  "FREQ", "REF_AREA", "ADJUSTMENT", "IVF_REP_SECTOR", "IVF_ITEM", 
  "MATURITY_ORIG", "DATA_TYPE", "COUNT_AREA", "BS_COUNT_SECTOR", 
  "CURRENCY_TRANS", "BS_SUFFIX", "date") %>>%
list.map({
    message(.)
    data[[.]] %>>% table
})


data %>>% names

data %>>% (UNIT_MULT) %>>% table
data %>>% (DECIMALS) %>>% table
data %>>% (UNIT) %>>% table
data %>>% (COLLECTION) %>>% table

## Choice
data %>>% (FREQ) %>>% table
data %>>% (REF_AREA) %>>% table         #!!!!
data %>>% (ADJUSTMENT) %>>% table

## Variables
data %>>% (IVF_REP_SECTOR) %>>% table   #!!!!
data %>>% (IVF_REP_SECTOR) %>>% (static[['IVF_REP_SECTOR']][.]) %>>% unique

data %>>% (IVF_ITEM) %>>% table
data %>>% (IVF_ITEM) %>>% (static[['IVF_ITEM']][.]) %>>% unique

data %>>% (MATURITY_ORIG) %>>% table
data %>>% (MATURITY_ORIG) %>>% (static[['MATURITY_ORIG']][.]) %>>% unique

data %>>% (DATA_TYPE) %>>% table
data %>>% (DATA_TYPE) %>>% (static[['DATA_TYPE']][.]) %>>% unique

data %>>% (COUNT_AREA) %>>% table
data %>>% (COUNT_AREA) %>>% (static[['AREA_EE']][.]) %>>% unique

data %>>% (BS_COUNT_SECTOR) %>>% table
data %>>% (BS_COUNT_SECTOR) %>>% (static[['BS_COUNT_SECTOR']][.]) %>>% unique

data %>>% (BS_SUFFIX) %>>% table
data %>>% (BS_SUFFIX) %>>% (static[['BS_SUFFIX']][.]) %>>% unique

data %>>% (CURRENCY_TRANS) %>>% table %>>% as.data.table %>>%
setnames(old = '.', new = 'id') %>>%
setkey(id) %>>%
(static[['CURRENCY']][.]) %>>%
arrange(-N)

data %>>% (CURRENCY_TRANS) %>>% (static[['CURRENCY']][.]) %>>% unique


data = data
var = 'CURRENCY_TRANS'
static = static

summarize_attribute <- function(
    data = NULL,
    var = NULL,
    static = NULL
){
    static %>>% names -> n

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
    summarize_attribute(data = data, var=., static = static)
})

data %>>% summarize_attribute(var = 'IVF_REP_SECTOR', static = static)
data %>>% summarize_attribute(var = 'IVF_ITEM', static = static)
data %>>% summarize_attribute(var = 'MATURITY_ORIG', static = static)
data %>>% summarize_attribute(var = 'DATA_TYPE', static = static)
data %>>% summarize_attribute(var = 'REF_AREA', static = static)
data %>>% summarize_attribute(var = 'UNIT_MULT', static = static)
data %>>% summarize_attribute(var = 'UNIT', static = static)

data %>>% (COUNT_AREA) %>>% table
data %>>% (COUNT_AREA) %>>% (static[['AREA_EE']][.]) %>>% unique

data %>>% (BS_COUNT_SECTOR) %>>% table
data %>>% (BS_COUNT_SECTOR) %>>% (static[['BS_COUNT_SECTOR']][.]) %>>% unique

data %>>% (BS_SUFFIX) %>>% table
data %>>% (BS_SUFFIX) %>>% (static[['BS_SUFFIX']][.]) %>>% unique



                                     
vars_measure <- c("IVF_REP_SECTOR", "IVF_ITEM","MATURITY_ORIG", "DATA_TYPE")
vars_id <- c("UNIT", 
             "FREQ",
             "REF_AREA",
             "COUNT_AREA",              #Counterparty area
             "BS_COUNT_SECTOR",         #Counterparty sector
             "CURRENCY_TRANS",
             "BS_SUFFIX",
             "date")

data %>>%
subset(
    (UNIT == 'EUR') &
        (FREQ == 'Q') &
            (IVF_ITEM == 'T00') &
                (MATURITY_ORIG == 'A') &
                    (DATA_TYPE == '1') &
                        (BS_COUNT_SECTOR == '0000')
) %>>%
select(
    REF_AREA, date, IVF_REP_SECTOR, value, UNIT_MULT
) %>>%
mutate(
    value = (value %>>% as.numeric) * (10**(UNIT_MULT %>>% as.numeric))
) %>>% 
dcast.data.table(
    formula = 'REF_AREA + date ~ IVF_REP_SECTOR',
    value.var = 'value'
) ->
    out






static %>>%
list.map({
    . %>>% setkey(id)
})

CJ(
    static[["Investment funds reporting sector code list [CL_IVF_REP_SECTOR]"]]$id,
    static[["Investment funds item code list [CL_IVF_ITEM]"]]$id
) %>>%
setnames(
    old = c('V1','V2'),
    new = c('IVF_REP_SECTOR','IVF_ITEM')
) %>>%
setkeyv('IVF_REP_SECTOR') %>>%
(static[["Investment funds reporting sector code list [CL_IVF_REP_SECTOR]"]][.]) %>>%
setkeyv('IVF_ITEM') %>>%
(static[["Investment funds item code list [CL_IVF_ITEM]"]][.]) %>>%
mutate(
    code = sprintf('%s_%s',i.id,id),
    label = sprintf('%s: %s',i.name,name)
) %>>%
select(
    code,label
) %>>%
(.[code %in% (names(dataset))]) %>>%
(label) %>>%
data.frame
