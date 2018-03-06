#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library("shiny")
library("dplyr")
library("ggplot2")

seattle_data <- 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Wage Gap in Seattle based on Sex"),
  
  # Pick job Title
  sidebarLayout(
    sidebarPanel(
      radioButtons("compare", label = h3("Compare By"), choices = list("All Jobs" = 1, "Specific Jobs" = 2), selected = 1), br(),
      selectInput('catagory', 'Compare By', c("Wage","Ratio of Men and Women"), selected = "Wage"),
      selectInput('job1', 'Pick A Job', usa_data[,1], selected = "Accountant"),
      hr(),
      helpText(paste0("Note: The USA data is from 2015"))
    ),
    
    
      # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))