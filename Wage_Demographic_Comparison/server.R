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
library("ggpubr")

setwd("~/Desktop/INFO201/Info201_FinalProject/Wage_Demographic_Comparison/")
seattle_data <- read.csv(file='~/Desktop/INFO201/Info201_FinalProject/Wage_Demographic_Comparison/data/City_of_Seattle_WageGender.csv', sep=",", header=TRUE)
seattle_data[is.na(seattle_data)] <- -1

#USA data Manipulation
usa_data <- read.csv(file='~/Desktop/INFO201/Info201_FinalProject/Wage_Demographic_Comparison/data/United_States_WageGender.csv', sep=",", header=TRUE)
usa_data <- usa_data[usa_data$year == '2015',]
usa_data <- usa_data[ -c(1:3,5,7,9, 11) ]
usa_male <- usa_data[usa_data$sex_name == 'Male',]
usa_female <- usa_data[usa_data$sex_name == 'Female',]
colnames(usa_female)[2:4] <- paste0("female_",colnames(usa_female[2:4]))
colnames(usa_male)[2:4] <- paste0("male_",colnames(usa_male[2:4]))
usa_female <- usa_female[ -c(2) ]
usa_male <- usa_male[ -c(2) ]
usa_data <- merge(usa_female,usa_male,by="soc_name")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # draw the histogram of all job
    output$distPlot <- renderPlot({
      #if(input$compare == 1){
      #  ggplot(seattle_data, aes(seattle_data[,which(colnames(seattle_data)==input$catagory1)], y=seattle_data[,which(colnames(seattle_data)==input$catagory2)])) + geom_point()
      #}else{
      #  for(i in 2:11){
       #   #temp_table <- matrix(c(seattle_data[which(seattle_data == input$job1),i],seattle_data[which(seattle_data == input$catagory2),i]),ncol=2, nrow = 1)
          #temp <- table(c(input$job1, input$job2), c(seattle_data[which(seattle_data ==input$job1),2], seattle_data[which(seattle_data ==input$catagory2),2]))
          #barplot(temp_table, main=paste0(input$job1, " VS ", input$job2, " ", colnames(seattle_data[i])), names.arg=c(input$job1, input$job2),col=c("darkblue","red"))
        #  ggplot(seattle_data, aes(y=c(input$job1,input$job1),x=c(seattle_data[which(seattle_data == input$job1),i],seattle_data[which(seattle_data == input$catagory2),i]))) + geom_bar()
        #}
      #}
      
      if(input$compare == 1){
        ratio <- ggplot(usa_data, aes(x=usa_data$female_num_ppl , y=usa_data$male_num_ppl)) + geom_point() + 
          xlab("# of Female Workers") + ylab("# of Male Workers") + ggtitle("Ratios of Male to Female Workers (USA)") +
          xlim(0, 3500000) + ylim(0,3500000)
        avg_wage <- ggplot(usa_data, aes(x=usa_data$female_avg_wage_ft, y=usa_data$female_num_ppl))+ geom_point()+ 
          xlab("Wage of Female Workers") + ylab("Wage of Male Workers") + ggtitle("Ratios of Male to Female Wages (USA)")
      }else{
        xaxis <-c("Female","Male")
        yratio <-c(usa_data[which(usa_data == input$job1),2], usa_data[which(usa_data == input$job1),4])
        ratio_temp <- data.frame(sex=xaxis,workers=yratio)
        usa_ratio <- ggplot(ratio_temp, aes(x=sex, y=workers, fill=c("blue","pink"))) + geom_bar(stat = "identity") +
          theme(legend.position="none") + geom_text(aes(label=workers), vjust=1.6, color="white", size=3.5) +
          ylab("# Workers") + ggtitle("Ratios of Male to Female Workers (USA)") 
        ywage <-c(usa_data[which(usa_data == input$job1),3], usa_data[which(usa_data == input$job1),5]) 
        wage_temp <- data.frame(sex=xaxis,Wages=ywage)
        usa_avg_wage <- ggplot(wage_temp, aes(x=sex, y=Wages, fill=c("blue","pink"))) + geom_bar(stat = "identity") +
          theme(legend.position="none" ) + geom_text(aes(label=Wages), vjust=1.6, color="white", size=3.5) +
          ylab("Wage of Workers") + ggtitle("Ratios of Male to Female Wages (USA)")
      }
      ggarrange(usa_ratio, usa_avg_wage)
    })
    
  })
  
})

#temp <- table(c("Accountant", "Art Exec"), c(seattle_data[which(seattle_data == "Accountant"),2], seattle_data[which(seattle_data == "Act Exec"),2]))
