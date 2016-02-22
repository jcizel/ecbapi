##' View all available datasets from a specified data source
##'
##' @param source Name of the source. The default is ECB. 
##' @return A data.table with information about the available datasets.
##' @author Janko Cizel
##' @export
get_datasets <- function(
    source = 'ECB'
    ){
    sdw.root <- getOption('sdw.roots')[[getOption('sdw.loc')]]
    message(sprintf("Note: The current setting is to access the '%s' version of the SDW. If you wish to switch the version (the two possiblities are 'internal' and 'external'), please specify the desired option via:\n\noptions(sdw.loc = 'internal/external')\n\nThe internal option gives access to a broader set of datasets but is available only from within the ECB network.",
                    getOption('sdw.loc')))    

    sprintf('%s/service/datastructure/%s/all/latest',
            sdw.root,
            source) ->
        url

    ## test url: url = "https://sdw-wsrest.ecb.europa.eu/service/datastructure/ECB/all/latest"
    ## download_file <- getURL(url,ssl.verifypeer = FALSE)
    set_config(config(ssl_verifypeer = 0L))
    GET(url,accept_xml()) %>>%
        content(as = 'text',
                encoding = 'UTF-8') ->
        download_file
    
    doc = read_xml(download_file)
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
