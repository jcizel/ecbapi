library(shinyAce)
library(pipeR)
library(rlist)
library(htmltools)
library(data.table)
library(xts)
library(dygraphs)
library(dplyr)
library(ggvis)
library(ggplot2)
library(ggthemes)
library(stringr)
library(ecbapi)

PATH = '/Users/jankocizel/Data/ECB Data'

source('./util.R')

## datasets <- ecbapi::get_datasets()
## save(datasets,file = sprintf('%s/datasets.RData',PATH))
load(file = sprintf('%s/datasets.RData',PATH))


PATH %>>% list.files %>>%
gsub(
    pattern = '(.+)\\.RData',
    replacement = '\\1'
) %>>%
list.map({
    datasets[grepl(
        pattern = .,
        x = id,
        ignore.case = TRUE
    ), file := .]
}) %>>% rbindlist(fill = TRUE) %>>%
subset(
    !is.na(file)
) %>>%
setkey(file) %>>% unique ->
    datasets_avail



## load(file = sprintf('%s/all_data.RData',PATH))
## load(file = sprintf('%s/rir.RData',PATH))

## list.files(PATH)[1:5] %>>%
## setdiff(c('all_data.RData','ameco.RData')) %>>%
## list.map({
##     file = sprintf('%s/%s',PATH,.)
##     message(sprintf('Loading: %s',file))
    
##     load(file = file,
##          envir = .GlobalEnv)
## })


## list.files(PATH) %>>%
## gsub(
##     pattern = '(.+)\\.RData',
##     replacement = '\\1'
## ) ->
##     datasets_names


## save(list = c(
##          sprintf('%s_static', datasets_names),
##          sprintf('%s_data', datasets_names)
## ), file = sprintf('%s/all_data.RData', PATH))


## datasets <- get_datasets()
## datasets[, id2 := {
##     id %>>%
##     gsub(
##         pattern = '(ECB_)(.+)([0-9]{1})',
##         replacement = '\\2'
##     ) %>>% tolower
## }]

dataset_choices <- local({
    x <- datasets_avail$file
    names(x) <- sprintf('%s [%s]',
                        datasets_avail$name,
                        datasets_avail$id)
    x
})


ui <- shinyUI(fluidPage(fluidRow(
    column(
        width = 4,
        tags$br(),
        h2('Dataset'),
        selectizeInput(
            'dataset',
            'Select dataset:',
            choices = dataset_choices
        ),
        hr(),
        h2('Dimensions:'),
        uiOutput('ui-params')        
    ),
    column(
        width = 8,
        dataTableOutput('data'),
        hr(),
        h2('Reshape dataset:'),
        uiOutput('ui_reshape'),
        hr(),
        dataTableOutput('data_reshaped')        
    ),
    tags$br(),
    hr()   
)))


server <- function(input, output, session){
    dataset <- reactive({
        load(
            file = sprintf('%s/%s.RData',
                PATH,
                input[['dataset']])
        )

        data = input[['dataset']] %>>% sprintf(fmt = '%s_data') %>>% get
        static = input[['dataset']] %>>% sprintf(fmt = '%s_static') %>>% get

        names(static) <- static %>>% names %>>%
        (? . -> static_names_old) %>>%
        gsub(pattern = ".+\\[(CL_)(.+)\\]", replacement = '\\2')
        
        list(
            data = data,
            static = static,
            static_names_old = static_names_old
        ) ->
            out

        out %>>% str
        return(out)
    })


    data <- reactive({
        dataset()$static_names_old %>>% dput
        
        dataset()$data %>>% names %>>%
        grep(
            pattern = 'TITLE',
            value = TRUE
        ) ->
            var_title        

        dataset()$data %>>%
        names %>>%
        setdiff(
            c(var_title, 'date', 'value')
        ) ->
            vars

        sprintf(
            "((%s %%in%% input[['ATTR_%s']])|is.na(%s))",
            vars,
            vars,
            vars
        ) %>>%
        paste(
            collapse = " & "
        ) ->
            COND

        message(COND)
        
        dataset()$data[eval(parse(text = COND))] %>>%
        select(
            -one_of(var_title)
        ) %>>%
        mutate(
            value = (value %>>% as.numeric) * (10**(UNIT_MULT %>>% as.numeric))
        )
    })               
    
    output[['ui-params']] <- renderUI({
        dataset()$data %>>% names %>>%
        grep(
            pattern = 'TITLE',
            value = TRUE
        ) ->
            var_title
        
        dataset()$data %>>%
        names %>>%
        setdiff(
            c(var_title, 'date', 'value')
        ) %>>%
        list.map({
            code = .
            message(code)
            
            summarize_attribute(
                data = dataset()$data,
                var= .,
                static = dataset()$static
            ) ->
                static_temp

            static_temp %>>% str(1)
            
            choices = static_temp$id
            names(choices) = sprintf(
                     '%s [%s], N=%s',
                     static_temp$name,
                     static_temp$id,
                     static_temp$N
            )

            selectizeInput(
                inputId = sprintf('ATTR_%s',code),
                label = sprintf(
                    '%s, CODE: %s',
                    grep(
                        pattern = code,
                        x = dataset()$static_names_old,
                        value = TRUE
                    ) %>>% (.[1L]),
                    code
                ),
                choices = choices,
                selected = choices,
                multiple = TRUE
            )            
        }) ->
            out               

        names(out) <- NULL

        out
    })

    output[['ui_reshape']] <- renderUI({
        list(
            selectizeInput(
                'reshape_idvars',
                'Select ID variables',
                choices = data() %>>% names,
                selected = c('REF_AREA','date'),
                multiple = TRUE
            ),
            selectizeInput(
                'reshape_colvars',
                'Select column variables',
                choices = data() %>>% names,
                selected = NULL,
                multiple = TRUE
            ),
            selectizeInput(
                'reshape_valuevar',
                'Select value variable',
                choices = data() %>>% names,
                selected = 'value',
                multiple = FALSE
            )
        )
    })
    
    output[['data']] <- renderDataTable({
        data()
    })

    output[['data_reshaped']] <- renderDataTable({
        sprintf(
            "%s ~ %s",
            input[['reshape_idvars']] %>>% paste(collapse = ' + '),
            input[['reshape_colvars']] %>>% paste(collapse = ' + ')            
        ) %>>%
        as.formula ->
            f
        
        data() %>>%
        dcast.data.table(
            formula = f,
            value.var = input[['reshape_valuevar']]
        )
    })
}


shinyApp(ui = ui, server = server)
