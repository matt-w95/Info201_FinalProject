



library(shiny)
library(dplyr)
library(ggplot2)

seattle_data <- 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Wage Gap in USA based on Sex"),
  
  # Pick job Title
  sidebarLayout(
    sidebarPanel(
      radioButtons("compare", label = h3("Compare By"), choices = list("All Jobs" = 1, "Specific Jobs" = 2), selected = 1),
      conditionalPanel(
        condition = "input.compare == 2",
        selectInput('job1', 'Pick A Job', usa_data[,1], selected = "Accountant")
      ),
      hr(),
      helpText(paste("Note:","The USA data is from 2015", sep="\n"))
    ),
    
    
      # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))