
library(shiny)
library(dplyr)
library(tidyr)

source("./R/get_hierarchy.R")

ui <- fluidPage(

  titlePanel("Reporting Structure Conversion"),

  sidebarLayout(

    sidebarPanel(

      fileInput("file", "Upload CSV File",
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),

      downloadButton("downloadData", "Download CSV")

    ), # sidebarPanel

    mainPanel(

      tableOutput("org_table")

    ) # mainPanel

  ) # sidebarLayout

) # fluidPage

server <- function(input, output) {

  data <- reactive({

    req(input$file)

    read.csv(input$file$datapath)

  })

  df_wide <- reactive({

    df <- data()

    hierarchy_data <- sample %>%
      rowwise() %>%
      mutate(hierarchy = list(get_hierarchy(sample, associate))) %>%
      unnest(hierarchy, names_sep = "_")

    hierarchy_data <- hierarchy_data %>%
      group_by(associate) %>%
      mutate(max_layer = max(hierarchy_layer)) %>%
      ungroup() %>%
      mutate(hierarchy_layer = max_layer - hierarchy_layer + 1) %>%
      select(-max_layer)

    max_layer <- max(hierarchy_data$hierarchy_layer)

    hierarchy_data <- hierarchy_data %>%
      pivot_wider(names_from = hierarchy_layer, values_from = hierarchy_manager, names_prefix = "mgr_level_") %>%
      select(associate, title, center, starts_with("mgr_level_")) %>%
      arrange(associate)

  })

  output$org_table <- renderTable({

    df_wide()

  })

  output$downloadData <- downloadHandler(

    filename = function() {

      paste("org-structure-", Sys.Date(), ".csv", sep = "")

    }, # filename

    content = function(file) {

      write.csv(df_wide(), file, row.names = FALSE)

    } # content

  ) # downloadHandler

} # server

shinyApp(ui = ui, server = server)
