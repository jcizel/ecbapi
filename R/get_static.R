##' Get static information for the specified dataset.
##'
##' @param source Name of the data source. Defautl is the ECB. 
##' @param dataset Name of the dataset.
##' @return A data.table with static information.
##' @author Janko Cizel
##' @export
get_static <- function(
    source = 'ECB',
    dataset = 'ECB_IVF1'
){

    sdw.root <- getOption('sdw.roots')[[getOption('sdw.loc')]]
    message(sprintf("Note: The current setting is to access the '%s' version of the SDW. If you wish to switch the version (the two possiblities are 'internal' and 'external'), please specify the desired option via:\n\noptions(sdw.loc = 'internal/external')\n\nThe internal option gives access to a broader set of datasets but is available only from within the ECB network.",
                    getOption('sdw.loc')))    

    sprintf('%s/service/datastructure/%s/%s/latest?references=children',
            sdw.root,
            source,
            dataset) ->
        url
    
    doc <- xml2::read_xml(url)
    ns <- xml_ns(doc)

    doc %>>%
    xml_find_all('.//str:Codelists/str:Codelist', ns = ns) %>>%
    list.map({
        . %>>% xml_attrs %>>%
        as.list %>>% as.data.table ->
            part1

        . %>>%
        xml_find_all('./com:Name', ns = ns) %>>%
        xml_text ->
            part2

        part2

        cbind(part1, name = part2)
    }) %>>%
    rbindlist(fill = TRUE) %>>%
    (sprintf(fmt = '%s [%s]',
             .$name,
             .$id)) ->
                 n

    doc %>>%
    xml_find_all('.//str:Codelists/str:Codelist', ns = ns) %>>% 
    list.map({
        . %>>%
        xml_find_all('.//str:Code', ns = ns) %>>%
        xml_attrs %>>%
        list.map({
            . %>>% as.list %>>%
            as.data.table
        }) %>>%
        rbindlist(fill = TRUE) ->
            part1

        . %>>%
        xml_find_all('.//str:Code/com:Name', ns = ns) %>>%
        xml_text ->
            part2

        cbind(part1, name = part2) %>>%
        select(
            id, name
        )
    }) ->
        static

    names(static) <-n

    return(static)
}


## Test
## get_static(source = 'ECB', dataset = 'ECB_IVF1') ->
##     static

## get_static(source = 'ECB', dataset = 'ECB_EXR1')
## get_static(source = 'ECB', dataset = 'ECB_RIR2')
## get_static(source = 'ECB', dataset = 'ECB_MFI1')
## get_static(source = 'ECB', dataset = 'ECB_DCM1')
## get_static(source = 'ECB', dataset = 'ECB_DD1')
