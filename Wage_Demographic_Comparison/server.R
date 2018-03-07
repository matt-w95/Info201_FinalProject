




library("shiny")
library("dplyr")
library("ggplot2")
library("ggpubr")

#temp local pathing 
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
   
    # draw the histogram of all job in USA
    output$distPlot <- renderPlot({
      
      if(input$compare == 1){
        usa_ratio <- ggplot(usa_data, aes(x=usa_data$female_num_ppl , y=usa_data$male_num_ppl)) + geom_point() + 
          xlab("# of Female Workers") + ylab("# of Male Workers") + ggtitle("Ratios of Male to Female Workers (USA)") +
          xlim(0, 3500000) + ylim(0,3500000) + geom_abline(intercept = 0, slope = 1)
        usa_avg_wage <- ggplot(usa_data, aes(x=usa_data$female_avg_wage_ft, y=usa_data$female_num_ppl))+ geom_point()+ 
          xlab("Wage of Female Workers") + ylab("Wage of Male Workers") + ggtitle("Ratios of Male to Female Wages (USA)") + 
          geom_abline(intercept = 0, slope = 1)
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