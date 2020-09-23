library(shiny)
# Define UI for miles per gallon app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("CAD Heart Disease Prediction"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for variable to plot against mpg ----
      selectInput("variable", "Variable:",
                  c("Age" = "age",
                    "Sex" = "sex",
                    "Blood Pressure" = "bloodpressure")),
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Formatted text for caption ----
      h3(textOutput("caption")),
      
      # Output: Plot of the requested variable against mpg ----
      plotOutput("mpgPlot")
      
    )
  )
)

server = shinyServer(function(input,output) {
  output$txtOutput = renderText({paste(input$txtInput)})
})



shinyApp(ui=ui, server=server)
