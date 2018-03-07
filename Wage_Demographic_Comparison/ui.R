



library(shiny)
library(dplyr)
library(ggplot2)

seattle_data <- 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The Gender Gap between Seattle and United States"),
  
  # Pick job Title
  sidebarLayout(
    sidebarPanel(
      helpText("Click the 'Top 10' tab"),
      selectInput("choose_gender_best_city", "Choose the gender",
                  choices = c("Male", "Female")),
      hr(),
      
      helpText("Click the 'General Trend VS Individual' tab"),
      radioButtons("compare", label = "Compare By", choices = list("All Jobs" = 1, "Specific Jobs" = 2), selected = 1),
      conditionalPanel(
        condition = "input.compare == 2",
        selectInput('job1', 'Pick A Job', usa_data[,which(colnames(usa_data)== "soc_name" )], selected = "Accountant")
      ),
      helpText("Note: The USA data is from 2015")
      
    ),
    
      # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Top 10", plotOutput("plot1")),
                  tabPanel("General Trend VS Individual", plotOutput("plot2")))
    )
  )
))