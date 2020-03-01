library(ggplot2)
library(haven)
prod <- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/180420_gg_mrg2.dta")
fig3a <- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/prod_fig3a.dta")
fig3b <- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/prod_3b.dta")
fig4a <- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/prod_fig4a.dta")
fig4b <- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/prod_4b.dta")
fig6a<- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/prod_fig6a.dta")
fig6b<- read_dta("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten/prod_fig6b.dta")
setwd("C:/Users/Lutz/ownCloud/Sync/FOR2104_Papiere/Heterogeneous Productivity/Daten")

# 3A
ggplot(fig3a, aes(x=var, y=coef)) + 
  geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper), alpha=0.8, width=.06, position=pd2) +
  geom_point(size=3, shape=15, alpha=0.8, position=pd2)+
  #geom_line()+
  xlab("Treatment") +
  ylab("Linear prediction")+
  theme_bw()+
  scale_x_discrete(limits=c("0bn.rat_vote", "50.rat_vote", "100.rat_vote"),
                  breaks=c("0bn.rat_vote", "50.rat_vote", "100.rat_vote"),
                   labels=c("Tax 0%", "Tax indifferent", "Tax 100%"))+
  coord_cartesian(ylim = c(-10,85))+
  ggsave(filename = "fig3a.png",dpi=400,width = 10,height = 10,units = "cm")

# 3B
ggplot(fig3b, aes(x=var, y=coef)) + 
  geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper), alpha=0.8, width=.06, position=pd2) +
  geom_point(size=3, shape=15, alpha=0.8, position=pd2)+
  #geom_line()+
  xlab("Treatment") +
  ylab("Linear prediction")+
  theme_bw()+
  scale_x_discrete(limits=c("1bn.rat_vote_cat", "2.rat_vote_cat", "3.rat_vote_cat"),
                   breaks=c("1bn.rat_vote_cat", "2.rat_vote_cat", "3.rat_vote_cat"),
                   labels=c("Tax 0%", "Tax indifferent", "Tax 100%"))+
  coord_cartesian(ylim = c(-10,85))+
  ggsave(filename = "fig3b.png",dpi=400,width = 10,height = 10,units = "cm")

fig3b


# 4a
ggplot(fig4a, aes(x=var, y=coef)) + 
  geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper), alpha=0.8, width=.06, position=pd2) +
  geom_point(size=3, shape=15, alpha=0.8, position=pd2)+
  #geom_line()+
  xlab("Treatment") +
  ylab("Linear prediction")+
  theme_bw()+
  scale_x_discrete(limits=c("1bn.treat03", "2.treat03", "3.treat03"),
                   breaks=c("1bn.treat03", "2.treat03", "3.treat03"),
                   labels=c("Unequal earned", "Unequal random", "Equal"))+
  coord_cartesian(ylim = c(40,60))+
  ggsave(filename = "fig4a.png",dpi=400,width = 10,height = 10,units = "cm")

# 4b
ggplot(fig4b, aes(x=var, y=coef)) + 
  geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper), alpha=0.8, width=.06, position=pd2) +
  geom_point(size=3, shape=15, alpha=0.8, position=pd2)+
  #geom_line()+
  xlab("Treatment") +
  ylab("Linear prediction")+
  theme_bw()+
  scale_x_discrete(limits=c("1bn.treat03", "2.treat03", "3.treat03"),
                   breaks=c("1bn.treat03", "2.treat03", "3.treat03"),
                   labels=c("Unequal earned", "Unequal random", "Equal"))+
  coord_cartesian(ylim = c(40,60))+
  ggsave(filename = "fig4b.png",dpi=400,width = 10,height = 10,units = "cm")



# 6a
ggplot(fig6a, aes(x=var, y=coef)) + 
  geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper), alpha=0.8, width=.06, position=pd2) +
  geom_point(size=3, shape=15, alpha=0.8, position=pd2)+
  #geom_line()+
  xlab("Treatment") +
  ylab("Linear prediction")+
  theme_bw()+
  coord_cartesian(ylim = c(40,60))+
  scale_x_discrete(limits=c("1bn.treat04", "2.treat04", "3.treat04", "4.treat04"),
                   breaks=c("1bn.treat04", "2.treat04", "3.treat04", "4.treat04"),
                   labels=c("Unequal earned", "Unequal random", "Unequal earned (no info)", "Unequal random (no info)"))+
  ggsave(filename = "fig6a.png",dpi=300,width = 18,height = 15,units = "cm")

# 6b
ggplot(fig6b, aes(x=var, y=coef, group=)) + 
  geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper), alpha=0.8, width=.06, position=pd2) +
  geom_point(size=3, shape=15, alpha=0.8, position=pd2)+
  geom_line()+
  xlab("Treatment") +
  ylab("Linear prediction")+
  theme_bw()+
  coord_cartesian(ylim = c(40,60))+
  scale_x_discrete(limits=c("1bn.treat04", "2.treat04", "3.treat04", "4.treat04"),
                   breaks=c("1bn.treat04", "2.treat04", "3.treat04", "4.treat04"),
                   labels=c("Unequal earned", "Unequal random", "Unequal earned (no info)", "Unequal random (no info)"))+
  ggsave(filename = "fig6b.png",dpi=300,width = 18,height = 15,units = "cm")
