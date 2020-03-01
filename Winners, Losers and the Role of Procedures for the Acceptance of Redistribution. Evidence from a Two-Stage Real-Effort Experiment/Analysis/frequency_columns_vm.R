library(haven)
library(effec)
library(readr)
library(rmisc)
library(ggplot2)
prod3 <- read.csv("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Daten\\Mappe1.csv", header = TRUE, sep=";")
prod3
library(gridExtra)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.90, .drop=FALSE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

prod3$treatment <- factor(prod3$treatment)
#prod3$gd <- factor(prod3$gd)

lol <- summarySE(data=prod3, measurevar="gd", groupvars=c("treatment"),conf.interval = 0.95, .drop = TRUE, na.rm = FALSE)

# The errorbars overlapped, so use position_dodge to move them horizontally
pd <- position_dodge(0.1) # move them .05 to the left and right
pd2 <- position_dodge(0.45)

# Treatment point
h1<-ggplot(data=subset(prod3,treatment==1), aes(x=gd, y=mean)) + 
  geom_col()+
  geom_errorbar(aes(ymin=ll, ymax=ul), width=.3, position=pd, show.legend = FALSE, size=.5) +
  xlab("Majority") +
  ylab("Final tax rate")+
  theme_bw()+
  theme(text = element_text(size=15))+
  scale_x_continuous(breaks=c(1,2,3,4),
                   labels=c("0", "30", "70", "100"))+
  coord_cartesian(xlim = c(0, 5))

h2<-ggplot(data=subset(prod3,treatment==2), aes(x=gd, y=mean)) + 
  geom_col()+
  geom_errorbar(aes(ymin=ll, ymax=ul), width=.3, position=pd, show.legend = FALSE, size=.5) +
  xlab("Consensus") +
  ylab("Final tax rate")+
  theme_bw()+
  theme(text = element_text(size=15))+
  scale_x_continuous(breaks=c(1,2,3,4),
                     labels=c("0", "30", "70", "100"))+
  coord_cartesian(xlim = c(0, 5))

h3<-ggplot(data=subset(prod3,treatment==3), aes(x=gd, y=mean)) + 
  geom_col()+
  geom_errorbar(aes(ymin=ll, ymax=ul), width=.3, position=pd, show.legend = FALSE, size=.5) +
  xlab("Lottery") +
  ylab("Final tax rate")+
  theme_bw()+
  theme(text = element_text(size=15))+
  scale_x_continuous(breaks=c(1,2,3,4),
                     labels=c("0", "30", "70", "100"))+
  coord_cartesian(xlim = c(0, 5))

h4<-ggplot(data=subset(prod3,treatment==4), aes(x=gd, y=mean)) + 
  geom_col()+
  geom_errorbar(aes(ymin=ll, ymax=ul), width=.3, position=pd, show.legend = FALSE, size=.5) +
  xlab("Random") +
  ylab("Final tax rate")+
  theme_bw()+
  theme(text = element_text(size=15))+
  scale_x_continuous(breaks=c(1,2,3,4),
                     labels=c("0", "30", "70", "100"))+
  coord_cartesian(xlim = c(0, 5))
  
harr<-grid.arrange(h1,h2,h3,h4, ncol=2, nrow=2, heights=c(10,10),widths=c(12,12))
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\hist_decision.png",
       plot=harr,dpi = 300,device = png, width = 800, 
       height = 400,scale=1,
       limitsize = FALSE)
