##' Download an ECB dataset
##'
##' This function downloads an ECB dataset, specified by the user. The available
##' datasets can be viewed by using the `get_datasets` function.
##' 
##' @param dataset Name of the dataset to download. 
##' @return A data.table containing the requested data.
##' @author Janko Cizel
##' @export
get_series <- function(
  dataset = 'AME',
  series_id = "......ZUTN"
){
    url = sprintf(## "https://sdw-ecb-wsrest.ecb.de/service/data/%s/%s",
                  "https://sdw-wsrest.ecb.europa.eu/service/data/%s/%s",
                dataset,
                series_id)
  
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


get_series_ameco <- function(concept_id = "ZUTN"){
  get_series(
    dataset = 'AME',
    series_id = sprintf("......%s",concept_id)
  )
}


# get_series_ameco()
