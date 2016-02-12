##' View all available datasets from a specified data source
##'
##' @param source Name of the source. The default is ECB. 
##' @return A data.table with information about the available datasets.
##' @author Janko Cizel
##' @export
get_datasets <- function(
    source = 'ECB'
){
    sprintf('https://sdw-wsrest.ecb.europa.eu/service/datastructure/%s/all/latest',
            source) ->
                url
    
    doc = read_xml(url)
    ns = doc %>>% xml_ns

    doc %>>%
      xml_find_all('.//str:DataStructures/str:DataStructure', ns = ns) %>>%
      list.map({
        . %>>% xml_attrs %>>%
          as.list %>>% as.data.table ->
          part1
        
        . %>>%
          xml_find_all('.//com:Name', ns = ns) %>>%
          xml_text ->
          part2
        
        cbind(part1, name = part2)
    }) %>>% rbindlist(fill = TRUE) %>>%
    select(
        id, agencyID, name
    ) ->
        datasets

    return(datasets)
}

## Tests
## ecb_datasets <- get_datasets(source = 'ECB')
## imf_datasets <- get_datasets(source = 'IMF')
