library(shiny)

shinyUI(fluidPage(
  headerPanel(title = 'CAD Heart Disease Prediction'),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

  # Sidebar panel for inputs ----
  sidebarPanel(
    numericInput("esr", "Enter Your Erythrocyte Sedimentation Rate (ESR): (1-90)"),
    numericInput("age", "Enter Your Age: (30-86)"),
    numericInput("length", "Enter Your Length:"),
    numericInput("na", "Enter Your Soidum level (Na): (128-156)"),
    
    
    
    radioButtons("dm", "Do You Have Diabetes Mellitus (DM):", choices = c("Yes", "No"), selected = "Yes"),
    
    
    
    
  ),

    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Formatted text for caption ----
      numericInput("esr_output"),
      numericInput("age_output"),
      numericInput("length_output"),
      numericInput("na_output"),
      textOutput("dm_output")
    )
  )
)
)


