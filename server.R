library(shiny)
library(tidyverse)
library(caret)
Sys.setlocale(locale = "US")
shinyServer(function(input, output) {
  
  output$logo <- renderImage({
    list(src="images/doge.png",
         contentType = "image/png",
         height = 150,
         width = 150)
  }, deleteFile = FALSE)
  
  model <- readRDS("data/model.bz2")
  
  m_df <- reactive({
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
  })
  
  pred1 <- reactive({predict(model, newdata = tibble("Sepal.Length" = input$seplen,
                                                     "Sepal.Width" = input$sepwid,
                                                     "Petal.Length" = input$petlen,
                                                     "Petal.Width" = input$petwid))})
  output$wow <- renderText({
    if (input$go == 0) "Doge wants you to press 'predict' button"
    else if (input$go == 1) paste0("Wow you pressed it! Your flower is ", pred1())
    else paste0("Wow much press! Your flower is ", pred1())
  })
  
  output$pic <- renderImage({
    if (input$draw == 0) list(src="images/blank.png",
                              contentType = "image/png",
                              height = 150,
                              width = 150)
    
    else if (pred1() == "versicolor") list(src="images/versicolor.png",
                                         contentType = "image/png",
                                         height = 150,
                                         width = 150)
  
    else if (pred1() == "setosa") list(src="images/setosa.png",
                                      contentType = "image/png",
                                      height = 150,
                                      width = 150)
    
    else list(src="images/virginica.png",
              contentType = "image/png",
              height = 150,
              width = 150)
  }, deleteFile = FALSE)

  output$predictions <- renderTable({
    
    modelpred <- reactive({predict(model, newdata = m_df())})
    num_row = nrow(m_df())
    if (num_row >= 10) {
      return(tibble(id = 1:10, prediction = head(modelpred(), 10)))
    } else{
      return(tibble(id = 1:num_row, prediction = head(modelpred(), num_row)))
    }
  })
  
  outfile <- reactive({
    
    return(tibble(id = 1:nrow(m_df()), prediction = predict(model, newdata = m_df())))
    
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0(input$inpFile, ".csv")
    },
    content = function(file) {
      write.csv(outfile(), file, row.names = FALSE)
    }
  )
  
})
