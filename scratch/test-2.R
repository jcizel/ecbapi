require(dplyr)

## -------------------------------------------------------------------------- ##
## All available datasets                                                     ##
## -------------------------------------------------------------------------- ##
url = 'https://sdw-wsrest.ecb.europa.eu/service/datastructure/ECB/all/latest'
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
    databases


## -------------------------------------------------------------------------- ##
## Static information                                                         ##
## -------------------------------------------------------------------------- ##
url = "https://sdw-wsrest.ecb.europa.eu/service/datastructure/ECB/ECB_IVF1/latest?references=children"

doc <- xml2::read_xml(url)
ns <- xml_ns(doc)

doc %>>% xml_structure
doc %>>% xml_children %>>% xml_children %>>% xml_children %>>% xml_structure

doc %>>%
xml_find_all('.//str:AgencyScheme/str:Agency', ns = ns) %>>%
(? . %>>% xml_attrs) %>>%
(? . %>>% xml_children %>>% xml_text)



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

static




## -------------------------------------------------------------------------- ##
## Process series                                                             ##
## -------------------------------------------------------------------------- ##
url = "https://sdw-wsrest.ecb.europa.eu/service/data/IVF"

doc <- xml2::read_xml(url)
ns <- xml_ns(doc)

doc %>>% xml_find_all('.//generic:Series',ns = ns) ->
    nodes

nodes %>>% 
list.map({
    cat(sprintf('Processed node %s out of %s\n',.i, length(nodes)))

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
    test

test %>>% (REF_AREA) %>>% table
