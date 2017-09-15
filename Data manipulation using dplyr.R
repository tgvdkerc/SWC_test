# data manipulation with dplyr

### library loading ###
library (ggplot2)
library(dplyr) 


### load data ###
df <- read.csv("Metadata.csv",na.strings=c("","NA"))
df <- na.omit (df) 

mean(df[df$Reactor.phase == "Control", "ph"])  #want to calculate mean on the dataframe df but df is huge so only select interested parameters df[rows,columns] meaning (select all rows of ph for which reactorphase is 'control'')
levels(df$Reactor.phase)   #only gives the different levels of the parameter reactor phase
df$Reactor.phase   #gives entire column

### select eg physico chemical parameters pH, T and conductivity ###

physicochem <- select(df,ph,temp,Conductivity)  #to check if you use dplyr, type select and see the options, once you type the () then you won't see it anymore

# type %>%  using ctrl+shift+m    = pipe symbol --> useful because it then suggests the variables as you type --> use tab completion!!! wow!!!
physicochem <- df %>% select(ph,temp,Conductivity)

### combining filter and select arguments ###
#interested in physicochem but only for the 'control'

physicochem.control <- df %>%  #start dataframe 
  filter(Reactor.phase == "Control") %>%     #pipe dataframe to filter  | subset rows
  select(ph,temp,Conductivity)    #pipe filtered dataframe to select    | subset columns

###challenge###
#select only the diversity parameters for reactor phase startup

divparam <- df %>% 
  filter(Reactor.phase  == "Startup") %>% 
  select(Diversity...D0,Diversity...D1,Diversity...D2)    # more compact: use contains("Diversity") to encompass all objects containing that word!

###group_by###
meanph <- df %>% group_by(Reactor.phase) %>%     #piping contents of dataframe to the group by function and for each group we calculate the mean of the ph
  summarise(mean.ph = mean(ph),
            mean.d2 = mean(Diversity...D2),    #mean of diversity index 2
            sd.ph = sd(ph))        #standard deviation of ph
meanph

### challenge ###
# Generate this summary for reactor phase 2 only and add standard deviation of the d2 and the log10 transformed cell count
Challenge <- df %>% 
  filter(Reactor.cycle == 2) %>%     #piping contents of dataframe to the group by function and for each group we calculate the mean of the ph
  group_by(Reactor.phase) %>% 
  summarise(mean.ph = mean(ph),
            mean.d2 = mean(Diversity...D2),    #mean of diversity index 2
            sd.ph = sd(ph),    #standard deviation of ph
            sd.D2 = sd(Diversity...D2),
            mean.log10celldens = mean(log10(Cell.density..cells.mL.)))        
Challenge

#filter subsets observations (rows) and select selects variables (colums)

### mutate to make new variables ###

Challenge <- df %>% 
  filter(Reactor.cycle == 2) %>%     #piping contents of dataframe to the group by function and for each group we calculate the mean of the ph
  group_by(Reactor.phase) %>% 
  mutate(condratio=Conductivity/temp) %>% 
  summarise(mean.ph = mean(ph),
            mean.d2 = mean(Diversity...D2),    #mean of diversity index 2
            sd.ph = sd(ph),    #standard deviation of ph
            sd.D2 = sd(Diversity...D2),
            mean.log10celldens = mean(log10(Cell.density..cells.mL.)),
            mean.condrat = mean(condratio))        
Challenge
