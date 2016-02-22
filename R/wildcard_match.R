##' @title Wildcard match of series 
##' @param pattern 
##' @param id 
##' @return 
##' @author Janko Cizel
##' @export
wildcard_match <-
    function(
             pattern = "*.USA.*",
             id
             ){

        glob2rx(
            pattern = pattern,
            trim.head = FALSE,
            trim.tail = FALSE
        ) ->
            REGEX
        
        id %>>%
            grep(
                pattern = REGEX,
                value = TRUE
            ) ->
            matched

        if (length(matched) == 0){
            warning('No matching series found.')
        }

        return(matched)
    }
