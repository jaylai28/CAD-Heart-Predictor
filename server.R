library(shiny)

shinyServer(function(input,output){
  output$esr_output = {(
    renderText(input$esr)
  )}
  
  output$age_output = {(
    renderText(input$age)
  )}

  output$length_output = {(
    renderText(input$length)
  )}

  output$na_output = {(
    renderText(input$na)
  )}
  
  output$dm_output = {(
    renderText(input$dm)
  )}
})
