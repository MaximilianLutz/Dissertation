library(haven)
library(gdata) 
library(readr)
library(ggplot2)
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

lb1 <- read.csv("C:\\Users\\Lutz\\Dropbox\\Leaky Bucket\\cont1_results_mexport.csv",
                sep = ";")

lb1$dv<-factor(lb1$dv)

ggplot(lb1, aes(x=x, y=b, color=dv)) + 
  geom_point()+
  geom_line()+
  geom_errorbar(aes(ymin=ll, ymax=ul), alpha=1, width=.01)+
  xlab("") +
  ylab("Predictions")+
  ggtitle("Ideal")+
  scale_color_discrete(breaks=c("1","2","3"),
                       labels=c("Ideal", "Decision","Rational Prediction"),
                       name="")

ggsave("C:\\Users\\Lutz\\Dropbox\\Leaky Bucket\\Paper_LB\\ego_pred2.png"
       ,plot=last_plot(),dpi = 300,device = png, width = 400, 
       height = 400,scale=1,
       limitsize = FALSE)
