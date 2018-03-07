#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(ggpubr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Seattle data filtering
  Seattle_GenderWage <- read.csv("~/Info201_HWs/Info201_FinalProject/Wage_Demographic_Comparison/data/City_of_Seattle_WageGender.csv") 
  
  Seattle_withDiff <- mutate(Seattle_GenderWage, Male_Female_diff = (Seattle_GenderWage$Male.Avg.Hrly.Rate - Seattle_GenderWage$Female.Avg.Hrly.Rate))
  Seattle_withDiff <- na.omit(Seattle_withDiff)
  
  ordered_diff <- Seattle_withDiff[order(Seattle_withDiff$Male_Female_diff),]
  
  wage_male <- ordered_diff[(nrow(Seattle_withDiff) - 9) : nrow(Seattle_withDiff),]
  wage_female <- ordered_diff[0:10,]
  wage_female <- mutate(wage_female, diff = abs(wage_female$Male_Female_diff))
  
  male_sub <-
    wage_male %>%
    select(Jobtitle, Female.Avg.Hrly.Rate, Male.Avg.Hrly.Rate)
  
  female_sub <-
    wage_female %>%
    select(Jobtitle, Female.Avg.Hrly.Rate, Male.Avg.Hrly.Rate)
  
  male_sub <- melt(male_sub, id=c("Jobtitle"))
  female_sub <- melt(female_sub, id=c("Jobtitle"))
  
  
  #Plots top ten jobs with greatest wage difference based on gender for seattle
  output$plot1 <- renderPlot({
    male_p <- ggplot(male_sub) + geom_bar(aes(x = Jobtitle, y = value, fill= variable), stat = "identity", position = "dodge", width = 0.7)
    male_p <- male_p + scale_fill_manual("Result", values = c("deepskyblue1", "tan2")) +coord_flip()
    male_p <- male_p + labs(x="Jobs", y="Hourly Wage (Dollars)", title = "Seattle's top 10 jobs where men make more than women")

    female_p <- ggplot(female_sub) + geom_bar(aes(x = Jobtitle, y = value, fill= variable), stat = "identity", position = "dodge", width = 0.7)
    female_p <- female_p + scale_fill_manual("Result", values = c("deepskyblue1", "tan2")) +coord_flip()
    female_p <- female_p + labs(x="Jobs", y="Hourly Wage (Dollars)", title = "Seattle's top 10 jobs where women make more than men")
    
    if(input$choose_gender_best_city == "Female"){
      female_p
    } else {
      male_p
    }
  })
})
