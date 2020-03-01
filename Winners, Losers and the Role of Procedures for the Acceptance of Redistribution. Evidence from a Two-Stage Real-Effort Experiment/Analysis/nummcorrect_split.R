library(haven)
library(effec)
library(tidyverse)
library(readr)
library(ggplot2)
prod3 <- read_dta("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Daten\\vm_ggplot4.dta")

prod3$treatment <- factor(prod3$treatment)
prod3$netpay_cat <- factor(prod3$netpay_cat)
prod3$Stage <- factor(prod3$Stage)

pd2<-position_dodge(1)
wi<-800
hi<-225


# The palette with black:
cbPalette <- c("#a0a0a0", "#06c5fc", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


# 0%
df <- summarySE(data=subset(prod3, groupdecision==0), measurevar = "correct", groupvars = c("treatment", "Stage" ))
levels(df$treatment) <- c("Majority", "Consenus", "Lottery", "Random")
c0 <- ggplot(data=df, aes(x=FALSE,y=correct, fill=Stage)) + 
  geom_col(position =pd2 )+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Treatment") +
  ylab("Correctly solved tasks")+
  scale_fill_manual(values=cbPalette)+  theme_bw()+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("1","2","3","4"),
                   labels=c("Majority","Consensus","Lottery","Random"))+
  theme_bw()+
  theme(text = element_text(size=15))+
  ggtitle("0% Taxation")+
  facet_grid(.~treatment,labeller = label_value)
c0

ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\corr_split0.png",
       plot=last_plot(),dpi = 300,device = png, width = 400, 
       height = 300,scale=1,
       limitsize = FALSE)
#30%
df <- summarySE(data=subset(prod3, groupdecision==30), measurevar = "correct", groupvars = c("treatment", "Stage", "netpay_cat"))

c1 <- ggplot(data=subset(df, treatment==1), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position =pd2 )+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Majority") +
  ylab("Correctly solved tasks")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme_bw()+
  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))
c1

c2 <- ggplot(data=subset(df, treatment==2), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Consensus") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  theme(legend.position="none")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c2

c3 <- ggplot(data=subset(df, treatment==3), aes(x=netpay_cat, y=correct, fill=Stage)) +  
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Lottery") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c3
df
c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  coord_cartesian(ylim = c(20, 50))+
  labs(fill="Stage")+  scale_x_discrete(breaks=c("0","1"),
                                        labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())+
  scale_fill_manual(values=cbPalette)

legend <- get_legend(c4)

c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab(" ")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))

arr<-grid.arrange(c1,c2,c3,c4, legend, ncol=5, nrow=1, heights=c(10),widths=c(12,12,12,12,5),top="30%")
arr


ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\corr_split30.png",
       plot=arr,dpi = 300,device = png, width = wi, 
       height = hi,scale=1,
       limitsize = FALSE)



#70%
df <- summarySE(data=subset(prod3, groupdecision==70), measurevar = "correct", groupvars = c("treatment", "Stage", "netpay_cat"))

c1 <- ggplot(data=subset(df, treatment==1), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position =pd2 )+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Majority") +
  ylab("Correctly solved tasks")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme_bw()+
  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))
c1

c2 <- ggplot(data=subset(df, treatment==2), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Consensus") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  theme(legend.position="none")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c2

c3 <- ggplot(data=subset(df, treatment==3), aes(x=netpay_cat, y=correct, fill=Stage)) +  
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Lottery") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c3
df
c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  coord_cartesian(ylim = c(20, 50))+
  labs(fill="Stage")+  scale_x_discrete(breaks=c("0","1"),
                                        labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())+
  scale_fill_manual(values=cbPalette)

legend <- get_legend(c4)

c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab(" ")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))

arr<-grid.arrange(c1,c2,c3,c4, legend, ncol=5, nrow=1, heights=c(10),widths=c(12,12,12,12,5),top="70%")
arr


ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\corr_split70.png",
       plot=arr,dpi = 300,device = png, width = wi, 
       height = hi,scale=1,
       limitsize = FALSE)


#100%
df <- summarySE(data=subset(prod3, groupdecision==100), measurevar = "correct", groupvars = c("treatment", "Stage", "netpay_cat"))
c1 <- ggplot(data=subset(df, treatment==1), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position =pd2 )+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Majority") +
  ylab("Correctly solved tasks")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme_bw()+
  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))
c1

c2 <- ggplot(data=subset(df, treatment==2), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Consensus") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  theme(legend.position="none")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c2

c3 <- ggplot(data=subset(df, treatment==3), aes(x=netpay_cat, y=correct, fill=Stage)) +  
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Lottery") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c3
df
c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  coord_cartesian(ylim = c(20, 50))+
  labs(fill="Stage")+  scale_x_discrete(breaks=c("0","1"),
                                        labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())+
  scale_fill_manual(values=cbPalette)

legend <- get_legend(c4)

c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab(" ")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+
  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))
c4
arr<-grid.arrange(c1,c2,c3,c4, legend, ncol=5, nrow=1, heights=c(10),widths=c(12,12,12,12,5),top="100%")
arr

library(gridExtra)
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\corr_split100.png",
       plot=arr,dpi = 300,device = png, width = wi,
       height = hi,scale=1,
       limitsize = FALSE)





# 0%
df <- summarySE(data=subset(prod3, groupdecision!=0), measurevar = "correct", groupvars = c("treatment", "Stage", "netpay_cat"))
c1 <- ggplot(data=subset(df, treatment==1), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position =pd2 )+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Majority") +
  ylab("Correctly solved tasks")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme_bw()+
  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))
c1

c2 <- ggplot(data=subset(df, treatment==2), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Consensus") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  theme(legend.position="none")+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c2

c3 <- ggplot(data=subset(df, treatment==3), aes(x=netpay_cat, y=correct, fill=Stage)) +  
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Lottery") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())
c3

c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab("Correctly solved tasks")+
  theme_bw()+
  coord_cartesian(ylim = c(20, 50))+
  labs(fill="Stage")+  scale_x_discrete(breaks=c("0","1"),
                                        labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15),
        axis.title.y=element_blank())+
  scale_fill_manual(values=cbPalette)

legend <- get_legend(c4)

c4 <- ggplot(data=subset(df, treatment==4), aes(x=netpay_cat, y=correct, fill=Stage)) + 
  geom_col(position = pd2)+
  geom_errorbar(aes(ymin=correct-ci, ymax=correct+ci), width=.3, position=pd2, size=.5) +
  xlab("Random") +
  ylab(" ")+
  theme_bw()+
  scale_fill_manual(values=cbPalette, guide=FALSE)+  theme(legend.position="none")+
  coord_cartesian(ylim = c(20, 50))+
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Net gain","Net loss"))+
  theme_bw()+
  theme(text = element_text(size=15))
c4
arr<-grid.arrange(c1,c2,c3,c4, legend, ncol=5, nrow=1, heights=c(10),widths=c(12,12,12,12,5))
arr
ggsave("C:\\Users\\Lutz\\ownCloud\\Sync\\FOR2104_Papiere\\Voting Mechanism\\Präsentation\\img\\corr_split.png",
       plot=arr,dpi = 300,device = png, width = wi,
       height = 450,scale=1,
       limitsize = FALSE)
