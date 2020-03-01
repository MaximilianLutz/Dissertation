library(haven)
library(gridExtra)
library(ggplot2)
library("cowplot")
osg <- read_dta("/Users/Max/Nextcloud/Sync/DFG_OVERSIGHT_PAPIERE/Method Approach/Daten/20181218_workingdata.dta")
osg$type <- factor(osg$type)
osg$treatment <- factor(osg$treatment)

osg$pc <- osg$pc*10

#SummarySE Function (optional)
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




##Plot1 
#Data Collection
cup1 <- summarySE(subset(osg, payoffmatrix==1), measurevar="pc", groupvars=c("type","treatment", "payoffmatrix"))
cup2 <- summarySE(subset(osg, payoffmatrix==3), measurevar="pc", groupvars=c("type","treatment", "payoffmatrix"))
cup3 <- summarySE(subset(osg, payoffmatrix==2), measurevar="pc", groupvars=c("type","treatment", "payoffmatrix"))
cup4 <- summarySE(subset(osg, payoffmatrix==4), measurevar="pc", groupvars=c("type","treatment", "payoffmatrix"))

neqA <- summarySE(osg, measurevar="neq_dif", groupvars=c("type","treatment", "payoffmatrix"))


#Design issues
pd <- position_dodge(width =.55) 
marker <- 15

#POM1
plot1 <- ggplot(cup1, aes(x=type, y=pc, shape=treatment))+ 
  geom_point(show.legend = FALSE, size=3, position = pd)+
  scale_shape_discrete(breaks=c("1","2","3"),
                       labels=c("Sequential", "Strategy", "Complex information"),
                       name="Treatment")+
  scale_x_discrete(breaks=c("1","2"),
                       labels=c("A", "B"))+
  ylab("Probability of chosing C")+
  ggtitle("Low Cost | Low Fee")+
  xlab("Player type")+
  geom_errorbar(aes(ymin=pc-ci, ymax=pc+ci), width=.15,
                position=pd, show.legend = FALSE, size=1)+
  scale_y_continuous(limits = c(0,100))+
  geom_point(y = 62.5, x = 1, size = 5, shape=13, color = 1)+
  geom_point(y = 80, x = 2, size = 5, shape=13, color = 1)

#POM2
plot2 <- ggplot(subset(cup2), aes(x=type, y=pc, shape=treatment))+ 
  geom_point(show.legend = FALSE, size=3, position = pd)+
  scale_shape_discrete(breaks=c("1","2","3"),
                       labels=c("Sequential", "Strategy", "Complex information"),
                       name="Treatment")+
  #ylab("Probability of chosing C")+
  ggtitle("High Cost | Low Fee")+
  geom_errorbar(aes(ymin=pc-ci, ymax=pc+ci), width=.15,
                position=pd, show.legend = FALSE, size=1)+
  xlab("Player type")+
  scale_y_continuous(limits = c(0,100))+
  geom_point(y = 62.5, x = 1, size = 5, shape=13, color = 1)+
  geom_point(y = 20, x = 2, size = 5, shape=13, color = 1)+
  theme(axis.title.y=element_blank())+
  scale_x_discrete(breaks=c("1","2"),
                   labels=c("A", "B"))
  
#POM3  
plot3 <- ggplot(subset(cup3), aes(x=type, y=pc, shape=treatment))+ 
  geom_point(show.legend = FALSE, size=3, position = pd)+
  scale_shape_discrete(breaks=c("1","2","3"),
                       labels=c("Repeated response", "Strategy method (simple)", "Strategy method (complex information)"),
                       name="Design")+
  ylab("Probability of chosing C")+
  ggtitle("Low Cost | High Fee")+
  geom_errorbar(aes(ymin=pc-ci, ymax=pc+ci),width=.15,
                position=pd, show.legend = FALSE, size=1)+
  scale_y_continuous(limits = c(0,100))+
  geom_point(y = 33.3, x = 1, size = 5, shape=13, color = 1)+
  xlab("Player type")+
  geom_point(y = 80, x = 2, size = 5, shape=13, color = 1)+
  #theme(axis.title.y=element_blank())+
  scale_x_discrete(breaks=c("1","2"),
                   labels=c("A", "B"))
#POM4  (LEGEND)
plot4 <- ggplot(subset(cup4), aes(x=type, y=pc, shape=treatment))+ 
  geom_point(show.legend = TRUE, size=3, position = pd)+
  scale_shape_discrete(breaks=c("1","2","3"),
                       labels=c("Repeated response", "Strategy method (simple)", "Strategy method (complex information)"),
                       name="Design:")+
  theme(legend.position=c("right"))


legend=get_legend(plot4)

#POM4  
plot4 <-ggplot(cup4, aes(x=type, y=pc, shape=treatment))+ 
  geom_point(show.legend = FALSE, size=3, position = pd)+
  scale_shape_discrete(breaks=c("1","2","3"),
                       labels=c("Sequential", "Strategy", "Complex information"),
                       name="Treatment")+
  ggtitle("High Cost | High Fee")+
  xlab("Player type")+
  geom_errorbar(aes(ymin=pc-ci, ymax=pc+ci), alpha=1, width=.15,
                position=pd, show.legend = FALSE, size=1)+
  scale_y_continuous(limits = c(0,100))+
  geom_point(y = 33.3, x = 1, size = 5, shape=13, color = 1)+
  geom_point(y = 20, x = 2, size = 5, shape=13, color = 1)+
  theme(axis.title.y=element_blank())+
  scale_x_discrete(breaks=c("1","2"),
                   labels=c("A", "B"))


p <- plot_grid( plot1,plot2,plot3,plot4, legend, ncol = 2, rel_heights = c(1, 1,.4))
p


ggsave("/Users/Max/Dropbox/Apps/Overleaf/Repeated Response versus Strategy Method Experimental Evidence from an Oversight Game/img/rplot01.png",
       plot=p, dpi=600,
       device = "png", width = 25, height = 23,units = c("cm"))



osg <- read_dta("/Users/Max/Nextcloud/Sync/DFG_OVERSIGHT_PAPIERE/Method Approach/Daten/2019seq.dta")
osg$type <- factor(osg$type)
osg$treatment <- factor(osg$treatment)

##Plot 2

#Data collection 
learn1 <- summarySE(subset(osg, c==2 & f == 8) , measurevar="choice", groupvars=c("rep","type"))
learn2 <- summarySE(subset(osg, c==8 & f == 8) , measurevar="choice", groupvars=c("rep","type"))
learn3 <- summarySE(subset(osg, c==2 & f == 15) , measurevar="choice", groupvars=c("rep","type"))
learn4 <- summarySE(subset(osg, c==8 & f == 15) , measurevar="choice", groupvars=c("rep","type"))



# Graphs to illustrate learning 

p1 <- ggplot(learn1, aes(x=rep, y=choice,  colour=type))+
  geom_line(linetype=2,lwd=1)+
  coord_cartesian(ylim = c(0.2, 1))+
  geom_line(y=0.79, color = "red")+
  geom_line(y=0.66, color = "sky blue")+
  xlab("") +
  theme_bw()+
  ylab("")+
  ggtitle("Low Cost | Low Fee")+
  theme(legend.position="none")+
  scale_x_continuous(breaks = round(seq(min(0), max(10), by = 2),1))

p2 <- ggplot(learn2, aes(x=rep, y=choice,  colour=type))+
  geom_line(linetype=2,lwd=1)+
  coord_cartesian(ylim = c(0.2, 1))+
  geom_line(y=0.73, color = "red")+
  geom_line(y=0.82, color = "sky blue")+
  xlab("") +
  theme_bw()+
  ylab("")+
  ggtitle("High Cost | Low Fee")+
  theme(legend.position="none")+
  scale_x_continuous(breaks = round(seq(min(0), max(10), by = 2),1))

p3 <- ggplot(learn3, aes(x=rep, y=choice,  colour=type))+
  geom_line(linetype=2,lwd=1)+
  coord_cartesian(ylim = c(0.2, 1))+
  geom_line(y=0.59, color = "red")+
  geom_line(y=0.57, color = "sky blue")+
  xlab("") +
  theme_bw()+
  ylab("")+
  ggtitle("Low Cost | High Fee")+
  theme(legend.position="none")+
  scale_x_continuous(breaks = round(seq(min(0), max(10), by = 2),1))

p4 <- ggplot(learn4, aes(x=rep, y=choice,  color=type))+
  geom_line(linetype=2,lwd=1)+
  geom_line(y=0.41, color = "red")+
  geom_line(y=0.68, color = "sky blue")+
  scale_x_continuous(breaks = round(seq(min(0), max(10), by = 2),1))+
  scale_color_discrete(breaks=c(1, 2),
                       labels=c("Type A", "Type B"),
                       name="")+theme(legend.position = "bottom")


legend <- get_legend(p4)
p4 <- ggplot(learn4, aes(x=rep, y=choice,  colour=type))+
  geom_line(linetype=2,lwd=1)+
  coord_cartesian(ylim = c(0.2, 1))+
  geom_line(y=0.41, color = "red",lwd=1)+
  geom_line(y=0.68, color = "sky blue",lwd=1)+
  xlab("") +
  theme_bw()+
  ylab("")+
  ggtitle("High Cost | High Fee")+
  theme(legend.position="none")+
  scale_x_continuous(breaks = round(seq(min(0), max(10), by = 2),1))


p <- plot_grid( p1,p2,p3,p4, legend, ncol = 2,nrow=3, rel_heights = c(3,3,1))
p


ggsave("/Users/Max/Nextcloud/Sync/DFG_OVERSIGHT_PAPIERE/Method Approach/Daten/rplot02.png",
       plot=p, dpi=600,
       device = "png", width = 25, height = 20,units = c("cm"))


