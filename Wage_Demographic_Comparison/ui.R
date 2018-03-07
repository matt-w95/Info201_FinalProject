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
  titlePanel("The Gender Gap between Seattle and United States"),
  
  # Pick job Title
  sidebarLayout(
    sidebarPanel(
      helpText(paste0("Note: The USA data is from 2015")),
      selectInput("choose_gender_best_city", "Choose the gender",
                  choices = c("Male", "Female"))
    ),
    
    
    
    
      # Show a plot of the generated distribution
    mainPanel(
       plotOutput("plot1"),
       plotOutput("plot2")
    )
  )
))