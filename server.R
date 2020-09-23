library(shiny)

shinyServer(function(input,output){
  output$age_output = {(
    renderText(input$age)
  )}

  output$gender_output = {(
    renderText(input$gender)
  )}

  output$bp_output = {(
    renderText(input$bp)
  )}
})
