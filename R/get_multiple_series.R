get_multiple_series <- function(dataset,series_ids){
  
  series_ids %>>%
    list.map({
      id = .
      message(id)
      
      try(get_series(dataset = dataset,
                     series_id = id)) ->
        o
      
      if (inherits(x = o,"try-error")){
        if ((o %>>% attr("condition") %>>% as.character) %like% "handshake fail"){
          FAIL = TRUE
          while (FAIL == TRUE){
            try(get_series(dataset = "FM",
                           series_id = id)) ->
              o
            if (inherits(x = o,"try-error")){
              FAIL = (o %>>% attr("condition") %>>% as.character) %like% "handshake fail"
            } else {
              FAIL = FALSE
            }
          }     
          if (inherits(x = o,"try-error")){
            o <- NULL
          }
        } else {
          o <- NULL
        }
      }
      o
    }) %>>%
    Filter(f = function(o) !is.null(o)) %>>%
    rbindlist(fill = TRUE) ->
    out
  
  return(out)
}