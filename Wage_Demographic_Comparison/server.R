#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library("shiny")
library("dplyr")
library("ggplot2")

setwd("C:/Users/Jimmy/Desktop/INFO201/Info201_FinalProject/Wage_Demographic_Comparison/")
seattle_data <- read.csv(file='C:/Users/Jimmy/Desktop/info201/Info201_FinalProject/Wage_Demographic_Comparison/data/City_of_Seattle_WageGender.csv', sep=",", header=TRUE)
seattle_data[is.na(seattle_data)] <- -1

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # draw the histogram of all job
    output$distPlot <- renderPlot({
      if(input$compare == 1){
        ggplot(seattle_data, aes(seattle_data[,which(colnames(seattle_data)==input$catagory1)], y=seattle_data[,which(colnames(seattle_data)==input$catagory2)])) + geom_point()
      }else{
        for(i in 2:11){
          #temp_table <- matrix(c(seattle_data[which(seattle_data == input$job1),i],seattle_data[which(seattle_data == input$catagory2),i]),ncol=2, nrow = 1)
          #temp <- table(c(input$job1, input$job2), c(seattle_data[which(seattle_data ==input$job1),2], seattle_data[which(seattle_data ==input$catagory2),2]))
          #barplot(temp_table, main=paste0(input$job1, " VS ", input$job2, " ", colnames(seattle_data[i])), names.arg=c(input$job1, input$job2),col=c("darkblue","red"))
          ggplot(seattle_data, aes(y=c(input$job1,input$job1),x=c(seattle_data[which(seattle_data == input$job1),i],seattle_data[which(seattle_data == input$catagory2),i]))) + geom_bar()
        }
      }
    })
    
  })
  
})

#temp <- table(c("Accountant", "Art Exec"), c(seattle_data[which(seattle_data == "Accountant"),2], seattle_data[which(seattle_data == "Act Exec"),2]))
