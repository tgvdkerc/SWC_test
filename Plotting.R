df <- read.csv("Metadata.csv",na.strings=c("","NA"))   #na.strings to treat empty ce"lls as NA  # save data in dataframe called df
df <- na.omit (df)   ### remove NA values  


# which variables?
str(df)     #also states what type of variable R thinks the variables are! eg: reactor.cycle is numerical for R since it are number, but there are only two number so it is a factor

# Start plotting
library("ggplot2")

# Make first plot
ggplot(data = df, aes(x = Timepoint, y = ph, fill=Reactor.cycle))+    #Data: the dataframe you want to plot (first needed argument) ; aes: aestethics --> what to plot
  geom_point(shape=21)                                   #how you want to see the data --> in this case as points
                                                # use View (df) in console to see dataframe and determine which data you want to visualize
                                                                      #fill=Reactor.cycle: filling the dots with color

df$Reactor.cycle <- factor(df$Reactor.cycle)    #change variable "reactor.cycle" to a factor, because R thinks it is numerical, but it is only 1 or 2 --> factor

#warning message: removed 8 rows containing missing values (empty rows in csv file are deleted)

ggplot(data = df, aes(x = Timepoint, y = ph, fill=Reactor.cycle))+
  geom_point(shape=21, size=4)
df$Reactor.cycle <- factor(df$Reactor.cycle)

ggplot(data = df, aes(x = Timepoint, y = temp, fill=Reactor.cycle))+
  geom_point(shape=21, size=4)

#Store ggplot object
p1 <- ggplot(data = df, aes(x = Timepoint, y = temp, fill=Reactor.cycle))
p1 + geom_point(shape=21,size=4, alpha=0.5) + theme_bw()   #alpha: transparancy of labels and theme_bw() remove grey background of plot and go white

#alternative
p1 <- ggplot(data = df, aes(x = Timepoint, y = temp, fill=Reactor.cycle))
p2 <- p1 + geom_point(shape=21,size=4, alpha=0.5) + theme_bw()       #otherwise the + below takes the original p1! --> override the first p1 by storing it again as p1
p2 + theme_bw()

#lets facet this
p3 <- p2 + facet_grid(~Reactor.cycle)  #separate graphs/data according to reactor.cycle --> tilde om aan te geven waarop je scheiding gebaseerd is
p3   #display graph

#How do I know what's inside reactor phase
df$Reactor.phase
levels(df$Reactor.phase)

p4 <- p2 + facet_grid (Reactor.phase~Reactor.cycle)    # for each reactor phase a row and for each reactor cycle a column
p4

#~ also often used for formulas in statistics
#click zoom in plot area to show entire plot in separate window --> entire plot not always visible without zoom

#change color based on reactor phase instead of on reactor cycle
p5 <- ggplot(data = df, aes(x = Timepoint, y = temp, fill=Reactor.phase))
p6 <- p5 + geom_point(shape=21,size=4,alpha=0.5) + theme_bw()
p7 <- p6 + facet_grid(Reactor.phase~Reactor.cycle)
p7

p7 + geom_line(aes(color=Reactor.phase))


#Challenge time
### ggplot for conductivity
data <- df
data[!apply(is.na(data) |data=="",1,all)]
data


p8 <- ggplot(data=df,aes(x=Timepoint,y=Conductivity, fill=Reactor.phase))
p9 <- p8 + geom_point(shape=21,size=4,alpha=0.5) + theme_bw() + facet_grid(Reactor.phase~Reactor.cycle)
p9 +xlab("Time (d)") + ylab("Conductivity")



