
##' @title Get all available AMECO series 
##' @param concept_id optionally, specify (part of) series code to look for
##' @return Returns a character vector of matching series.
##' @author Janko Cizel
get_series_ameco <- function(concept_id = "ZUTN"){
  get_series(
    dataset = 'AME',
    series_id = sprintf("......%s",concept_id)
  )
}


get_ameco <- function(concept_ids = c("ZUTN","AVGDGP")){
    concept_ids %>>%
      list.map({
        message(.)
        get_series_ameco(concept_id = .)
      }) %>>%
      rbindlist(fill = TRUE)
}

# get_series_ameco()
# get_ameco()

get_ameco_long <- function(concept_ids = c("ZUTN","AVGDGP")){
  ## Get static info
  get_static(
    source = 'ECB',
    dataset = 'ECB_AME1'
  ) ->
    ameco_static
  
  get_ameco(concept_ids = concept_ids) ->
    ameco
  
  
  ## Prepare long dataset
  ameco %>>% 
    select(
      iso3 = AME_REF_AREA,
      code = AME_ITEM,
      unit = AME_UNIT,
      ## aggregation = AME_AGG_METHOD,
      ## transformation = AME_TRANSFORMATION,
      date,
      value
    ) ->
    ameco_l
  
  ## (ameco_static[["Ameco aggregation method [CL_AME_AGG_METHOD]"]] %>>%
  ##  setkey(id))[ameco_l %>>%
  ##                  setkey(aggregation)] %>>%
  ##     select(-id) %>>%
  ##     rename(aggregation = name) ->
  ##     ameco_l
  
  
  (ameco_static[["Ameco reference area [CL_AME_AREA_EE]"]] %>>%
     setkey(id))[ameco_l %>>%
                   setkey(iso3)] %>>%
    ## select(-id) %>>%
    rename(iso3 = id) %>>%
    rename(country = name) ->
    ameco_l
  
  
  (ameco_static[["Ameco item [CL_AME_ITEM]"]] %>>%
     setkey(id))[ameco_l %>>%
                   setkey(code)] %>>%
    ## select(-id) %>>%
    rename(code = id) %>>%
    rename(label = name) ->
    ameco_l
  
  
  (ameco_static[["Ameco unit [CL_AME_UNIT]"]] %>>%
     setkey(id))[ameco_l %>>%
                   setkey(unit)] %>>%
    ## select(-id) %>>%
    rename(unit = id) %>>%
    rename(unit_label = name) ->
    ameco_l
  
  ameco_l %>>%
    select(
      iso3,country,code,label,unit_label,date,value
    ) ->
    ameco_l_final
  
  return(ameco_l_final)
}


get_ameco_wide <- function(concept_ids = c("ZUTN","AVGDGP")){
  get_ameco_long(concept_ids = concept_ids) %>>%
    mutate(
      temp_code = sprintf('%s_%s',code,iso3)
    ) %>>%
    dcast.data.table(
      date ~ temp_code,
      value.var = 'value'
    ) ->
    ameco_w_final
  
  return(ameco_w_final)
}
