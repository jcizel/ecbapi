##' Download an ECB dataset
##'
##' This function downloads an ECB dataset, specified by the user. The available
##' datasets can be viewed by using the `get_datasets` function.
##' 
##' @param dataset Name of the dataset to download. 
##' @return A data.table containing the requested data.
##' @author Janko Cizel
get_data <- function(
    dataset = 'AME'
    ){
    sdw.root <- getOption('sdw.roots')[[getOption('sdw.loc')]]
    
    message(sprintf("Note: The current setting is to access the '%s' version of the SDW. If you wish to switch the version (the two possiblities are 'internal' and 'external'), please specify the desired option via:\n\noptions(sdw.loc = 'internal/external')\n\nThe internal option gives access to a broader set of datasets but is available only from within the ECB network.",
            getOption('sdw.loc')))
   
    url = sprintf("%s/service/data/%s",
                  sdw.root,
                  dataset)

    message(sprintf("Query:\n%s",url))
    download_file <- getURL(url,ssl.verifypeer = FALSE)
    doc <- xml2::read_xml(download_file)
    ns <- xml_ns(doc)

    doc %>>% xml_find_all('.//generic:Series',ns = ns) ->
        nodes

    nodes %>>% 
    list.map({
        message(sprintf('Processed node %s out of %s',.i, length(nodes)))

        . %>>%
        xml_find_all('./generic:Attributes/generic:Value',ns = ns) %>>%
        xml_attrs %>>% as.list %>>%
        list.map({
            l <- .
            o <- l[[2L]]
            names(o) <- l[[1L]]    
            o 
        }) %>>% do.call(what = 'c') %>>%
        as.list %>>% as.data.table ->
            part1

        . %>>%
        xml_find_all('./generic:SeriesKey/generic:Value',ns = ns) %>>%
        xml_attrs %>>% as.list %>>%
        list.map({
            l <- .
            o <- l[[2L]]
            names(o) <- l[[1L]]    
            o 
        }) %>>% do.call(what = 'c') %>>%
        as.list %>>% as.data.table ->
            part2

        . %>>%
        xml_find_all('./generic:Obs/generic:ObsDimension',ns = ns) %>>%
        xml_attrs %>>% as.list %>>%
        list.map(value) %>>%
        unlist ->
            part3

        . %>>%
        xml_find_all('./generic:Obs/generic:ObsValue',ns = ns) %>>%
        xml_attrs %>>% as.list %>>%
        list.map(value) %>>%
        unlist ->
            part4         

        cbind(part1, part2, date = part3, value = part4)
    }) %>>% rbindlist(fill = TRUE) ->
        result

    return(result)
}

## static <- get_static(source = 'ECB', dataset = 'ECB_MFI1')
## dt <- get_data('MFI')



## dt %>>%
## subset(
##     MFI_LIST == '100' &
##         DATA_TYPE == '4'
## ) %>>%
## (DATA_TYPE) %>>% table


## static <- get_static(source = 'ECB', dataset = 'ECB_RPP1')
## dt <- get_data('RPP')

## dt %>>%
## (REF_AREA) %>>% table

## dt[REF_AREA == 'SI']
