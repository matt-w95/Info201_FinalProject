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
  
  # Side panels
  sidebarLayout(
    sidebarPanel(
      uiOutput("tabUi")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id = "tab", type = "tabs",
                  tabPanel("America's Top 10", plotOutput("plot10USA"), 
                           p("Here we can see the top 10 jobs in America where men make more than women
                             and vice versa. On the y-axis, you can see the jobs titles while the
                             x-axis shows the wage. According to the data, men earn more for white and
                             gold-collar jobs while females earn more from blue-collar jobs.")),
                  tabPanel("Seattle's Top 10", plotOutput("plot10Seattle"),
                           p("Here we can see the top 10 jobs in Seattle where men make more than women
                             and vice versa. On the y-axis, you can see the job titles while the
                             x-axis shows the wage. According to the data, men earn more for white and 
                             red-collar jobs while females earn more from white-collar jobs.")),
                  tabPanel("General Trend VS Individual", plotOutput("GeneralVSIndividual"),
                           p("When comparing 'All Jobs', we can see the ratio of male to female workers
                              in America and Seattle. For America, the ratio of workers is even with a
                              1:1 ratio, while the wages show that men have much higher wages than women.
                              In Seattle, both the ratio of workers and wages is even with a 1:1 ratio.
                             When comparing 'Specific Jobs', we can see the direct relationship between
                              female and male worker ratios and wages.")))
    )
  )
))