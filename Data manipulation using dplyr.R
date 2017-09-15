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
