# library(renv)
library(shiny)
library(bslib)
library(ranger)
library(kmer)
library(ape)
library(DT)
library(seqinr)

options(shiny.maxRequestSize = 2000*1024^2)
library(rintrojs)
library(magrittr)
library(dplyr)
library(shinyjs)
#for mac, without this Rstudio crashes
Sys.setenv(LIBGL_ALWAYS_SOFTWARE=1)
library(tibble)
# library(RColorBrewer)
library(parallel)
library(shinylogs)
library(shinyWidgets)
library(RColorBrewer)


theme_INFINITy <- bs_theme(bg = "#FFFFFF",
                       fg = "#4e79cb",
                       primary = "#ffc72c",
                       secondary= "#ee65cd",
                       font_scale = 0.8,
                       base_font = font_google("Prompt"))

ui<-shinyUI(


  navbarPage(title = span(img(src="logo_a.png", style="margin-top: -5px;", height = 50),
                          "INFINITy"),
             # add div("Enabled by data from",tags$a(img(style="width: 50px", src = "GISAID.png"),href="https://www.gisaid.org/"))
             theme= theme_INFINITy,
             tags$head(
               tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_a.png")),
             windowTitle ="INFINITy",
             selected = "Home",
             footer = list(column(12, align="center",
                                  HTML("<br></br>"),
                             strong("GISAID data provided on this website are subject to GISAID's"),
                             tags$a(href="https://www.gisaid.org/DAA/",strong("Terms and Conditions"))),
                           column(12, align="center", class = "footer",
                               includeHTML("www/footer_infinity.html"))),
    tabPanel("Home",
      fluidPage(align="center",
        includeHTML("www/title.html"),
        div("Enabled by data from",tags$a(img(style="width: 50px", src = "GISAID.png"),href="https://www.gisaid.org/")),
        br(),
        textAreaInput('SequenceData', 'Paste your sequences in FASTA format into the field below', value = "", placeholder = "", width = "70%", height="100px"),
        fileInput("file", "Submit a file with your sequences in FASTA format",
                  accept = c(".text",".fasta",".fas",".fasta")),
        radioGroupButtons(
          inputId = "select",
          label = "Choose the model according your SequenceData length sequences",
          choices = c("FULL_HA", "HA1"),
          status = "primary"),
        sliderInput("QC", "Probability threshold (default 0.6):",
                    min = 0.2, max = 1,
                    value = 0.6, step = 0.05),
        checkboxInput("qualityfilter", "Classify even if quality of sequence is low?", FALSE),
        actionButton("go", "RUN"),
        HTML("<br><br><br>"),
        br(),
        conditionalPanel(
          condition='output.table!=null && output.table!="A"',
          div(strong("The following sequences have passed the quality test"))),
        br(),
        DT::dataTableOutput("table"),
        br(),
        conditionalPanel(
          condition='output.table_reject!=null && output.table_reject!=""',
          div(strong("The following sequences have"),strong("NOT passed",style="color:red"),strong(" the quality test"))),
        br(),
        DT::dataTableOutput("table_reject"),
        conditionalPanel(
          condition='output.table!=null && output.table!=""',
          downloadButton('report',"Generate report (ENG)")))),
    tabPanel("Instructions",
             align="center",
             includeHTML("www/title.html"),
             div("Enabled by data from",tags$a(img(style="width: 50px", src = "GISAID.png"),href="https://www.gisaid.org/")),
             includeHTML("www/instructions.html")),
    tabPanel("Classification model information",DT::dataTableOutput("table2"))
  ))

server <- function(input, output, session) {
  values <- reactiveValues(SequenceData_FILE = NULL)
  observeEvent(input$go, {
    if(length(input$file)==0&(input$SequenceData=="")){
      showModal(modalDialog(
        title = "Important message", easyClose = TRUE,
        "Please load the fasta file (or the sequence) first and then press RUN.
Also, remember that the file must NOT exceed 2 MB in size.
"
      ))}})
  # model_reactive <- eventReactive(input$select,{
  #
  #   model <- readRDS(paste("models/",sep="",input$select,".rds"))
  #   list(model=model)
  # })
  model_reactive <- eventReactive(input$select,{
  if (input$select=="FULL_HA"){
    model <- infinity::FULL_HA}else{
    model <- infinity::HA1
    }
    list(model=model)
  })
  SequenceData_data<- observeEvent(input$SequenceData,{
    req(input$SequenceData)
    #gather input and set up temp file
    SequenceData_tmp <- input$SequenceData
    tmp <- tempfile(fileext = ".fa")


    #this makes sure the fasta is formatted properly
    if (startsWith(SequenceData_tmp, ">")){
      writeLines(SequenceData_tmp, tmp)
    } else {
      writeLines(paste0(">SequenceData\n",SequenceData_tmp), tmp)
    }
    values$SequenceData_FILE<-tmp
  })


  SequenceData_data<- observeEvent(input$file,{
    req(input$file)

    values$SequenceData_FILE<-input$file[1,4]

  })



  data_reactive<- eventReactive(input$go,{
    req(values$SequenceData_FILE)
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "processing data", value = 0)
    progress$inc(0.2, detail = paste("Reading fasta"))



    tmp<-values$SequenceData_FILE
    SequenceData<-ape::read.FASTA(tmp,type = "DNA")

    model <- model_reactive()$model


    #Calculate k-mer counts from SequenceData sequences
    progress$inc(0.4, detail = paste("Counting kmers"))

    NormalizeData<-infinity::Kcounter(SequenceData,
               model)


    data_out <-  infinity::PredictionCaller(NormalizeData,
                                  model=model)
    # data_out<-infinity::QualityControl(model=model,
    #                                    data=data_out)
    list(message="Done!",data_out=data_out)
  })

  data_predicted<-reactive({
    req(values$SequenceData_FILE)
    model <- model_reactive()$model
    data_out<-data_reactive()$data_out

    data_out<-infinity::QualityControl(model=model,
                                       data=data_out,
                                       QC_value=input$QC)
    data_out<-infinity::Stringent_filter(data=data_out)
    if(input$qualityfilter==FALSE){
    data_out<-infinity::Quality_filter(data=data_out)
    }
    data_out
  })

  output$text <- renderText({
    data_reactive()$message
  })

  table<-reactive({

    data_out<-data_predicted()

    data_out

  })

  table_pass<-reactive({

    table<-table()
    # table<-table %>% filter(Probability_QC == 1 & N_QC == 1 & Length_QC == 1)

    table<-table %>% filter(Probability_QC == 1)
  })


  table_reject<-reactive({

    table<-table()
    # table<-table %>% filter(Probability_QC == 0 | N_QC == 0 | Length_QC == 0)

    table<-table %>% filter(Probability_QC == 0)
  })

  output$table <- DT::renderDataTable({

    col2<-"#ee65cd"
    col<-"#ffc72c"

    table<-table_pass()


    datatable(table,selection = 'single',
              style = 'bootstrap',
              extensions = 'Buttons',
              options = list(
                columnDefs = list(list(targets = c(5,7,8), visible = FALSE)),
                dom = 'Bfrtip',
                lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                pageLength = 15,
                buttons =
                  list('copy', 'print', list(
                    extend = 'collection',
                    buttons = list(
                      list(extend = 'csv', filename = paste(input$file[1,1],"INFINITy_results"),sep=""),
                      list(extend = 'excel', filename = paste(input$file[1,1],"INFINITy_results"),sep=""),
                      list(extend = 'pdf', filename = paste(input$file[1,1],"INFINITy_results"),sep="")),
                    text = 'Download'
                  ),
                list(
                  extend = "collection",
                  text = 'Show All',
                  action = DT::JS("function ( e, dt, node, config ) {
                                    dt.page.len(-1);
                                    dt.ajax.reload();
                                }")
                ))
              ))%>%formatStyle("Length","Length_QC",backgroundColor = styleEqual(c(0, 1), c(col2, col)))%>%
                   formatStyle("N","N_QC",backgroundColor = styleEqual(c(0, 1), c(col2, col)))%>%
                   formatStyle("Probability","Probability_QC",backgroundColor = styleEqual(c(0, 1), c(col2, col)))


    })


  output$table_reject <- DT::renderDataTable({

    col2<-"#ee65cd"
    col<-"#ffc72c"

    table<-table_reject()


    datatable(table,selection = 'single',
              style = 'bootstrap',
              extensions = 'Buttons',
              options = list(
                columnDefs = list(list(targets = c(5,7,8), visible = FALSE)),
                dom = 'Bfrtip',
                lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                pageLength = 15,
                buttons =
                  list('copy', 'print', list(
                    extend = 'collection',
                    buttons = list(
                      list(extend = 'csv', filename = paste(input$file[1,1],"INFINITy_results"),sep=""),
                      list(extend = 'excel', filename = paste(input$file[1,1],"INFINITy_results"),sep=""),
                      list(extend = 'pdf', filename = paste(input$file[1,1],"INFINITy_results"),sep="")),
                    text = 'Download'
                  ),
                  list(
                    extend = "collection",
                    text = 'Show All',
                    action = DT::JS("function ( e, dt, node, config ) {
                                    dt.page.len(-1);
                                    dt.ajax.reload();
                                }")
                  ))
              ))%>%formatStyle("Length","Length_QC",backgroundColor = styleEqual(c(0, 1), c(col2, col)))%>%
      formatStyle("N","N_QC",backgroundColor = styleEqual(c(0, 1), c(col2, col)))%>%
      formatStyle("Probability","Probability_QC",backgroundColor = styleEqual(c(0, 1), c(col2, col)))
        })

  model_table<-reactive({
    model1<-model_reactive()$model
    model1_data<-data.frame(Model=model1$info,date=model1$date,trees=model1$num.trees,Oob= round(model1$prediction.error,4))

    model1_data
  })

  output$table2 <- DT::renderDataTable({
    datatable(model_table())


  })
  version<-reactive({
    version<-0.1
    return(version)})

  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.html",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.rmd")
      file.copy("report.rmd", tempReport, overwrite = TRUE)

      # Set up parameters to pass to Rmd document

      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file)

    }
  )

}

shinyApp(ui = ui, server = server)
