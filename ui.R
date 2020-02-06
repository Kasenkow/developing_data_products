library(shiny)

# Define UI for data upload app ----
shinyUI(fluidPage(
  
  imageOutput("logo", height = 150, width = 150),
  
  # App title ----
  titlePanel("Doge predicts iris type"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      h4("You can select flower dimensions manually:"),
      
      numericInput("seplen", "Sepal Length", 5.8, min = 3.9, max = 8.5, step = 0.05),
      numericInput("sepwid", "Sepal Width", 3.0, min = 1.9, max = 4.8, step = 0.05),
      numericInput("petlen", "Petal Length", 3.7, min = 0.9, max = 7.5, step = 0.05),
      numericInput("petwid", "Petal Width", 1.2, min = 0.01, max = 2.7, step = 0.05),
      
      actionButton("go", "Doge, predict!"),
      
      actionButton("draw", "Doge, draw my flower!"),
      
      # Horizontal line ----
      tags$hr(),
      
      h4("Or you can input data in a csv-file"),
      h6("(please, specify input options)", align = "left"),
      h6("*and make sure that your CSV contains columns named 'Sepal.Length', 'Sepal.Width','Petal.Length' and 'Petal.Width'", align = "left"),
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),
      
      # Horizontal line ----
      tags$hr(),
      
      h4("Download predictions:"),
      
      h5("Enter file name"),
      
      textInput("inpFile", label = NULL, width = 400),
      
      # Button
      downloadButton("downloadData", "Download")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      h3("Doge's single prediction:"),
      p("(for manual input)"),
      textOutput("wow"),
      plotOutput("pic", height = 150, width = 150),
      
      # Output: Data file ----
      h3("Doge's multiple predictions"),
      p("(preview of CSV output)"),
      tableOutput("predictions")
      
    )
    
  )
))
