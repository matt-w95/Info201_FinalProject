library("shiny")
library("dplyr")
library("ggplot2")
library("ggpubr")
library("reshape")

# Define server logic required to create plots
shinyServer(function(input, output) {
  
  # Seattle data filtering
  Seattle_GenderWage <- read.csv("./data/City_of_Seattle_WageGender.csv") 
  
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
  
  #General Seattle data manipulation
  Seattle_GenderWage_general <- na.omit(Seattle_GenderWage)
  
  worker_count_seattle <-
    Seattle_GenderWage_general %>%
    select(No..Female.Empl, No..Male.Empl)
  
  wage_seattle <-
    Seattle_GenderWage_general %>%
    select(Female.Avg.Hrly.Rate, Male.Avg.Hrly.Rate, Jobtitle)
  
  # USA data Manipulation
  usa_data <- read.csv(file='./data/United_States_WageGender.csv', sep=",", header=TRUE)
  usa_data <- usa_data[usa_data$year == '2015',]
  usa_data <- usa_data[ -c(1:3,5,7,9, 11) ]
  usa_male <- usa_data[usa_data$sex_name == 'Male',]
  usa_female <- usa_data[usa_data$sex_name == 'Female',]
  colnames(usa_female)[2:4] <- paste0("female_",colnames(usa_female[2:4]))
  colnames(usa_male)[2:4] <- paste0("male_",colnames(usa_male[2:4]))
  usa_female <- usa_female[ -c(2) ]
  usa_male <- usa_male[ -c(2) ]
  usa_data <- merge(usa_female,usa_male,by="soc_name")

  usa_data$both_wage <- usa_data$male_avg_wage_ft - usa_data$female_avg_wage_ft
  
  # Top 10 USA data
  usa_withDiff <- mutate(usa_data, usa_Male_Female_diff = (usa_data$male_avg_wage_ft - usa_data$female_avg_wage_ft))
  
  usa_ordered_diff <- usa_withDiff[order(usa_withDiff$usa_Male_Female_diff),]
  
  usa_wage_male <- usa_ordered_diff[(nrow(usa_withDiff) - 9) : nrow(usa_withDiff),]
  usa_wage_female <- usa_ordered_diff[0:10,]
  usa_wage_female <- mutate(usa_wage_female, diff = abs(usa_wage_female$usa_Male_Female_diff))
  
  usa_male_sub <-
    usa_wage_male %>%
    select(soc_name, female_avg_wage_ft, male_avg_wage_ft)
  
  usa_female_sub <-
    usa_wage_female %>%
    select(soc_name, female_avg_wage_ft, male_avg_wage_ft)
  
  usa_male_sub <- melt(usa_male_sub, id=c("soc_name"))
  usa_female_sub <- melt(usa_female_sub, id=c("soc_name"))
  
  # Plots Graphs
  # Plots top ten jobs with greatest wage difference based on gender for seattle
  output$plot10Seattle <- renderPlot({
    male_p <- ggplot(male_sub) + geom_bar(aes(x = Jobtitle, y = value, fill= variable), stat = "identity", position = "dodge", width = 0.7)
    male_p <- male_p + scale_fill_manual("Result", values = c("deepskyblue1", "tan2")) +coord_flip()
    male_p <- male_p + labs(x="Jobs", y="Hourly Wage (Dollars)", title = "Seattle's top 10 jobs where men make more than women")

    female_p <- ggplot(female_sub) + geom_bar(aes(x = Jobtitle, y = value, fill= variable), stat = "identity", position = "dodge", width = 0.7)
    female_p <- female_p + scale_fill_manual("Result", values = c("deepskyblue1", "tan2")) +coord_flip()
    female_p <- female_p + labs(x="Jobs", y="Hourly Wage (Dollars)", title = "Seattle's top 10 jobs where women make more than men")
  
    if(input$choose_gender_best_city == "Female"){
      ggarrange(female_p)
    } else {
      ggarrange(male_p)
    }
  })  
    
  # Plots top ten jobs with greatest wage difference based on gender for USA
  output$plot10USA <- renderPlot({
    usa_male_p <- ggplot(usa_male_sub) + geom_bar(aes(x = soc_name, y = value, fill= variable), stat = "identity", position = "dodge", width = 0.7) +
      scale_fill_manual("Result", values = c("deepskyblue1", "tan2")) +coord_flip() +
      labs(x="Jobs", y=" Wage (Dollars)", title = "USA's top 10 jobs where men make more than women")
    
    usa_female_p <- ggplot(usa_female_sub) + geom_bar(aes(x = soc_name, y = value, fill= variable), stat = "identity", position = "dodge", width = 0.7) + 
      scale_fill_manual("Result", values = c("deepskyblue1", "tan2")) +coord_flip() + 
      labs(x="Jobs", y="Wage (Dollars)", title = "USA's top 10 jobs where women make more than men")
    
    if(input$choose_gender_best_city == "Female"){
      ggarrange(usa_female_p)
    } else {
      ggarrange(usa_male_p)
    }
  })
  
  # Plots general trend of USA jobs or female VS male pay rates of individual jobs
  output$GeneralVSIndividual <- renderPlot({
      if(input$choose_area_general == 3){
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
      } else if(input$choose_area_general == 4) {
        if(input$compare == 1){
          seattle_ratio <- ggplot(worker_count_seattle, aes(worker_count_seattle$No..Female.Empl, worker_count_seattle$No..Male.Empl)) + geom_point() + xlim(0,150) + ylim(0,150)
          seattle_ratio <- seattle_ratio + geom_abline() + labs(x="Number of female employees", y="Number of male employees", title="General trend of counts of male and female employees in Seattle")
          
          seattle_wage <- ggplot(wage_seattle, aes(wage_seattle$Female.Avg.Hrly.Rate, wage_seattle$Male.Avg.Hrly.Rate)) + geom_point()
          seattle_wage <- seattle_wage + geom_abline() + labs(x="Average female hourly wage", y = "Average male hourly wage", title = "General trend of male and female hourly wage in Seattle")
        } else {
          xaxis <-c("Female","Male")
          yratio <-c(Seattle_GenderWage_general[which(Seattle_GenderWage_general == input$job2),3], Seattle_GenderWage_general[which(Seattle_GenderWage_general == input$job2),6])
          
          ratio_temp <- data.frame(sex=xaxis,workers=yratio)
          
          seattle_ratio <- ggplot(ratio_temp, aes(x=sex, y=workers, fill=c("blue","pink"))) + geom_bar(stat = "identity") +
            theme(legend.position="none") + geom_text(aes(label=workers), vjust=1.6, color="white", size=3.5) +
            ylab("# Workers") + ggtitle("Ratios of Male to Female Workers (Seattle)") 
          
          ywage <-c(Seattle_GenderWage_general[which(Seattle_GenderWage_general == input$job2),2], Seattle_GenderWage_general[which(Seattle_GenderWage_general == input$job2),5]) 
          wage_temp <- data.frame(sex=xaxis,Wages=ywage)
          
          seattle_wage <- ggplot(wage_temp, aes(x=sex, y=Wages, fill=c("blue","pink"))) + geom_bar(stat = "identity") +
            theme(legend.position="none" ) + geom_text(aes(label=Wages), vjust=1.6, color="white", size=3.5) +
            ylab("Wage of Workers") + ggtitle("Ratios of Male to Female Wages (Seattle)")
        }
        ggarrange(seattle_ratio, seattle_wage)
      }
    })
  
  # Sidepanels for plots
  output$tabUi <- renderUI({
    if (input$tab == "America's Top 10" | input$tab == "Seattle's Top 10") {
      sidePanel <- list(selectInput("choose_gender_best_city", "Choose the gender", choices = c("Male", "Female")))
    } else if (input$tab == "General Trend VS Individual") {
      sidePanel <- list(radioButtons("compare", label = "Compare By", choices = list("All Jobs" = 1, "Specific Jobs" = 2), selected = 1),
                        radioButtons("choose_area_general", label = "Choose area", choices = list("USA" = 3, "Seattle" = 4), selected = 3),
             conditionalPanel(
               condition = ("input.compare == 2 & input.choose_area_general == 3"),
                  selectInput('job1', 'Pick A Job', usa_data[,which(colnames(usa_data)== "soc_name" )], selected = "Accountant")
             ),
             conditionalPanel(
               condition = ("input.compare == 2 & input.choose_area_general == 4"),
               selectInput('job2', 'Pick A Job', Seattle_GenderWage_general[,which(colnames(Seattle_GenderWage_general)== "Jobtitle" )], selected = "Accountant")
             ))
    }
    return(sidePanel)
  })
})
