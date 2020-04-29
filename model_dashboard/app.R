# Consumer complaints plotting shiny app 
# Date: April 9, 2020

library(shiny)
library(ggplot2)
library(dplyr)
library(reticulate)
use_condaenv("r-reticulate")

# USER INTERFACE -----------------------------------------------------

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  # App title ----
  titlePanel("Company Response Predictor"),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      radioButtons(inputId = 'product_choice', 
                   label = 'Product',
                   choices = c('Mortgage', 'Credit reporting, credit repair services, or other personal consumer reports'), 
                   selected = c('Mortgage')),
      
      # Textinput for inputting narrative
      textInput(
        inputId = 'narrative_input',
        label = 'Narrative',
        value = 'Enter narrative'
      ),
  
      # Make an 'action button' that does something when clicked
      actionButton(inputId = "clicks", "Click Me")
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      
      # To make panel with tabs
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput(outputId = "my_plot")),
                  tabPanel("Model", textOutput(outputId = "my_model")),
                  tabPanel("Info", h6('Here is some text')),
                  tabPanel("Links", a("Iris Dataset", href="https://gist.github.com/curran/a08a1080b88344b0c8a7"))
                  
      )
    )
  )
)


# SERVER FUNCTION ---------------------------------------------------------

server_function <- function(input, output) {
  
  output$my_plot <- renderPlot({
    df = read.csv("data/narratives_mortgage.csv", stringsAsFactors = FALSE)
    # Filter the data according to the input -- the user is choosing which product to display
    ## df = dplyr::filter(df, Product %in% input$product_choice)
    
    # Set the histogram bins based on user input for number of bins
    #hist_bins <- seq(min(df$Sepal.Length), max(df$Sepal.Length), length.out = input$bins + 1)
    
    # create the plot
    product_plot = ggplot(df, aes(as.factor(Company.response.to.consumer))) +
      #geom_histogram(breaks = hist_bins, fill = 'blue', alpha = .7) +
      geom_histogram(fill = 'blue', alpha = .7, stat = "count") +
      theme_bw() +
      labs(x = "Company response", 
           y = 'Count',
           title = 'Histogram of Company responses to complaints') +
      theme(text = element_text(face = 'bold'))
    
    # Display the plot (whether it has facets or not)
    product_plot
  })
  
  output$my_model <- observeEvent(input$clicks, {
    # print(as.numeric(input$clicks))
    source_python('predict_narrative.py')
    predicted_value <- predict_narrative(input$narrative_input)
    predicted_value
  })
  
  output$my_model <- renderText({

    source_python('predict_narrative.py')
    predicted_value <- predict_narrative(input$narrative_input)

    # Display the text
    predicted_value
    })

}


# SHINY APP CALL --------------------------------------------------------------

shinyApp(ui = ui, server = server_function)
