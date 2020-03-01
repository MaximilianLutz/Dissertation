library(haven)
library(effec)
library(tidyverse)
library(readr)
library(ggplot2)
prod3 <- read_dta("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Daten\\vm_ggplot3.dta")
prod3$treatment <- factor(prod3$treatment)
prod3$netpay_cat <- factor(prod3$netpay_cat)
head(prod3)
pd <- position_dodge(1)
wi<-1000
hi<-300

# The palette with black:
cbPalette <- c("#a0a0a0", "#fcbb06", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

#Alles
df <- summarySE(data=subset(prod3, groupdecision>0), measurevar="satisfaction", groupvars=c("treatment","netpay_cat"))
b1 <- ggplot(df,aes(x=treatment, y=satisfaction,fill=netpay_cat))+
  geom_col(position = pd)+
  theme_bw()+
  geom_errorbar(aes(ymin=satisfaction-ci,ymax=satisfaction+ci),position = pd,size=.5,width=.3)+
  scale_x_discrete(breaks=c("1", "2", "3","4"),
                   labels=c("Majority", "Consensus", "Lottery","Random"))+
  xlab("Treatment")+ylab("Satisfaction") + labs(fill="Income Position")+
  scale_fill_manual(values=cbPalette,labels=c("Net gain", "Net loss"))+
  theme(text=element_text(size=25))+
  scale_y_continuous(breaks = c(0,2,4,6,8,10),
                     labels = c("0","2","4","6","8","10"))+
  coord_cartesian(ylim=c(0,10))
b1  

ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\sat_split.png",
       plot=last_plot(),dpi = 300,device = png, width = wi, 
       height = 600,scale=1,
       limitsize = FALSE)



#0%
df <- summarySE(data=subset(prod3, groupdecision==0), measurevar="satisfaction", groupvars=c("treatment"))
b1 <- ggplot(df,aes(x=treatment, y=satisfaction))+
  geom_col(width = .6)+
  theme_bw()+
  geom_errorbar(aes(ymin=satisfaction-ci,ymax=satisfaction+ci),position = pd,size=.5,width=.3)+
  scale_x_discrete(breaks=c("1", "2", "3","4"),
                   labels=c("Majority", "Consensus", "Lottery","Random"))+
  xlab("Treatment")+ylab("Satisfaction") + labs(fill="Income Position")+
  theme(text=element_text(size=25))+
  scale_y_continuous(breaks = c(0,2,4,6,8,10),
                     labels = c("0","2","4","6","8","10"))+
  coord_cartesian(ylim=c(0,10))+
  ggtitle("0%")
b1  
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\sat_split0.png",
      plot=last_plot(),dpi = 300,device = png, width = 400, 
     height = 300,scale=1,
    limitsize = FALSE)

#30%
df <- summarySE(data=subset(prod3, groupdecision==30), measurevar="satisfaction", groupvars=c("treatment","netpay_cat"))
b2 <- ggplot(df,aes(x=treatment, y=satisfaction,fill=netpay_cat))+
  geom_col(position = pd)+
  theme_bw()+
  geom_errorbar(aes(ymin=satisfaction-ci,ymax=satisfaction+ci),position = pd,size=.5,width=.3)+
  scale_x_discrete(breaks=c("1", "2", "3","4"),
                   labels=c("Majority", "Consensus", "Lottery","Random"))+
  xlab("Treatment")+ylab("Satisfaction") + labs(fill="Income Position")+
  scale_fill_manual(values=cbPalette,labels=c("Net gain", "Net loss"))+
  theme(text=element_text(size=25))+
  scale_y_continuous(breaks = c(0,2,4,6,8,10),
                     labels = c("0","2","4","6","8","10"))+
  coord_cartesian(ylim=c(0,10))+
  ggtitle("30%")
b2
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\sat_split30.png",
       plot=last_plot(),dpi = 300,device = png, width = wi, 
       height = hi,scale=1,
       limitsize = FALSE)

#70%
df <- summarySE(data=subset(prod3, groupdecision==70), measurevar="satisfaction", groupvars=c("treatment","netpay_cat"))
b3 <- ggplot(df,aes(x=treatment, y=satisfaction,fill=netpay_cat))+
  geom_col(position = pd)+
  theme_bw()+
  geom_errorbar(aes(ymin=satisfaction-ci,ymax=satisfaction+ci),position = pd,size=.5,width=.3)+
  scale_x_discrete(breaks=c("1", "2", "3","4"),
                   labels=c("Majority", "Consensus", "Lottery","Random"))+
  xlab("Treatment")+ylab("Satisfaction") + labs(fill="Income Position")+
  scale_fill_manual(values=cbPalette,labels=c("Net gain", "Net loss"))+
  theme(text=element_text(size=25))+
  scale_y_continuous(breaks = c(0,2,4,6,8,10),
                     labels = c("0","2","4","6","8","10"))+
  coord_cartesian(ylim=c(0,10))+
  ggtitle("70%")
b3
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\sat_split70.png",
       plot=last_plot(),dpi = 300,device = png, width = wi, 
       height = hi,scale=1,
       limitsize = FALSE)



#100%
df <- summarySE(data=subset(prod3, groupdecision==100), measurevar="satisfaction", groupvars=c("treatment","netpay_cat"))
b4 <- ggplot(df,aes(x=treatment, y=satisfaction,fill=netpay_cat))+
  geom_col(position = pd)+
  theme_bw()+
  geom_errorbar(aes(ymin=satisfaction-ci,ymax=satisfaction+ci),position = pd,size=.5,width=.3)+
  scale_x_discrete(breaks=c("1", "2", "3","4"),
                   labels=c("Majority", "Consensus", "Lottery","Random"))+
  xlab("Treatment")+ylab("Satisfaction") + labs(fill="Income Position")+
  scale_fill_manual(values=cbPalette,labels=c("Net gain", "Net loss"))+
  theme(text=element_text(size=25))+
  scale_y_continuous(breaks = c(0,2,4,6,8,10),
                     labels = c("0","2","4","6","8","10"))+
  coord_cartesian(ylim=c(0,10))+
  ggtitle("100%")
b4
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\sat_split100.png",
       plot=last_plot(),dpi = 300,device = png, width = wi, 
       height = hi,scale=1,
       limitsize = FALSE)

