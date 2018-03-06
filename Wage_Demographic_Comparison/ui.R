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
      radioButtons("compare", label = h3("Compare Wage By"), choices = list("All Jobs" = 1, "Two different Jobs" = 2), selected = 1), br(),
      selectInput('catagory1', 'Compare By', colnames(seattle_data[,2:11]), selected = "Female.Avg.Hrly.Rate"),
      selectInput('catagory2', 'And', colnames(seattle_data[,2:11]), selected = "No..Female.Empl"), 
      selectInput('job1', 'Pick A Job', seattle_data[,1], selected = "Accountant"),
      selectInput('job2', 'Pick A Job', seattle_data[,1], selected = "Act Exec"),
      hr(),
      helpText(paste0("Note: If the graph is negative 1, this means we do not have data on that job"))
    ),
      # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))