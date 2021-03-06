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


### join data sets ###
#split current data file
physicochem <- df %>%  
  select(sample_title,temp,ph,Conductivity)

diversity <- df %>% 
  select(sample_title,contains("Diversity"))

physicodiversity <- dplyr::full_join(physicochem,diversity,by="sample_title")

## remove na ###
#df.nona <- na.exclude(df)   #filter out all NA --> statistics don't take into account
#rowSums(is.na(df)) == ncol(df)   #if this is true --> no na's anymore

#na.omit()   regression function still knows there were NA's and will take this into account!
#you can also use blank.lines.skip=TRUE in the read.csv function --> will not work if some columns are strings and others are number --> also add stringsAsFactors = False --> didn't work but oke :)



### combining dplyr and ggplot ###
p1 <- ggplot(data = df, aes(x = Timepoint, y = Cell.density..cells.mL., fill=Reactor.cycle))
p1 + geom_point(shape=21,size=4, alpha=0.5) + theme_bw()

df.2 <- df %>%  filter(Reactor.cycle==2) 

p2 <- df %>%  filter(Reactor.cycle==2) %>% 
  ggplot(aes(x = Timepoint, y = Cell.density..cells.mL., fill=Cell.density..cells.mL.)) + geom_point(shape=21,size=4, alpha=0.5) + theme_bw()
p2

p2 + scale_y_log(10)
