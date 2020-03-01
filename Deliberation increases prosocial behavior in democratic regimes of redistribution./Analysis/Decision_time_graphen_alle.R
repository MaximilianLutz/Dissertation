#Pr?ambel
library(haven)
library("gridExtra")
library("cowplot")
library("tidyverse")
setwd("/Volumes/Ewald/Sync/Decision_Time_Project/Data")
time <- read_dta("productivity_gg6.dta")
head(time)

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

# Data Preparation

time$incomeposition<-factor(time$incomeposition)
time$ratpred<-factor(time$ratpred)
time$type<-factor(time$type)
time$netgain<-factor(time$netgain)
time$linosType<-factor(time$linosType)


df2 <- summarySE(time, measurevar = "decision", groupvars = c( "ratpred", "votingtime"))
df1 <- summarySE(time, measurevar="decision", groupvars=c("incomeposition", "votingtime"))

b <- summarySE(time, measurevar="bruttoincome", groupvars=c("incomeposition", "treatment"))
b

fit1 <- lm(formula = decision ~ incomeposition + calcno , data = time)
fit1
plot(fit1)

time <- filter(time, treatment < 3)

#ggplot(time, aes(x = votingtime, y = decision, color=incomeposition)) + 
 # geom_point() +
  #stat_smooth(method = "lm", col = "incomeposition")

t1 <- ggplot(subset(time, treatment==1), aes(x=votingtime, y=decision, color=incomeposition))+theme_bw()+
  geom_smooth(method="lm")+
  ylim(c(0,100))+
  scale_color_discrete(breaks=c(1,2,3),
                       labels=c("Poor","Middle","Rich"),
                       name="Income position")+
  xlab("Decision time (seconds)") + ylab("Mean decision on tax rate (%)")+
  ggtitle("Earned info")


t2 <- ggplot(subset(time, treatment==2), aes(x=votingtime, y=decision, color=incomeposition))+theme_bw()+
  geom_smooth(method="lm")+
  ylim(c(0,100))+
  scale_color_discrete(breaks=c(1,2,3),
                       labels=c("Poor","Middle","Rich"),
                       name="Income position")+
  xlab("Decision time (seconds)") + ylab("Mean decision on tax rate (%)")+ ggtitle("Random info")


p <- plot_grid( t1,t2, ncol = 2,nrow=, rel_heights = c(3,3))
p

ggsave("2019_rplot.png", plot=p, dpi = 600, width= 1200, height =  limitsize = FALSE)

ggplot(time, aes(x=180-votingtime, y=decision, color=incomeposition))+theme_bw()+
  geom_smooth(method="lm")+
  ylim(c(0,100))+
  scale_color_discrete(breaks=c(1,2,3),
                       labels=c("Poor","Middle","Rich"),
                       name="Income position")+
  xlab("Decision time (seconds)") + ylab("Mean decision on tax rate (%)")


ggplot(time)+theme_bw()+
  geom_smooth(method="lm", aes(x=180-votingtime, y=linosEquadlity, fill=incomeposition))+
  ylim(c(1,3))


ggplot(time)+theme_bw()+
  geom_point(method="gam", aes(x=calcno, y=decision, color=linosType))+
  scale_color_discrete(breaks=c(-1,0,1),
                       labels=c("Equality","Neutral","Equity"),
                       name="Principle of justice")
  

  # Plot: Calcumber to Decision
ggplot(time, aes(x=calcno, y=decision, color=incomeposition))+
  geom_smooth(method="lm")+
  theme_bw()+
  scale_color_discrete(breaks=c(1,2,3),
                       labels=c("Poor","Middle","Rich"),
                       name="Income position")+
  xlab("Calculations made") + ylab("Mean decision on tax rate (%)")

# Plot: Corellation of Calcno and Voting time
ggplot(time, aes(x=calcno, y=180-votingtime, color=incomeposition))+
  geom_smooth(method="lm")+
  theme_bw()

df3 <- summarySE(subset(time,treatment!=5), measurevar="calcno", groupvars=c("incomeposition"))

# Plot: Usage of calculator over incomeposition 
ggplot(df3, aes(x=incomeposition, y=calcno))+
  geom_point()+
  geom_errorbar(aes(ymin=calcno-ci, ymax=calcno+ci))+
  theme_bw()

# Plot: Voting time over incomeposition
ggplot(df1,aes(x=incomeposition, y=votingtime))+
  geom_point()+
  geom_errorbar(aes(ymin=votingtime-ci, ymax=votingtime+ci))+
  theme_bw()



# Hist
ggplot(time)+
  geom_histogram(aes(x=votingtime))

# ???
ggplot(time, aes(x=correct, y=decision, color=type))+
  geom_smooth()+
  theme_bw()+
  scale_color_discrete(breaks=c(1,2,3),
                       labels=c("Low","Middle","High"),
                       name="Wage")+
  xlab("Correct Answers") + ylab("Mean decision on tax rate (%)")


ggplot(df1, aes(x=180-votingtime, y=decision, color=incomeposition))+theme_bw()+
  geom_smooth()+
  ylim(c(0,100))+
  scale_color_discrete(breaks=c(1,2,3),
                       labels=c("Poor","Middle","Rich"),
                       name="Income position")+
  xlab("Decision time (seconds)") + ylab("Mean decision on tax rate (%)")+
  ggtitle("Random noinfo")

head(df1)
  
