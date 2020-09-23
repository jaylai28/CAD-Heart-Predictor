library(shiny)

shinyUI(fluidPage(
  headerPanel(title = 'CAD Heart Disease Prediction'),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
  # Sidebar panel for inputs ----
  sidebarPanel(
    textInput("age", "Enter Your Age:"),
      # selectInput("age", "Select your Age", c("18-24", "25-34", "35-44", "45-54")),
    # sliderInput("age", "Enter your Age", 18,100,18),
      radioButtons("gender", "Gender:", choices = c("Male", "Female"), selected = "Male"),
      textInput("bp", "Enter Your Blood Pressure:")
  ),
      
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Formatted text for caption ----
      textOutput("age_output"),
      textOutput("gender_output"),
      textOutput("bp_output")
    )
  )
)
)

