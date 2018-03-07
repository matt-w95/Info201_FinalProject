



library(shiny)
library(dplyr)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The Gender Gap between Seattle and United States", windowTitle = "Seattle VS USA"),
  p("Our project is an interactive data visualization of economic gender inequality in ",
    tags$a(href = "https://datausa.io/profile/geo/united-states/#category_wages", "America"),
    " and the city of ", 
    tags$a(href = "https://catalog.data.gov/dataset/city-of-seattle-wages-comparison-by-gender-all-job-classifications-e471a", 
           "Seattle."), " The data we are using is from the American Community Survey conducted through
    the United States Census Bureau. Users can interact and ask questions about the average pay in 2015
    for both genders across America and in the city of Seattle. To see the code for our project, click ",
    tags$a(href = "https://github.com/matt-w95/Info201_FinalProject", "here.")),
  
  # Pick job Title
  sidebarLayout(
    sidebarPanel(
      uiOutput("tabUi")
    ),
    
      # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id = "tab", type = "tabs",
                  tabPanel("America's Top 10", plotOutput("plot10USA")),
                  tabPanel("Seattle's Top 10", plotOutput("plot10Seattle")),
                  tabPanel("General Trend VS Individual", plotOutput("plot2")))
    )
  )
))