#Pr?ambel
library(haven)
library("gridExtra")
library("cowplot")
library("tidyverse")
library("ggplot2")
setwd("/Users/Max/Nextcloud/Sync/FOR2104_Papiere/Expert/Daten")
#expert <- read_dta("20170721_expert_gg.dta")
#expert2 <- read_dta("201901120_expert_gg2.dta")
expert3 <- read_dta("20200102_expert_ggc.dta")
#expert <- read_dta("20200102_expert_gg.dta")
expert <- read_dta("20200102.dta")
#head(expert)

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


sux  <- summarySE(expert, measurevar = "sum_success", groupvars = c("treatment", "ressources"))
suxM  <- summarySE(expert, measurevar = "sum_success_m", groupvars = c("treatment", "ressources"))
suxE  <- summarySE(expert, measurevar = "sum_success_e", groupvars = c("treatment", "ressources"))


distE1 <- summarySE(subset(expert, treatment==1), measurevar = "ed", groupvars = c("ressources", "groupmember"))
distE2 <- summarySE(subset(expert, treatment==2), measurevar = "distribute", groupvars = c("ressources", "groupmember"))


require(ggplot2)
require(scales)

# Member T1 
a1<- ggplot(subset(expert, ressources==10 & treatment == 1), aes(x = sum_success_m)) +  
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent, name = "Share of Groups", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                   labels=c("1","2","3"),
                   name="Number of survivors")+
  ggtitle("R<S")

a2 <- ggplot(subset(expert, ressources==15 & treatment == 1), aes(x = sum_success_m)) +  
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R=S")

a3 <- ggplot(subset(expert, ressources==20 & treatment == 1), aes(x = sum_success_m)) +  
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R>S")

a <- plot_grid( a1,a2,a3, ncol = 3,nrow=1, rel_heights = c(3,3))
a
ggsave("20200102_expert_member1.png", device = "png", width = 18, height = 11, limitsize = FALSE)

expert$treatment <- factor(expert$treatment, levels=c(1,2), labels=c("Private Information", "Public Information") )


a1 <-  ggplot(subset(expert, ressources==10), aes(x = sum_success_m, fill=treatment)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)), position = position_dodge()) +
  scale_fill_grey()+
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R>S")


a2 <-  ggplot(subset(expert, ressources==15), aes(x = sum_success_m, fill=treatment)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)), position = position_dodge()) +
  scale_fill_grey()+
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R>S")


a3 <-  ggplot(subset(expert, ressources==20), aes(x = sum_success_m, fill=treatment)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)), position = position_dodge()) +
  scale_fill_grey()+
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R>S")

a <- plot_grid( a1,a2,a3, ncol = 3,nrow=1, rel_heights = c(3,3))
a
ggsave("20200102_expert_member2.png", device = "png", width = 18, height = 11, limitsize = FALSE)

################################################################################################################
a1<- ggplot(subset(expert, ressources==10 & treatment == 1), aes(x = sum_success_e)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .8) + 
  scale_y_continuous(labels = percent, name = "Share of Groups", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R<S")

a2 <- ggplot(subset(expert, ressources==15 & treatment == 1), aes(x = sum_success_e)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)), width = .8) + 
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R=S")

a3 <- ggplot(subset(expert, ressources==20 & treatment == 1), aes(x = sum_success_e)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .8) + 
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R>S")

a <- plot_grid( a1,a2,a3, ncol = 3,nrow=1, rel_heights = c(3,3))
a
ggsave("20191113_expert_expert1.png", device = "png", width = 18, height = 11, limitsize = FALSE)

################################################################################################################
a1<- ggplot(subset(expert, ressources==10 & treatment == 2), aes(x = sum_success_e)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .8) + 
  scale_y_continuous(labels = percent, name = "Share of Groups", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R<S")

a2 <- ggplot(subset(expert, ressources==15 & treatment == 2), aes(x = sum_success_e)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)), width = .8) + 
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R=S")

a3 <- ggplot(subset(expert, ressources==20 & treatment == 2), aes(x = sum_success_e)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .8) + 
  scale_y_continuous(labels = percent, name = "", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R>S")

a <- plot_grid( a1,a2,a3, ncol = 3,nrow=1, rel_heights = c(3,3))
a
ggsave("20191113_expert_expert2.png", device = "png", width = 18, height = 11, limitsize = FALSE)

#1 Claims ehrlich? 
# also, Claims vs.Bedarf, über Treatment(Ressource vs claims)
# Höhere Claims bei PI (-> Experte ist dann egal)

sux  <- summarySE(subset(expert2, honest <= 0), measurevar = "honest", groupvars = c("treatment", "ressources"))
sux$honest <- sux$honest*-1
sux$treatment<-factor(sux$treatment)

ggplot(data=sux, aes(x=ressources, y=honest, fill=treatment))+
 geom_bar(stat="identity", position = position_dodge(width = 3), width = 2.5)+
  geom_errorbar(aes(ymin=honest-ci, ymax=honest+ci), position = position_dodge(width = 3), width = 1)+
  scale_x_continuous(breaks=c(10,15,20),
                     labels=c("10","15","20"),
                     name="Availlable Ressources")+ ylab("Mean of Falsely Clamed Points  ")+
scale_fill_discrete(breaks=c(1,2), 
                    labels=c("Private Information", "Public Information"), name="Treatment")
ggsave("20191113_NEW_1.png", device = "png", width = 18, height = 11, limitsize = FALSE)



#2 Mehr Teure überleben? 
# Kosten = Bedarf -> höherer Bedarf, höhere Wahrscheinlichkeit, zu überleben?
# Es geht um den Dritten (what?)
sux  <- summarySE(expert3, measurevar = "success", groupvars = c("treatment", "incpos"))
sux$incpos<-factor(sux$incpos)
sux$treatment<-factor(sux$treatment)

ggplot(data=sux,aes(x=incpos, y=success, shape=treatment))+
  geom_point(position = position_dodge(width = .5), size=3)+
  geom_errorbar(aes(ymin=success-ci, ymax=success+ci), position = position_dodge(width = .5), width = .1)+
ylab("Probability of Survival")+
  scale_shape_discrete(breaks=c(1,2), 
                      labels=c("Private Information", "Public Information"), name="Treatment")+
  scale_x_discrete(breaks=c(1,2,3),
                     labels=c("Bottom","Middle","Top"),
                     name="Income Position")
ggsave("20191113NEW_2.png", device = "png", width = 18, height = 11, limitsize = FALSE)

  
  

#3 Wird der Experte Bedarfsgerechter? 
# Verändern sich die Expertenvorschläge normativ? -> Figure 4 nur die Teuersten
  

a1 <-ggplot(subset(expert3, incpos== 3 & ressources== 10 & sum_success_e>0), aes(x = sum_success_e, group=treatment)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .7,position=position_dodge(width=.8)) + 
  scale_y_continuous(labels = percent, name = "Share of Groups", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R<S")


a2 <-ggplot(subset(expert3, incpos== 3 & ressources== 15 & sum_success_e>0), aes(x = sum_success_e, group=treatment)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .7,position=position_dodge(width=.8)) + 
  scale_y_continuous(labels = percent, name = "Share of Groups", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R<S")

ggplot(subset(expert3, incpos== 3 & ressources== 20 & sum_success_e>0), aes(x = sum_success_e, group=treatment)) +  
  geom_bar(aes(y = (..count..)/sum(..count..)),width = .7,position=position_dodge(width=.8)) + 
  scale_y_continuous(labels = percent, name = "Share of Groups", limits = c(0,1))+
  scale_x_continuous(breaks=c(1,2,3),
                     labels=c("1","2","3"),
                     name="Number of survivors")+
  ggtitle("R<S")




a <- plot_grid( a1,a2,a3, ncol = 3,nrow=, rel_heights = c(3,3))
a
ggsave("2019113NEW_3.png", device = "png", width = 18, height = 11, limitsize = FALSE)

 