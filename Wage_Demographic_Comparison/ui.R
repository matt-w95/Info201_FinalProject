



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
      selectInput("choose_gender_best_city", "Choose the gender",
                  choices = c("Male", "Female")),
      
      
      radioButtons("compare", label = h3("Compare By"), choices = list("All Jobs" = 1, "Specific Jobs" = 2), selected = 1),
      conditionalPanel(
        condition = "input.compare == 2",
        selectInput('job1', 'Pick A Job', usa_data[,which(colnames(usa_data)== "soc_name" )], selected = "Accountant")
      ),
      hr(),
      helpText(paste("Note:","The USA data is from 2015", sep="\n"))
      
    ),
    
      # Show a plot of the generated distribution
    mainPanel(
       plotOutput("plot1"),
       plotOutput("plot2")
    )
  )
))