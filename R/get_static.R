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
    sprintf(
        "https://sdw-ecb-wsrest.ecb.de/service/datastructure/%s/%s/latest?references=children",
        source,
        dataset
    ) ->
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
