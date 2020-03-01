library(haven)
library(effec)
library(readr)
library(rmisc)
library(ggplot2)
prod3 <- read.csv("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Daten\\Mappe2.csv", header = TRUE, sep=";")
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
prod3$Stage <- factor(prod3$Stage)

# The errorbars overlapped, so use position_dodge to move them horizontally
pd <- position_dodge(0.1) # move them .05 to the left and right
pd2 <- position_dodge(1)




ggplot(prod3, aes(x=treatment, y=mean, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=ll, ymax=ul), width=.3, position=pd2, size=.5) +
  xlab("Treatment") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  #theme(text = element_text(size=15))+
  coord_cartesian(ylim = c(0, 50))+
  scale_x_discrete(breaks=c("1","2","3","4"),
                   labels=c("Majority","Consensus","Lottery","Random"))+
  theme_bw()+
  theme(text = element_text(size=15))+
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\num_correct.png",dpi = 300,device = png, width = 800, 
       height = 400,scale=1,
       limitsize = FALSE)

prod3 <- read_dta("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Daten\\vm_ggplot2.dta")
prod3$treatment <- factor(prod3$treatment)
rofl2 <- summarySE(prod3, measurevar="dif", groupvars=c("treatment"))


ggplot(rofl2, aes(x=treatment, y=dif)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=dif-ci, ymax=dif+ci), width=.15, position=pd, show.legend = FALSE, size=.5) +
  xlab("Treatment") +
  ylab("Mean work effort reduction")+
  theme_bw()+
  coord_cartesian(ylim = c(0, 8))+
  scale_x_discrete(breaks=c("1","2","3","4"),
                   labels=c("Majority","Consensus","Lottery","Random"))+
  theme_bw()+theme(text = element_text(size=15))+ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\reduction_absolute.png",
         ,dpi = 300,device = png, width = 800, 
         height = 400,scale=1,
         limitsize = FALSE)
