library(shiny)

shinyUI(fluidPage(
  headerPanel(title = 'CAD Heart Disease Prediction'),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

  # Sidebar panel for inputs ----
  sidebarPanel(
    textInput("esr", "Enter Your Erythrocyte Sedimentation Rate (ESR):"),
    textInput("age", "Enter Your Age:"),
    textInput("length", "Enter Your Length:"),
    textInput("na", "Enter Your Soidum level (Na):"),
    
    
    radioButtons("dm", "Do You Have Diabetes Mellitus (DM):", choices = c("Yes", "No"), selected = "Yes"),
    
    
    
    
  ),

    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Formatted text for caption ----
      textOutput("esr_output"),
      textOutput("age_output"),
      textOutput("length_output"),
      textOutput("na_output"),
      textOutput("dm_output")
    )
  )
)
)


