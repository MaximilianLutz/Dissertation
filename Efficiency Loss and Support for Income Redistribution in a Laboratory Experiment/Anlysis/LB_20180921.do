*set more off 
*cd "C:\Users\Tepe\Dropbox\Leaky Bucket"
*use "20161111_lb_arbeitsdatei.dta", clear

*set more off 
*cd "C:\Users\Tepe\Dropbox\Leaky Bucket"
*use "20161111_lb_arbeitsdatei.dta", clear


set more off 
cd "C:\Users\Paetzel\Dropbox\Leaky Bucket"
use "20161111_lb_arbeitsdatei.dta", clear





*** stylized plot: C:\Users\Tepe\ownCloud\ESS_2008

**********************************************************************
* Auswertung und Vergleich Meltzer-Richard mit und ohne Leaky Bucket *
**********************************************************************

gen lb_d = 0 
replace lb_d =1 if lb > 0
drop if frame == 2
gen wave = 0 
replace wave = 1 if session < 15
replace wave = 2 if session > 14

***************************************
*** Coding social preference types ****
**************************************

label var geschlecht "Female"
label var alter "Age"


gen id = 0 
replace id = (session*100)+subject

* Classification of the four social-preference-types 
* EFF: efficiency loving
* IAV: inequality avers
* SPI: Spiteful
* ILO: inequality loving
* inconsistent decisions are automatically dropped out 

gen benevo_disad = 0
gen malevo_disad = 0
gen benevo_ad = 0
gen malevo_ad = 0

* 21.09.2018
* Strikte EEF und IAV
* SPI und ILO raus, da diese Präf nicht vorhanden.
replace benevo_disad = 1 if (lorr_1==1) & (lorr_2==1) & (lorr_3==1) & (lorr_4==1) & (lorr_5==1)
replace malevo_disad = 1 if (lorr_1==2) & (lorr_2==2) & (lorr_3==2) & (lorr_4==2) & (lorr_5==2)
replace benevo_ad = 1 if (lorr_6==2) & (lorr_7==2) & (lorr_8==2) & (lorr_9==2) & (lorr_10==2)
gen EFF = 0
gen IAV = 0
replace EFF = 1 if (benevo_disad==1) & (benevo_ad==1)
replace IAV = 1 if (malevo_disad==1) & (benevo_ad==1)

* 21.09.2018
* dummy for being egoistic, meaning always voting for the highest possible payoff
* and being indifferent in a situation when both options yields to the same own payoff and some payoff for the other player.
gen egoistic = 0
replace egoistic = 1 if (lorr_1==2) & (lorr_2==2) & (lorr_4==1) & (lorr_5==1) & (lorr_6==2) & (lorr_7==2) & (lorr_9==1) & (lorr_10==1)

* 21.09.2018
* wtp_a und wtp_d machen mehr Sinn 
* willingness to pay for efficiency
gen wtp_d = 0
*willingness to pay for equality
gen wtp_a = 0

*EXAMPLE:
*given the parameters from both blocks the wtp can be calculated (compare Balafoutas et at. 2013) by the share of what a person 
*abstains from divided by the amount what she allows for the passive person (see the following example). 
*wtp for the first row in disadvan. block: a person abstains from 0.40 euros and allow the passive person 0.60 euros: 
*the proxy for wtp_d is in this example: 0.40/0.60=2/3=0.66666
*it follows: 0.40/0.60=0.66666
replace wtp_d = 0.66667 if (lorr_1==1) & (lorr_2==1) & (lorr_3==1) & (lorr_4==1) & (lorr_5==1)
*0.20/0.60=0.33333, wtp is between 0.33333 and 0.66667: proxy=0.5
replace wtp_d = 0.5 if (lorr_1==2) & (lorr_2==1) & (lorr_3==1) & (lorr_4==1) & (lorr_5==1)
*wtp is between 0 and 0.33333: proxy: 0.16667
replace wtp_d = 0.16667 if (lorr_1==2) & (lorr_2==2) & (lorr_3==1) & (lorr_4==1) & (lorr_5==1)
*wtp is between -0.33333 and 0: proxy: -0.16667
replace wtp_d = -0.1667 if (lorr_1==2) & (lorr_2==2) & (lorr_3==2) & (lorr_4==1) & (lorr_5==1)
*wtp is between -0.33333 and -0.66666: proxy: -0.5
replace wtp_d = -0.5 if (lorr_1==2) & (lorr_2==2) & (lorr_3==2) & (lorr_4==2) & (lorr_5==1)
*wtp if someone never choose left
replace wtp_d = -0.66667 if (lorr_1==2) & (lorr_2==2) & (lorr_3==2) & (lorr_4==2) & (lorr_5==2)
* and accordingly for the advantageous block
replace wtp_a = -0.66667 if (lorr_6==1) & (lorr_7==1) & (lorr_8==1) & (lorr_9==1) & (lorr_10==1)
replace wtp_a = -0.5 if (lorr_6==2) & (lorr_7==1) & (lorr_8==1) & (lorr_9==1) & (lorr_10==1)
replace wtp_a = -0.16667 if (lorr_6==2) & (lorr_7==2) & (lorr_8==1) & (lorr_9==1) & (lorr_10==1)
replace wtp_a = 0.16667 if (lorr_6==2) & (lorr_7==2) & (lorr_8==2) & (lorr_9==1) & (lorr_10==1)
replace wtp_a = 0.5 if (lorr_6==2) & (lorr_7==2) & (lorr_8==2) & (lorr_9==2) & (lorr_10==1)
replace wtp_a = 0.66667 if (lorr_6==2) & (lorr_7==2) & (lorr_8==2) & (lorr_9==2) & (lorr_10==2)

*****************************
*** Coding of indep. var ****
*****************************

gen decision100 = decision/100

ttest taxrate, by (lb_d)

* Welfare state attitudes

factor fam arb krank alt pflege, pcf
alpha  fam arb krank alt pflege

recode fam    1=5 2=4 3=3 4=2 5=1, gen(fam1)
recode arb    1=5 2=4 3=3 4=2 5=1, gen(arb1)
recode krank  1=5 2=4 3=3 4=2 5=1, gen(krank1)
recode alt    1=5 2=4 3=3 4=2 5=1, gen(alt1)
recode pflege 1=5 2=4 3=3 4=2 5=1, gen(pflege1)

gen pro_state = ((fam1 + arb1 + krank1 + alt1 + pflege1)-10)/15 
su pro_state
label var pro_state "Pro Welfare State"

* Political LR Self-Placemanent

*recode pol_selbstein 0=10 1=9 2=8 3=7 4=6 5=5 6=4 7=3 8=2 9=1 10=0, gen(LR)
*gen leftright = (LR-2) / 8

recode pol_selbstein 0=1 1=.9 2=.8 3=.7 4=.6 5=.5 6=.44 7=.33 8=.2 9=.1 10=0, gen(leftright)

su leftright
label var leftright "Right Left (RL)"


*** Treatment (Dummy & Cat.)

tab lb, gen (lb_) 

label var lb_d "Leak Dummy"
label var lb_2 "Leak (5 perc.)"
label var lb_3 "Leak (20 perc.)"
label var lb_4 "Leak (60 perc.)"

gen leak_cat = 1
replace leak_cat = 2 if lb_2==1
replace leak_cat = 3 if lb_3==1
replace leak_cat = 4 if lb_4==1
label  define leak_catlb 1 "0.00" 2 "0.05" 3 "0.20" 4 "0.60"
label  values leak_cat leak_catlb



**********************************************************************
* Auswertung und Vergleich Meltzer-Richard mit und ohne Leaky Bucket *
**********************************************************************

gen ideal100 = ideal/100


*********************
*** Ideal tax     ***
*********************

tab wave, gen(pool)
labe var pool1 "Subject pool"

*********************
*29.5.2017

*theoretical predictions as a function of the leak-size

capture drop ego_pred

gen ego_pred =50 

replace ego_pred = 0   if bruttoincome>1700      & lb_1==1 
replace ego_pred = 0   if bruttoincome>1700*0.95 & lb_2==1 
replace ego_pred = 0   if bruttoincome>1700*0.8  & lb_3==1 
replace ego_pred = 0   if bruttoincome>1700*0.4  & lb_4==1 

replace ego_pred = 100 if bruttoincome<1700      & lb_1==1 
replace ego_pred = 100 if bruttoincome<1700*0.95 & lb_2==1 
replace ego_pred = 100 if bruttoincome<1700*0.8  & lb_3==1 
replace ego_pred = 100 if bruttoincome<1700*0.4  & lb_4==1 


capture drop pred_r
gen pred_r=0
replace pred_r=1 if bruttoincome>1700 & lb_1==1  
replace pred_r=1 if bruttoincome>1700*0.95 & lb_2==1
replace pred_r=1 if bruttoincome>1700*0.8 & lb_3==1
replace pred_r=1 if bruttoincome>1700*0.4 & lb_4==1
label var pred_r "Rational 0" 

capture drop pred_p
gen pred_p=0
replace pred_p=1 if bruttoincome<1700 & lb_1==1
replace pred_p=1 if bruttoincome<1700*0.95 & lb_2==1
replace pred_p=1 if bruttoincome<1700*0.8 & lb_3==1
replace pred_p=1 if bruttoincome<1700*0.4 & lb_4==1
label var pred_p "Rational 100"

capture drop pred_i
gen pred_i=0
replace pred_i=1 if bruttoincome==1700 & lb_1==1
replace pred_i=1 if bruttoincome==1700*0.95 & lb_2==1
replace pred_i=1 if bruttoincome==1700*0.8 & lb_3==1
replace pred_i=1 if bruttoincome==1700*0.4 & lb_4==1
label var pred_i "Rational indiff"

gen pred_cat = . 
replace pred_cat = 1 if pred_p==1
replace pred_cat = 2 if pred_i==1
replace pred_cat = 3 if pred_r==1
label  define pred_catlb 1 "t=100" 2 "indiff." 3 "t=0" 
label  values pred_cat pred_catlb


*** pre tax inc metrisch (differenz zum rationalen wahl)

gen ginc_d=.
replace ginc_d=  bruttoincome-1700       if lb_1==1  
replace ginc_d=  bruttoincome-1700*0.95  if lb_2==1
replace ginc_d=  bruttoincome-1700*0.8   if lb_3==1
replace ginc_d=  bruttoincome-1700*0.4   if lb_4==1

*** log pre tax inc metrisch (differenz zum rationalen wahl)

gen ginc_ln=.
replace ginc_ln=  ln(bruttoincome/(1700      )) if lb_1==1  
replace ginc_ln=  ln(bruttoincome/(1700*0.95 )) if lb_2==1
replace ginc_ln=  ln(bruttoincome/(1700*0.8  )) if lb_3==1
replace ginc_ln=  ln(bruttoincome/(1700*0.4  )) if lb_4==1



*** Control vars

tab study, gen (study)

label var study1 "Natural sciences" 
label var study4 "Social sciences"
label var study2 "Business sciences"
label var study5 "Other"


**************************************
**** New Models Markus 26.07.2017 ****
**************************************


xtset id period
fvset base 0 lb_d


*** set datasetz to 2600 obs

xtreg ideal100 lb_d                leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust       
predict x
drop if x==.
drop x


*** FINAL ***

***************************************
***************************************
***************************************



************************
* IDEAL (Tab3.) *
************************

* H1
xtreg ideal100 lb_d                leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m1

xtreg ideal100      lb_2 lb_3 lb_4 leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust
estimates store m2

* H2
xtreg ideal100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1  , re robust  
estimates store m3

xtreg ideal100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1 if pred_p==1   , re robust  
estimates store m4

* H3
xtreg ideal100 i.lb_d##c.leftright                               pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m5

esttab m1 m2 m3 m4 m5 using tab_ideal.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label


*******************
*** R2 comments ***
*******************

fvset base 2 pred_cat
fvset base 1 leak_cat



******************
*** 02.08.2018 ***
******************



******************
**** fracreg  ****
******************

*** Rational 0 vs. 100

fracreg logit ideal100  i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.pred_cat,  level(95) saving(file1, replace)
marginsplot, title(Ideal) 
*gr save fig1a.gph, replace

fracreg logit  decision100  i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.pred_cat,  level(95) saving(file2, replace)
marginsplot, title(Final) 
*gr save fig1b.gph, replace

combomarginsplot file1 file2, labels("Ideal" "Final") title("Ego. categorial")
gr save fig1a.gph, replace

*graph combine fig1a.gph fig1b.gph, row(1) ycommon
*gr save fig1.gph, replace


*** Rational continous measure (neg. values = hi tax prefered , pos. values = low tax prefered)

*fracreg logit ideal100  c.ginc_d i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
*margins, at(ginc_d==(-1600(500)5220))
*marginsplot, xline(0)
*gr save fig3a.gph, replace

*fracreg logit decision100  c.ginc_d i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
*margins, at(ginc_d==(-1600(500)5220))
*marginsplot, xline(0)
*gr save fig3b.gph, replace

*graph combine fig3a.gph fig3b.gph, row(1) ycommon
*gr save fig3.gph, replace


*** Rational continous measure LOG

fracreg logit ideal100  c.ginc_ln i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins, at(ginc_ln==(-2.8(.5)2.2)) saving(file1, replace)
marginsplot, xline(0)
*gr save fig2a.gph, replace

fracreg logit decision100  c.ginc_ln i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins, at(ginc_ln==(-2.8(.5)2.2)) saving(file2, replace)
marginsplot, xline(0)
*gr save fig2b.gph, replace

combomarginsplot file1 file2, labels("Ideal" "Final") xline(0) title("Ego. continuous")
gr save fig1b.gph, replace

graph combine fig1a.gph fig1b.gph, row(1) ycommon
gr save fig1.gph, replace


*** Leak

fracreg logit  ideal100  c.ginc_ln i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat,  level(95)  saving(file1, replace)
marginsplot, title(Ideal)
*gr save fig3a.gph, replace

fracreg logit  decision100  c.ginc_ln i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat,  level(95)  saving(file2, replace)
marginsplot, title(Final)
*gr save fig3b.gph, replace

combomarginsplot file1 file2, labels("Ideal" "Final") title("Efficiency loss")
gr save fig2.gph, replace

*graph combine fig1a.gph fig1b.gph, row(1) ycommon
*gr save fig1.gph, replace


*** Partisan 

fracreg logit ideal100  c.ginc_ln c.leftright i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins, at(leftright==(.1(.1)1)) saving(file1, replace)
marginsplot
*gr save fig9a.gph, replace

fracreg logit decision100  c.ginc_ln c.leftright i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins, at(leftright==(.1(.1)1)) saving(file2, replace)
marginsplot
*gr save fig9b.gph, replace

combomarginsplot file1 file2, labels("Ideal" "Final") title("Parisan orientation")
gr save fig3.gph, replace

graph combine fig2.gph fig1.gph fig3.gph, row(3) ycommon xsize(2) ysize(4)
gr save fig_main_effects.gph, replace


************************************************
*** Interaction effect (pred_cat x leak size)
************************************************

fracreg logit ideal100     i.pred_cat##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.pred_cat#i.leak_cat
marginsplot, title(Ideal)
gr save fig4a.gph, replace

fracreg logit decision100  i.pred_cat##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.pred_cat#i.leak_cat 
marginsplot, title(Final)
gr save fig4b.gph, replace

graph combine fig4a.gph fig4b.gph, row(1) ycommon
gr save fig4.gph, replace


*** Interaction effect (inc x leak size)

*fracreg logit ideal100  c.ginc_d##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
*margins i.leak_cat, at(c.ginc_d = (-1600(500)5220))
*marginsplot, xline(0) title(treat)
*gr save fig4a.gph, replace

*fracreg logit decision100  c.ginc_d##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
*margins i.leak_cat, at(c.ginc_d = (-1600(500)5220))
*marginsplot, xline(0) title(treat)
*gr save fig4b.gph, replace

*graph combine fig4a.gph fig4b.gph, row(1) ycommon
*gr save fig4.gph, replace


*** Interaction effect (inc x leak size) LOG

fracreg logit ideal100  c.ginc_ln##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.ginc_ln = (-2.8(.5)2.2))
marginsplot, xline(0) title(Ideal)
gr save fig5a.gph, replace

fracreg logit decision100  c.ginc_ln##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.ginc_ln = (-2.8(.5)2.2))
marginsplot, xline(0) title(Final)
gr save fig5b.gph, replace

graph combine fig5a.gph fig5b.gph, row(1) ycommon
gr save fig5.gph, replace


*** Interaction effect (partisan x leak size)

fracreg logit ideal100  c.ginc_ln c.leftright##i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.leftright = (.1(0.1)1))
marginsplot, title(Ideal)
gr save fig6a.gph, replace

fracreg logit decision100  c.ginc_ln c.leftright##i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.leftright = (.1(0.1)1))
marginsplot,  title(Final)
gr save fig6b.gph, replace

graph combine fig6a.gph fig6b.gph, row(1) ycommon
gr save fig6.gph, replace



***

graph combine fig4.gph fig5.gph fig6.gph , col(1) xsize(2) ysize(4)
gr save fig_IA_effects.gph, replace

****************************
*** Interction with EFF ****
****************************

fracreg logit ideal100     i.EFF##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.EFF#i.leak_cat
marginsplot, title(Ideal)
gr save fig4a.gph, replace

fracreg logit decision100  i.EFF##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.EFF#i.leak_cat 
marginsplot, title(Final)
gr save fig4b.gph, replace

graph combine fig4a.gph fig4b.gph, row(1) ycommon
gr save fig4.gph, replace


******************************
*** Interction with wtp_d ****
******************************

fracreg logit ideal100  c.wtp_d##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.wtp_d = (-.66(.25).66))
marginsplot,  title(Ideal)
gr save fig5a.gph, replace

fracreg logit decision100  c.wtp_d##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.wtp_d = (-.66(.25).66))
marginsplot, title(Final)
gr save fig5b.gph, replace

graph combine fig5a.gph fig5b.gph, row(1) ycommon
gr save fig5.gph, replace

******************************
*** Interction with wtp_a ****
******************************

fracreg logit ideal100  c.wtp_a##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.wtp_a = (-.66(.25).66))
marginsplot,  title(Ideal)
gr save fig5a.gph, replace

fracreg logit decision100  c.wtp_a##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
margins i.leak_cat, at(c.wtp_a = (-.66(.25).66))
marginsplot, title(Final)
gr save fig5b.gph, replace

graph combine fig5a.gph fig5b.gph, row(1) ycommon
gr save fig5.gph, replace






**** Finale Tabele 3 and 4 ***

**** Reg Tabs. 

fracreg logit ideal100     i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m1
fracreg logit decision100  i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m2

fracreg logit ideal100     c.ginc_ln i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1   , vce(cluster id)
est store m3
fracreg logit decision100  c.ginc_ln i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1   , vce(cluster id)
est store m4

fracreg logit ideal100     c.ginc_ln##i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m5
fracreg logit decision100  c.ginc_ln##i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m6

* Ideal
esttab m1 m3 m5  using tab_ideal.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalar(ll) pr2 aic bic compress nogaps replace label  nobaselevels  
* Final
esttab m2 m4 m6  using tab_final.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalar(ll) pr2 aic bic compress nogaps replace label  nobaselevels 




*** Rob. Analysis with Effi-Types


fracreg logit ideal100     i.pred_cat         i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1   SPI IAV ILO EFF, vce(cluster id)
est store m1
fracreg logit ideal100     i.pred_cat  i.EFF##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1   SPI IAV ILO    , vce(cluster id)
est store m2
fracreg logit decision100  i.pred_cat         i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  SPI IAV ILO EFF, vce(cluster id)
est store m3
fracreg logit decision100  i.pred_cat  i.EFF##i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  SPI IAV ILO    , vce(cluster id)
est store m4
esttab m1 m2 m3 m4 using tab_rob.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalar(ll) pr2 aic bic compress nogaps replace label  nobaselevels  


*****************************
*** Alterntive Estimators ***
*****************************


*** alt estimator betareg

gen ideal_beta = ideal100
gen decision_beta = decision100

replace ideal_beta =0.000001 if ideal100==0
replace ideal_beta =0.999999 if ideal100==1

replace decision_beta =0.000001 if decision100==0
replace decision_beta =0.999999 if decision100==1


betareg ideal_beta     i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m1
betareg decision_beta  i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m2

betareg  ideal_beta     c.ginc_ln i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1   , vce(cluster id)
est store m3
betareg  decision_beta  c.ginc_ln i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1   , vce(cluster id)
est store m4

betareg  ideal_beta     c.ginc_ln##i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m5
betareg  decision_beta  c.ginc_ln##i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m6

betareg  ideal_beta     c.ginc_ln c.leftright##i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m7
betareg  decision_beta  c.ginc_ln c.leftright##i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , vce(cluster id)
est store m8

* Ideal
esttab m1 m3 m5 m7 using tab_ideal_beta.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label
* Final
esttab m2 m4 m6 m7 using tab_final_beta.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label





*** alt esstimator xtreg

xtreg  ideal100     i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , re robust 
est store m1
xtreg  decision100  i.pred_cat i.leak_cat leftright geschlecht alter study1 study4 study2  study5 pool1  , re robust 
est store m2

xtreg  ideal100     c.ginc_ln i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1   , re robust 
est store m3
xtreg  decision100  c.ginc_ln i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1   , re robust 
est store m4

xtreg  ideal100     c.ginc_ln##i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1  , re robust 
est store m5
xtreg  decision100  c.ginc_ln##i.leak_cat  leftright geschlecht alter study1 study4 study2  study5 pool1  , re robust 
est store m6

xtreg  ideal100     c.ginc_ln c.leftright##i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , re robust 
est store m7
xtreg  decision100  c.ginc_ln c.leftright##i.leak_cat geschlecht alter study1 study4 study2  study5 pool1  , re robust 
est store m8

* Ideal
esttab m1 m3 m5 m7 using tab_idealr.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label
* Final
esttab m2 m4 m6 m7 using tab_finalr.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label






******************************
*** OLD STUFF ****************
******************************







***************************
* DECISION (Tab4) *
***************************


* H1
xtreg decision100 lb_d                leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1               , re robust       
estimates store m1

xtreg decision100      lb_2 lb_3 lb_4 leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust
estimates store m2

* H2
xtreg decision100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1 if pred_r==1   , re robust  
estimates store m3

xtreg decision100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1 if pred_p==1   , re robust  
estimates store m4

* H3
xtreg decision100 i.lb_d##c.leftright                               pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m5

esttab m1 m2 m3 m4 m5 using tab_final.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label


*** Test r2 median voter

xtreg ideal100     pred_r pred_p                 , re robust       
xtreg decision100  pred_r pred_p                 , re robust       


******************
*** Robustness ***
******************

*** Robust 

xtreg ideal100      lb_2  leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5  pool1          if lb_3==0 & lb_4==0     , re robust
estimates store m1

xtreg ideal100      lb_3  leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5  pool1          if lb_2==0 & lb_4==0     , re robust
estimates store m2

xtreg ideal100      lb_4  leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5  pool1          if lb_2==0 & lb_3==0     , re robust
estimates store m3

xtreg decision100   lb_2  leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5  pool1          if lb_3==0 & lb_4==0     , re robust
estimates store m1b

xtreg decision100   lb_3  leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5  pool1          if lb_2==0 & lb_4==0     , re robust
estimates store m2b

xtreg decision100   lb_4  leftright                      pred_r pred_p geschlecht alter study1 study4 study2 study5  pool1          if lb_2==0 & lb_3==0     , re robust
estimates store m3b

esttab  m1 m2 m3 m1b m2b m3b using tab_rob.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label




***********************
*** Appendix Figure ***
***********************

histogram ideal100 if pred_r==1, percent normal title(Rich)
graph save fig1.gph, replace

histogram ideal100 if pred_p==1, percent normal title(Poor)
graph save fig2.gph, replace

graph combine fig1.gph fig2.gph, title(Ideal)  row(1) xcommon ycommon 
graph save figA.gph, replace

***

histogram decision100 if pred_r==1, percent normal title(Rich)
graph save fig1.gph, replace

histogram decision100 if pred_p==1, percent normal title(Poor)
graph save fig2.gph, replace

graph combine fig1.gph fig2.gph, title(Final)  row(1) xcommon ycommon 
graph save figB.gph, replace

***

graph combine figA.gph figB.gph, col(1)  
graph save figC.gph, replace






***************************
*** Interaction Model 5 ***
***************************

fvset base 0 lb_d

xtreg ideal100    i.lb_d##c.leftright              pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust       
margins lb_d, at(leftright=(0(.1)1)) level(90)  post
*set scheme s1color
marginsplot
graph save ideal_ia.gph, replace


xtreg decision100 i.lb_d##c.leftright               pred_r pred_p geschlecht alter study1 study4 study2 study5 pool1                , re robust       
margins lb_d, at(leftright=(0(.1)1)) level(90)  post
*set scheme s1color
marginsplot
graph save decision_ia.gph, replace

graph combine ideal_ia.gph decision_ia.gph, ycommon col(1) xsize(2) ysize(3)




***********************************
*** Likelihood of Rational Vote ***
***********************************

gen rat_i01 = 0
replace rat_i01= 1 if ego_pred==100 & ideal100==1
replace rat_i01= 1 if ego_pred==0   & ideal100==0
replace rat_i01= 1 if ego_pred==50  & ideal100==.5

gen rat_d01 = 0
replace rat_d01= 1 if ego_pred==100 & decision100==1
replace rat_d01= 1 if ego_pred==0   & decision100==0
replace rat_d01= 1 if ego_pred==50  & decision100==.5

tab rat_i01
tab rat_d01


***

* Ideal

xtlogit rat_i01  pred_p lb_d leftright               geschlecht alter study1 study4 study2 study5 pool1  if             ego_pred!=50   , re
estimates store m1
xtlogit rat_i01  pred_p lb_2 lb_3 lb_4 leftright     geschlecht alter study1 study4 study2 study5 pool1  if             ego_pred!=50   , re
estimates store m2

xtlogit rat_i01 lb_2 lb_3 lb_4 leftright             geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1 & ego_pred!=50   , re
estimates store m3
xtlogit rat_i01 lb_2 lb_3 lb_4 leftright             geschlecht alter study1 study4 study2 study5 pool1  if pred_p==1 & ego_pred!=50   , re
estimates store m4

* Final

xtlogit rat_d01  pred_p lb_d leftright               geschlecht alter study1 study4 study2 study5 pool1  if             ego_pred!=50  , re
estimates store m5
xtlogit rat_d01  pred_p lb_2 lb_3 lb_4 leftright     geschlecht alter study1 study4 study2 study5 pool1  if             ego_pred!=50  , re
estimates store m6

xtlogit rat_d01 lb_2 lb_3 lb_4 leftright             geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1  & ego_pred!=50  , re
estimates store m7
xtlogit rat_d01 lb_2 lb_3 lb_4 leftright             geschlecht alter study1 study4 study2 study5 pool1  if pred_p==1  & ego_pred!=50  , re
estimates store m8

esttab m1 m2 m3 m4 m5 m6 m7 m8 using tab_rat.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(ll)  nogaps replace label



***************************
*** Summary Statistics ****
***************************

su ideal100 decision100 rat_i01 rat_d01 pred_r pred_p pred_i lb_d lb_2 lb_3 lb_4 leftright geschlecht alter study1 study4 study2 study5 pool1















*** Ego


*** distributions without indif

gen no_indif = 0
replace no_indif =1 if distribution== 3
replace no_indif =1 if distribution== 5
replace no_indif =1 if distribution== 6


gen ego_pred2 = ego_pred
replace ego_pred2 = . if ego_pred==50

fvset base 0 ego_pred2


xtreg    ideal100    i.lb_d##i.ego_pred2 c.leftright               geschlecht alter study1 study4 study2 study5 pool1               if no_indif==1 , re robust
xtreg decision100    i.lb_d##i.ego_pred2 c.leftright               geschlecht alter study1 study4 study2 study5 pool1               if no_indif==1 , re robust




xtreg ideal100    i.lb_d##i.ego_pred c.leftright               geschlecht alter study1 study4 study2 study5 pool1                , re robust       
margins lb_d, at(leftright=(0(.1)1)) level(90)  post
*set scheme s1color
marginsplot










*** R2 for multilevel with xtmixed (but xtmixed=mixed)

findit mlt
help mlt


xtmixed ideal100 pred_r pred_p  lb_d leftright geschlecht alter study1 study4 study2 study5 pool1                ||id:, mle robust       
predict x
gen keep = 1
replace keep = 0 if x==.

***

xtmixed ideal100 pred_r pred_p    if keep==1 ||id:, mle robust       
est store m1 
mltrsq

xtreg ideal100 pred_r pred_p    if keep==1 ,re robust       
est store m1b 

xtmixed ideal100 pred_r pred_p  lb_d             if keep==1 ||id:, mle robust       
est store m2 
mltrsq

xtreg ideal100 pred_r pred_p  lb_d             if keep==1 , re robust       
est store m2b 

xtmixed ideal100 pred_r pred_p  lb_d leftright geschlecht alter study1 study4 study2 study5 pool1                ||id:, mle robust       
est store m3 
mltrsq

xtreg ideal100 pred_r pred_p  lb_d leftright geschlecht alter study1 study4 study2 study5 pool1                       , re robust              
est store m3b 

esttab  m1 m1b m2 m2b m3 m3b using tab_ideal_r2.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) r2 aic bic nogaps replace label


 findit SCC

*** ad on

fvset base 0 ego_pred

mixed ideal100    i.lb_d##i.ego_pred                leftright lr_lb_d              geschlecht alter study1 study4 study2 study5 pool1        if ego_pred!=50        ||id:, mle robust       
mixed decision100 i.lb_d##i.ego_pred                leftright lr_lb_d              geschlecht alter study1 study4 study2 study5 pool1        if ego_pred!=50        ||id:, mle robust       

reg  groupdecision i.treatment
margins i.treatment,  level(95)
marginsplot, title(Average tax rate)
graph save avtax, replace



mixed ideal100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1   ||id:, mle robust  






***************************************
***************************************
***************************************

*** Test Multilevel mixed-effects generalized linear model

mixed ideal100 lb_d                leftright                                    geschlecht alter study1 study4 study2 study5                 ||id:, mle robust       

meglm ideal lb_d                leftright                                    geschlecht alter study1 study4 study2 study5                      ,  family(binomial) link(logit) vce(robust) || id:




*** New tests

    . webuse income
    . regress inc edu exp if male
    . estimates store Male

    . regress inc edu exp if !male
    . estimates store Female

    . suest Male Female
    . test [Male_mean = Female_mean]


reg ideal100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1     
estimates store m1

reg ideal100      lb_2 lb_3 lb_4 leftright                                    geschlecht alter study1 study4 study2 study5 pool1  if pred_p==1      
estimates store m2

suest m1 m2
test [m1_mean = m2_mean]

*
*** some basic graphs

*** pooled over time


collapse (mean) mean_ideal= ideal100 (sd) sd_ideal100=ideal100 (count) n=ideal100, by(leak_cat)

*upper and lower values of the confidence interval
generate hi_ideal = mean_ideal + invttail(n-1,0.025)*(sd_ideal100 / sqrt(n))
generate low_ideal = mean_ideal - invttail(n-1,0.025)*(sd_ideal100 / sqrt(n))

twoway (bar mean_ideal leak_cat) (rcap hi_ideal low_ideal leak_cat), xlabel(1 "No leak" 2 "5% leak" 3 "20% leak" 4 "60% leak") title("Ideal choice") legend(off) saving(idealpooled) xtitle("")



collapse (mean) mean_decision= decision100 (sd) sd_decision=decision100 (count) n=decision100, by(leak_cat)

*upper and lower values of the confidence interval
generate hi_decision = mean_decision + invttail(n-1,0.025)*(sd_decision / sqrt(n))
generate low_decision = mean_decision - invttail(n-1,0.025)*(sd_decision / sqrt(n))

twoway (bar mean_decision leak_cat) (rcap hi_decision low_decision leak_cat), xlabel(1 "No leak" 2 "5% leak" 3 "20% leak" 4 "60% leak") title("Final decision") legend(off) saving(decisionpooled) xtitle("")


graph combine idealpooled.gph decisionpooled.gph, ycommon xcommon xsize(4) ysize(2)

xtitle("")

*/
















*ideal tax over time

xtset id period

capture drop ave_ideal_lb_1 
egen ave_ideal_lb_1 = mean(ideal100) if lb_1==1, by(leak_cat period)

capture drop ave_ideal_lb_2 
egen ave_ideal_lb_2 = mean(ideal100) if lb_2==1, by(leak_cat period)

capture drop ave_ideal_lb_3 
egen ave_ideal_lb_3 = mean(ideal100) if lb_3==1, by(leak_cat period)

capture drop ave_ideal_lb_4 
egen ave_ideal_lb_4 = mean(ideal100) if lb_4==1, by(leak_cat period)

set scheme s2mono

graph twoway tsline ave_ideal_lb_1 ave_ideal_lb_2 ave_ideal_lb_3 ave_ideal_lb_4, m(o) c(l) title("ideal tax") legend(label(1 "No leak") label(2 "5% Leak") label(3 "20% Leak") label(4 "60% Leak")) saving(overtimeideal3) 


*decision over time

capture drop ave_decision_lb_1 
egen ave_decision_lb_1 = mean(decision100) if lb_1==1, by(leak_cat period)

capture drop ave_decision_lb_2 
egen ave_decision_lb_2 = mean(decision100) if lb_2==1, by(leak_cat period)

capture drop ave_decision_lb_3 
egen ave_decision_lb_3 = mean(decision100) if lb_3==1, by(leak_cat period)

capture drop ave_decision_lb_4 
egen ave_decision_lb_4 = mean(decision100) if lb_4==1, by(leak_cat period)

set scheme s2mono

graph twoway tsline ave_decision_lb_1 ave_decision_lb_2 ave_decision_lb_3 ave_decision_lb_4, m(o) c(l) title("final decision") legend(label(1 "No leak") label(2 "5% Leak") label(3 "20% Leak") label(4 "60% Leak")) saving(overtimedecision3) 

graph combine overtimeideal3.gph overtimedecision3.gph, ycommon xcommon






*** interaction with leak dummy

fvset base 0 lb_d

xtreg  ideal100 i.lb_d##c.pro_state  geschlecht alter study1 study4 study2 study5  , re robust
margins lb_d, at(pro_state=(0(.1)1)) level(90) post
set scheme s1color
marginsplot
graph save ia_pro_state.gph, replace

xtreg  ideal100 i.lb_d##c.leftright  geschlecht alter study1 study4 study2 study5  , re robust
margins lb_d, at(leftright=(0(.1)1)) level(90)  post
set scheme s1color
marginsplot
graph save ia_leftright.gph, replace

graph combine ia_pro_state.gph ia_leftright.gph, row(1) ycommon
graph save ia_both.gph, replace



*** interaction with size of leak
/*
fvset base 1 leak_cat

margins leak_cat, at(pro_state=(0(.1)1)) level(90) post
set scheme s1color
marginsplot, plot1opts(msymbol(square) lcolor(ebblue) mcolor(ebblue)) ci1opts(lcolor(ebblue)) ///
plot2opts(msymbol(triangle) lcolor(dkorange) mcolor(dkorange)) ci2opts(lcolor(dkorange)) ///
plot3opts(lcolor(gold) mcolor(gold)) ci3opts(lcolor(gold))  ///
plot4opts(msymbol(diamond) lcolor(dkgreen) mcolor(dkgreen)) ci4opts(lcolor(dkgreen))
graph save ia_pro_state2.gph, replace

xtreg  ideal100 i.leak_cat##c.leftright  geschlecht alter study1 study4 study2 study5  , re robust
margins leak_cat, at(leftright=(0(.1)1)) level(90)  post
set scheme s1color
marginsplot, plot1opts(msymbol(square) lcolor(ebblue) mcolor(ebblue)) ci1opts(lcolor(ebblue)) ///
plot2opts(msymbol(triangle) lcolor(dkorange) mcolor(dkorange)) ci2opts(lcolor(dkorange)) ///
plot3opts(lcolor(gold) mcolor(gold)) ci3opts(lcolor(gold))  ///
plot4opts(msymbol(diamond) lcolor(dkgreen) mcolor(dkgreen)) ci4opts(lcolor(dkgreen))
graph save ia_leftright2.gph, replace

grc1leg ia_pro_state2.gph ia_leftright2.gph, row(1) ycommon
graph save ia_both2.gph, replace
graph display Graph, ysize(4) xsize(7)

gr_edit .legend.plotregion1.label[1].text = {}
gr_edit .legend.plotregion1.label[1].text.Arrpush No Leak
gr_edit .legend.plotregion1.label[2].text = {}
gr_edit .legend.plotregion1.label[2].text.Arrpush 5% Leak
gr_edit .legend.plotregion1.label[3].text = {}
gr_edit .legend.plotregion1.label[3].text.Arrpush 20 % Leak
gr_edit .legend.plotregion1.label[4].text = {}
gr_edit .legend.plotregion1.label[4].text.Arrpush 60% Leak
*/
 
*** interaction with size of leak - decsion


fvset base 1 leak_cat

xtreg  decision100 i.leak_cat##c.pro_state  geschlecht alter study1 study4 study2 study5  , re robust
margins leak_cat, at(pro_state=(0(.1)1)) level(90) post
set scheme s1color
marginsplot, plot1opts(msymbol(square) lcolor(ebblue) mcolor(ebblue)) ci1opts(lcolor(ebblue)) ///
plot2opts(msymbol(triangle) lcolor(dkorange) mcolor(dkorange)) ci2opts(lcolor(dkorange)) ///
plot3opts(lcolor(gold) mcolor(gold)) ci3opts(lcolor(gold))  ///
plot4opts(msymbol(diamond) lcolor(dkgreen) mcolor(dkgreen)) ci4opts(lcolor(dkgreen))
graph save ia_pro_state2.gph, replace

xtreg  decision100 i.leak_cat##c.leftright  geschlecht alter study1 study4 study2 study5  , re robust
margins leak_cat, at(leftright=(0(.1)1)) level(90)  post
set scheme s1color
marginsplot, plot1opts(msymbol(square) lcolor(ebblue) mcolor(ebblue)) ci1opts(lcolor(ebblue)) ///
plot2opts(msymbol(triangle) lcolor(dkorange) mcolor(dkorange)) ci2opts(lcolor(dkorange)) ///
plot3opts(lcolor(gold) mcolor(gold)) ci3opts(lcolor(gold))  ///
plot4opts(msymbol(diamond) lcolor(dkgreen) mcolor(dkgreen)) ci4opts(lcolor(dkgreen))
graph save ia_leftright2.gph, replace

grc1leg ia_pro_state2.gph ia_leftright2.gph, row(1) ycommon
graph save ia_both2.gph, replace
graph display Graph, ysize(4) xsize(7)

gr_edit .legend.plotregion1.label[1].text = {}
gr_edit .legend.plotregion1.label[1].text.Arrpush No Leak
gr_edit .legend.plotregion1.label[2].text = {}
gr_edit .legend.plotregion1.label[2].text.Arrpush 5% Leak
gr_edit .legend.plotregion1.label[3].text = {}
gr_edit .legend.plotregion1.label[3].text.Arrpush 20 % Leak
gr_edit .legend.plotregion1.label[4].text = {}
gr_edit .legend.plotregion1.label[4].text.Arrpush 60% Leak



*********************
*** Last decision ***
*********************

**Regression (RE)
xtset id period

*** leak dummy

xtreg decision100 lb_d                                                                , re robust        
estimates store m1
xtreg decision100 lb_d       pro_state                                                , re robust 
estimates store m2
xtreg decision100 lb_d       pro_state  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m3
xtreg decision100 lb_d       leftright                                                , re robust
estimates store m4
xtreg decision100 lb_d       leftright  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m5
esttab m1 m2 m3 m4 m5 using tab3.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label

*** leak size

xtreg decision100 lb_2 lb_3  lb_4                                                         , re robust       
estimates store m1
xtreg decision100 lb_2 lb_3 lb_4 pro_state                                                , re robust  
estimates store m2
xtreg decision100 lb_2 lb_3 lb_4 pro_state  geschlecht alter study1 study4 study2 study5  , re robust 
estimates store m3
xtreg decision100 lb_2 lb_3 lb_4 leftright                                                , re robust 
estimates store m4
xtreg decision100 lb_2 lb_3 lb_4  pro_state  i.leak_cat##c.pro_state geschlecht alter study1 study4 study2 study5 EFF IAV ILO SPI , re robust 
estimates store m5
esttab m1 m2 m3 m4 m5 using tab4.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label


**** Final Tables

xtreg ideal100 lb_d                                                                , re robust        
estimates store m1
xtreg ideal100 lb_d       pro_state  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m2
xtreg ideal100 lb_d       leftright  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m3
xtreg ideal100 lb_2 lb_3 lb_4                                                          , re robust        
estimates store m4
xtreg ideal100 lb_2 lb_3 lb_4 pro_state  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m5
xtreg ideal100 lb_2 lb_3 lb_4 leftright  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m6
esttab m1 m2 m3 m4 m5 m6 using tab1_fin.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label

xtreg decision100 lb_d                                                                , re robust        
estimates store m1
xtreg decision100 lb_d       pro_state  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m2
xtreg decision100 lb_d       leftright  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m3
xtreg decision100 lb_2 lb_3  lb_4                                                         , re robust        
estimates store m4
xtreg decision100 lb_2 lb_3 lb_4 pro_state  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m5
xtreg decision100 lb_2 lb_3 lb_4 leftright  geschlecht alter study1 study4 study2 study5  , re robust
estimates store m6
esttab m1 m2 m3 m4 m5 m6 using tab2_fin.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label


******************
*Grafik zu H2
*******************
twoway (lfitci ideal100 LR, level(90) ) 
twoway (lfitci ideal100 pro_state, level(90) )  (lfitci decision100 pro_state, level(90))


************************
* IDEAL (Model: MIXED) *
************************

* H1
xtreg ideal100 lb_d                leftright                      pred_r pred_p EFF IAV geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m1

xtreg ideal100      lb_2 lb_3 lb_4 leftright                      pred_r pred_p EFF IAV geschlecht alter study1 study4 study2 study5 pool1                , re robust
estimates store m2

* H2
xtreg ideal100      lb_2 lb_3 lb_4 leftright                                    EFF IAV geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1  , re robust  
estimates store m3

xtreg ideal100      lb_2 lb_3 lb_4 leftright                                    EFF IAV geschlecht alter study1 study4 study2 study5 pool1 if pred_p==1   , re robust  
estimates store m4

* H3
xtreg ideal100 i.lb_d##c.leftright                               pred_r pred_p EFF IAV geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m5

esttab m1 m2 m3 m4 m5 using tab_ideal.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label



************************
* IDEAL (Model: MIXED) *
************************

* H1
xtreg ideal100 lb_d                leftright                      pred_r pred_p wtp_a wtp_d geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m1

xtreg ideal100      lb_2 lb_3 lb_4 leftright                      pred_r pred_p wtp_a wtp_d geschlecht alter study1 study4 study2 study5 pool1                , re robust
estimates store m2

* H2
xtreg ideal100      lb_2 lb_3 lb_4 leftright                                    wtp_a wtp_d geschlecht alter study1 study4 study2 study5 pool1  if pred_r==1  , re robust  
estimates store m3

xtreg ideal100      lb_2 lb_3 lb_4 leftright                                    wtp_a wtp_d geschlecht alter study1 study4 study2 study5 pool1 if pred_p==1   , re robust  
estimates store m4

* H3
xtreg ideal100 i.lb_d##c.leftright                               pred_r pred_p wtp_a wtp_d geschlecht alter study1 study4 study2 study5 pool1                , re robust       
estimates store m5

esttab m1 m2 m3 m4 m5, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2_w r2_o r2_b) nogaps replace label














/*


*************************************************************
**** OLD STUFF **********************************************
*************************************************************


* Tab A
eststo: xtreg ideal100 lb_d
eststo: xtreg ideal100 lb_2 lb_3 
eststo: xtreg ideal100 lb_d EFF IAV ILO  SPI egoistic 
eststo: xtreg ideal100 lb_d geschlecht alter pol_selbst index_staatprivat study1 study4 study2 study5
eststo: xtreg ideal100 lb_d EFF IAV ILO  SPI egoistic geschlecht alter pol_selbst  index_staatprivat study1 study4 study2 study5 alterXpol alterXstaatprivat 
esttab
eststo clear


* Tab B
eststo: xtreg decision100 lb_d
eststo: xtreg decision100 lb_2 lb_3 
eststo: xtreg decision100 lb_d EFF IAV ILO  SPI egoistic 
eststo: xtreg decision100 lb_d geschlecht alter pol_selbst index_staatprivat study1 study4 study2 study5
eststo: xtreg decision100 lb_d EFF IAV ILO  SPI egoistic geschlecht alter pol_selbst  index_staatprivat study1 study4 study2 study5 alterXpol alterXstaatprivat 
esttab
eststo clear




*** Figures


/*
*Graph
meanplot ideal period lb, ///
								ytitle(individually preferred tax rate) ///
								xtitle(Round) ///
								graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
								saving(gph/mean_1, replace)	
								
meanplot decision period lb, ///
								ytitle(individual decision for tax rate) ///
								xtitle(Round) ///
								graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
								saving(gph/mean_2, replace)	
gr combine gph/mean_1.gph	 gph/mean_2.gph
*/





**Regression (RE)
xtset id period

* Table 2 in the recent working paper
*** leak size
xtreg ideal100 lb_d                                                         , re robust       
estimates store m0
xtreg ideal100 lb_2 lb_3 lb_4                                                         , re robust       
estimates store m1
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
*xtreg ideal100 lb_2 lb_3 lb_4 pro_state                                                , re robust  
*estimates store m2
xtreg ideal100 lb_2 lb_3 lb_4 leftright                                                , re robust  
estimates store m3
xtreg ideal100 lb_2 lb_3 lb_4 leftright lr_lb2 lr_lb3 lr_lb4                           , re robust  
estimates store m31
xtreg ideal100 lb_2 lb_3 lb_4 leftright geschlecht alter study1 study4 study2 study5   , re robust  
estimates store m4
xtreg ideal100 lb_2 lb_3 lb_4 leftright geschlecht EFF IAV SPI ILO 					   , re robust  
estimates store m5
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
*esttab m1 m2 m3 m4 m5 using tab2.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label
estout m0 m1 m3 m31 m4 m5, cells(b(star fmt(3)) se(par fmt(3)))   ///
legend label varlabels(_cons constant)               ///
starlevels( * 0.10 ** 0.05 *** 0.010) stats(chi2 N, fmt(3 0) label(Wald-chi2 N)) style(tex) 




* Table 3 in the recent working paper
*** leak size
xtreg ideal100 lb_d pred_r pred_p                                                         , re robust       
estimates store m0
xtreg ideal100 lb_2 lb_3 lb_4 pred_r pred_p                                                         , re robust       
estimates store m1
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
*xtreg ideal100 lb_2 lb_3 lb_4 ego_pred pro_state                                                , re robust  
*estimates store m2
xtreg ideal100 lb_2 lb_3 lb_4 pred_r pred_p leftright                                                , re robust  
estimates store m3
xtreg ideal100 lb_2 lb_3 lb_4 pred_r pred_p leftright geschlecht alter study1 study4 study2 study5   , re robust  
estimates store m4
xtreg ideal100 lb_2 lb_3 lb_4 pred_r pred_p leftright geschlecht EFF IAV SPI ILO 					   , re robust  
estimates store m5
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
**esttab m1 m2 m3 m4 m5 using tab2.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label
estout m0 m1 m3 m4 m5, cells(b(star fmt(3)) se(par fmt(3)))   ///
legend label varlabels(_cons constant)               ///
starlevels( * 0.10 ** 0.05 *** 0.010) stats(chi2 N, fmt(3 0) label(Wald-chi2 N)) style(tex)




*** seperated for rich and poor
xtreg ideal100 lb_2 lb_3 lb_4 leftright                                   , re robust  
estimates store all
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
xtreg ideal100 lb_2 lb_3 lb_4 leftright if pred_r==1                                   , re robust  
estimates store rich
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
xtreg ideal100 lb_2 lb_3 lb_4 leftright if pred_p==1                                   , re robust  
estimates store poor
test _b[lb_2]=_b[lb_3]
test _b[lb_2]=_b[lb_4]
test _b[lb_3]=_b[lb_4]
*esttab m1 m2 m3 m4 m5 using tab2.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label
estout all rich poor, cells(b(star fmt(3)) se(par fmt(3)))   ///
legend label varlabels(_cons constant)               ///
starlevels( * 0.10 ** 0.05 *** 0.010) stats(chi2 N, fmt(3 0) label(Wald-chi2 N)) style(tex)


































