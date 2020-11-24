
**********************
*** 22. March 2020 ***
**********************

use "C:\Users\Tepe\Dropbox\IPP_Procedural_Preferences\Daten\20181218_exp1_workingdata.dta", clear
cd "C:\Users\Tepe\Dropbox\IPP_Procedural_Preferences\Daten"


 
***************
*** Coding ****
***************

sort sessionid period group

label define treatment_lb 1 "Lim. Info" 2 "Full Info" 3 "Info Chat" 
label values treatment treatment_lb

*******************
*** NEW APROACH ***
*******************

*** what is at stake

gen stake = abs(8-bruttoincome)

gen rat_choice_MV = . 

*** treat no info

replace rat_choice_MV = 1  if bruttoincome==0  & distribution==1 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==6  & distribution==1 & treatment==1
replace rat_choice_MV = 0  if bruttoincome==18 & distribution==1 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==3  & distribution==2 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==6  & distribution==2 & treatment==1
replace rat_choice_MV = 0  if bruttoincome==15 & distribution==2 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==5  & distribution==3 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==7  & distribution==3 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==12 & distribution==3 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==0  & distribution==4 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==4 & treatment==1
replace rat_choice_MV = 0  if bruttoincome==14 & distribution==4 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==3  & distribution==5 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==5 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==11 & distribution==5 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==5  & distribution==6 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==9  & distribution==6 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==6 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==6  & distribution==7 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==8  & distribution==7 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==7 & treatment==1

replace rat_choice_MV = 1  if bruttoincome==0  & distribution==8 & treatment==1
replace rat_choice_MV = 1  if bruttoincome==8  & distribution==8 & treatment==1
replace rat_choice_MV = 0  if bruttoincome==16 & distribution==8 & treatment==1


* Treat info & info + chat

replace rat_choice_MV = 1  if bruttoincome==0  & distribution==1 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==6  & distribution==1 & treatment ==2
replace rat_choice_MV = 0  if bruttoincome==18 & distribution==1 & treatment ==2

replace rat_choice_MV = 1  if bruttoincome==3  & distribution==2 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==6  & distribution==2 & treatment ==2
replace rat_choice_MV = 0  if bruttoincome==15 & distribution==2 & treatment ==2

replace rat_choice_MV = 1  if bruttoincome==5  & distribution==3 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==7  & distribution==3 & treatment ==2
replace rat_choice_MV = 0  if bruttoincome==12 & distribution==3 & treatment ==2

replace rat_choice_MV = 0  if bruttoincome==0  & distribution==4 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==4 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==14 & distribution==4 & treatment ==2

replace rat_choice_MV = 0  if bruttoincome==3  & distribution==5 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==5 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==11 & distribution==5 & treatment ==2

replace rat_choice_MV = 0  if bruttoincome==5  & distribution==6 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==9  & distribution==6 & treatment ==2
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==6 & treatment ==2

replace rat_choice_MV = .5 if bruttoincome==6  & distribution==7 & treatment ==2
replace rat_choice_MV = .5 if bruttoincome==8  & distribution==7 & treatment ==2
replace rat_choice_MV = .5 if bruttoincome==10 & distribution==7 & treatment ==2

replace rat_choice_MV = .5 if bruttoincome==0  & distribution==8 & treatment ==2
replace rat_choice_MV = .5 if bruttoincome==8  & distribution==8 & treatment ==2
replace rat_choice_MV = .5 if bruttoincome==16 & distribution==8 & treatment ==2


* Treat info & info + chat

replace rat_choice_MV = 1  if bruttoincome==0  & distribution==1 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==6  & distribution==1 & treatment ==3
replace rat_choice_MV = 0  if bruttoincome==18 & distribution==1 & treatment ==3

replace rat_choice_MV = 1  if bruttoincome==3  & distribution==2 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==6  & distribution==2 & treatment ==3
replace rat_choice_MV = 0  if bruttoincome==15 & distribution==2 & treatment ==3

replace rat_choice_MV = 1  if bruttoincome==5  & distribution==3 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==7  & distribution==3 & treatment ==3
replace rat_choice_MV = 0  if bruttoincome==12 & distribution==3 & treatment ==3

replace rat_choice_MV = 0  if bruttoincome==0  & distribution==4 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==4 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==14 & distribution==4 & treatment ==3

replace rat_choice_MV = 0  if bruttoincome==3  & distribution==5 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==5 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==11 & distribution==5 & treatment ==3

replace rat_choice_MV = 0  if bruttoincome==5  & distribution==6 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==9  & distribution==6 & treatment ==3
replace rat_choice_MV = 1  if bruttoincome==10 & distribution==6 & treatment ==3

replace rat_choice_MV = .5 if bruttoincome==6  & distribution==7 & treatment ==3
replace rat_choice_MV = .5 if bruttoincome==8  & distribution==7 & treatment ==3
replace rat_choice_MV = .5 if bruttoincome==10 & distribution==7 & treatment ==3

replace rat_choice_MV = .5 if bruttoincome==0  & distribution==8 & treatment ==3
replace rat_choice_MV = .5 if bruttoincome==8  & distribution==8 & treatment ==3
replace rat_choice_MV = .5 if bruttoincome==16 & distribution==8 & treatment ==3


gen rat_MV_cat=.
replace rat_MV_cat = 1 if rat_choice_MV==0
replace rat_MV_cat = 2 if rat_choice_MV==.5
replace rat_MV_cat = 3 if rat_choice_MV==1

label define rat_MV_cat_lb 1 "Pref-RD" 2 "Indif." 3 "Pref-MV" 
label values rat_MV_cat rat_MV_cat_lb


*** individual rational tax choice (1=100%, 0.5=indifferent, 0=0%)
gen ind_rat = .
replace ind_rat = 1 if bruttoincome<8
replace ind_rat =.5 if bruttoincome==8
replace ind_rat = 0 if bruttoincome>8

gen ind_rat_cat=.
replace ind_rat_cat = 3 if ind_rat==1
replace ind_rat_cat = 2 if ind_rat==.5
replace ind_rat_cat = 1 if ind_rat==0

label define ind_rat_cat_lb 3 "Pref. Redist." 2 "Indif." 1 "Pref. No Redist." 
label values ind_rat_cat ind_rat_cat_lb

gen ind_rat_reU = . 
replace ind_rat_reU = 8-bruttoincome

*** group rational tax choice (1=100%, 0.5=indifferent, 0=0%)
egen groupid = group(sessionid period group)

sort groupid
by groupid: egen ind_rat_sum = sum(ind_rat)

gen group_rat = .
replace group_rat = 1 if ind_rat_sum==2
replace group_rat =.5 if ind_rat_sum==1.5
replace group_rat = 0 if ind_rat_sum==1

* browse sessionid treatment id period group groupid poor ind_rat ind_rat_sum group_rat 


*** Did I vote rational?
*** Did I choose the procedure rational?
*** Did my procedual vote win

gen pro_win = 0
replace pro_win = 1 if decisionprocedure==1 & implementedprocedure==1 
replace pro_win = 1 if decisionprocedure==0 & implementedprocedure==2


*****************************************************
*** Procedural pref. over treatment conditions    ***
*****************************************************

*** Anova
oneway  decisionprocedure  treatment 
kwallis decisionprocedure  , by(treatment)

*** Means
tabstat decisionprocedure, by(treatment) stat(mean)
reg  decisionprocedure i.treatment
*margins i.treatment
*marginsplot,  xtitle("") title("Majortity Voting")


***********************************************************************
*** Procedural pref. by group majority over treatment conditions    ***
***********************************************************************

gen treat01= .
replace treat01 = 0 if treatment==2
replace treat01 = 1 if treatment==3
label var treat01 "Chat"
label define treat01lb 0 "No Chat" 1 "Chat"
label values treat01 treat01lb

gen treat01_noinfo = . 
replace treat01_noinfo = 0 if treatment==2
replace treat01_noinfo = 1 if treatment==1
label var treat01 "Lim. Info"
label define treat01_noinfolb 0 "Full Info" 1 "Lim. Info"
label values treat01_noinfo treat01_noinfolb

* Treatment = no info
table group_rat	ind_rat	if	treatment==1,	contents(mean	decisionprocedure)
* Treatment = full info (rational benchmark)
table	group_rat	ind_rat	if	treatment==2,	contents(mean	decisionprocedure)
* Treatment = chat
table	group_rat	ind_rat	if	treatment==3,	contents(mean	decisionprocedure)

***T-Test info vs. info chat
ttest decisionprocedure if group_rat==0 & ind_rat==0 , by(treat01) 
ttest decisionprocedure if group_rat==.5 & ind_rat==0 , by(treat01) 
ttest decisionprocedure if group_rat==1 & ind_rat==0 , by(treat01)
ttest decisionprocedure if group_rat==.5 & ind_rat==.5 , by(treat01)
ttest decisionprocedure if group_rat==0 & ind_rat== 1 , by(treat01) 
ttest decisionprocedure if group_rat==.5 & ind_rat==1 , by(treat01) 
ttest decisionprocedure if group_rat==1 & ind_rat==1, by(treat01)

***T-Test info vs. no info
ttest decisionprocedure if group_rat==0 & ind_rat==0 , by(treat01_noinfo) 
ttest decisionprocedure if group_rat==.5 & ind_rat==0 , by(treat01_noinfo) 
ttest decisionprocedure if group_rat==1 & ind_rat==0 , by(treat01_noinfo)
ttest decisionprocedure if group_rat==.5 & ind_rat==.5 , by(treat01_noinfo)
ttest decisionprocedure if group_rat==0 & ind_rat== 1 , by(treat01_noinfo) 
ttest decisionprocedure if group_rat==.5 & ind_rat==1 , by(treat01_noinfo) 
ttest decisionprocedure if group_rat==1 & ind_rat==1, by(treat01_noinfo)


*** Ego. rational choice of decision procedure (yes, no)
gen inst = .5
replace inst=1 if group_rat==0 & ind_rat==0
replace inst=1 if group_rat==1 & ind_rat==1
replace inst=0 if group_rat==0 & ind_rat==1
replace inst=0 if group_rat==1 & ind_rat==0

gen inst01 = .
replace inst01=1 if group_rat==0 & ind_rat==0
replace inst01=1 if group_rat==1 & ind_rat==1
replace inst01=0 if group_rat==0 & ind_rat==1
replace inst01=0 if group_rat==1 & ind_rat==0

label define inst01lb 0 "RD" 1 "MV"
label values inst01 inst01lb
label var inst01 "Egoistic prediction"

gen inst_cat = 2
replace inst_cat=3 if group_rat==0 & ind_rat==0
replace inst_cat=3 if group_rat==1 & ind_rat==1
replace inst_cat=1 if group_rat==0 & ind_rat==1
replace inst_cat=1 if group_rat==1 & ind_rat==0

label define inst_catlb 1 "RD" 2 "Indif." 3 "MV"
label values inst_cat inst_catlb
label var inst_cat "Egoistic prediction"


*****************
* EU_MV *********
*****************

* No-info dummy

generate dum_noinfo = .
replace dum_noinfo = 1 if treatment == 1
replace dum_noinfo = 0 if treatment == 2
replace dum_noinfo = 0 if treatment == 3

* Info-dummy
generate dum_info = .
replace dum_info = 0 if treatment == 1
replace dum_info = 1 if treatment == 2
replace dum_info = 1 if treatment == 3

* Chat_dummy
generate dum_chat = .
replace dum_chat = 0 if treatment == 1
replace dum_chat = 0 if treatment == 2
replace dum_chat = 1 if treatment == 3


* Compute expected net benefit from Majority vote = [p(MV) - p(RD)](y_bar - y_i)
* limited info treatment	
		generate EU_MV = .
		
		replace EU_MV = 0.96  if bruttoincome == 0  & dum_noinfo == 1
		replace EU_MV = 0.91  if bruttoincome == 3  & dum_noinfo == 1
		replace EU_MV = 0.70  if bruttoincome == 5  & dum_noinfo == 1
		replace EU_MV = 0.53  if bruttoincome == 6  & dum_noinfo == 1
		replace EU_MV = 0.30  if bruttoincome == 7  & dum_noinfo == 1
		replace EU_MV = 0.00  if bruttoincome == 8  & dum_noinfo == 1
		replace EU_MV = 0.29  if bruttoincome == 9  & dum_noinfo == 1
		replace EU_MV = 0.49  if bruttoincome == 10 & dum_noinfo == 1
		replace EU_MV = 0.57  if bruttoincome == 11 & dum_noinfo == 1
		replace EU_MV = 0.51  if bruttoincome == 12 & dum_noinfo == 1
		replace EU_MV = -0.18 if bruttoincome == 14 & dum_noinfo == 1
		replace EU_MV = -0.93 if bruttoincome == 15 & dum_noinfo == 1
		replace EU_MV = -2.07 if bruttoincome == 16 & dum_noinfo == 1
		replace EU_MV = -3.33 if bruttoincome == 18 & dum_noinfo == 1
		
* full info treatment		
		replace EU_MV = 2.67  if bruttoincome == 0  & dum_noinfo == 0 & group_rat == 1
		replace EU_MV = -2.67 if bruttoincome == 0  & dum_noinfo == 0 & group_rat == 0
		replace EU_MV = 0     if bruttoincome == 0  & dum_noinfo == 0 & group_rat == 0.5
		
		replace EU_MV = 1.67  if bruttoincome == 3  & dum_noinfo == 0 & group_rat == 1
		replace EU_MV = -1.67 if bruttoincome == 3  & dum_noinfo == 0 & group_rat == 0
		
		replace EU_MV = 1.00  if bruttoincome == 5  & dum_noinfo == 0 & group_rat == 1
		replace EU_MV = -1.00 if bruttoincome == 5  & dum_noinfo == 0 & group_rat == 0
		
		replace EU_MV = 0.67  if bruttoincome == 6  & dum_noinfo == 0 & group_rat == 1
		replace EU_MV = 0.00  if bruttoincome == 6  & dum_noinfo == 0 & group_rat == 0.5
				
		replace EU_MV = 0.33  if bruttoincome == 7  & dum_noinfo == 0 & group_rat == 1
		
		replace EU_MV = 0.00  if bruttoincome == 8  & dum_noinfo == 0 & group_rat == 0.5
		
		replace EU_MV = 0.33  if bruttoincome == 9  & dum_noinfo == 0 & group_rat == 0
		
		replace EU_MV = 0.67  if bruttoincome == 10 & dum_noinfo == 0 & group_rat == 0
		replace EU_MV = 0.00  if bruttoincome == 10 & dum_noinfo == 0 & group_rat == 0.5
		
		replace EU_MV = 1.00  if bruttoincome == 11 & dum_noinfo == 0 & group_rat == 0
		
		replace EU_MV = -1.33 if bruttoincome == 12 & dum_noinfo == 0 & group_rat == 1
		
		replace EU_MV = 2.00  if bruttoincome == 14 & dum_noinfo == 0 & group_rat == 0
		
		replace EU_MV = -2.33 if bruttoincome == 15 & dum_noinfo == 0 & group_rat == 1
		
		replace EU_MV = 0.00  if bruttoincome == 16 & dum_noinfo == 0 & group_rat == 0.5
		
		replace EU_MV = -3.33 if bruttoincome == 18 & dum_noinfo == 0 & group_rat == 1
		


***************************
*** NEW Main Reg. Tab.  ***
***************************

tsset id period
fvset base 2 treatment
fvset base 2 rat_MV_cat

* 1st Stage

xtlogit decisionprocedure i.rat_MV_cat i.treatment   i.female period , re vce(robust)
est store m1
margins i.rat_MV_cat
marginsplot,  title("Predictive Margins (95% CIs)", size(medium)) ytitle("Pr(Decisionprocedure=MV)", size(medium)) xtitle("") recast(scatter)
graph save fig1a.gph, replace
xtlogit decisionprocedure i.rat_MV_cat i.treatment   i.female period , re vce(robust)
margins i.treatment
marginsplot, title("Predictive Margins (95% CIs)", size(medium)) ytitle("Pr(Decisionprocedure=MV)", size(medium)) xtitle("Treatment")  recast(scatter)
graph save fig1b.gph, replace

xtlogit decisionprocedure c.EU_MV i.treatment   i.female period , re vce(robust)
est store m2
margins, at(EU_MV =( -3.33(.5)2.67))
marginsplot, title("Predictive Margins (95% CIs)", size(medium)) ytitle("Pr(Decisionprocedure=MV)", size(medium)) xtitle("E(Dy|MV)", size(medium))
graph save fig2a.gph, replace
xtlogit decisionprocedure c.EU_MV i.treatment   i.female period , re vce(robust)
margins i.treatment
marginsplot, title("Predictive Margins (95% CIs)", size(medium)) ytitle("Pr(Decisionprocedure=MV)", size(medium)) xtitle("Treatment", size(medium)) recast(scatter)
graph save fig2b.gph, replace

graph combine fig1a.gph fig2a.gph, ycommon xsize(6) ysize(4)
graph save fig1, replace

graph combine fig1b.gph fig2b.gph, ycommon xsize(6) ysize(4)
graph save fig2, replace


xtlogit decisionprocedure i.rat_MV_cat##i.treatment   i.female period, re vce(robust)
est store m3
margins i.rat_MV_cat##i.treatment
marginsplot, title("Predictive Margins (95% CIs)", size(medium)) ytitle("Pr(Decisionprocedure=MV)") recast(scatter)
graph save fig3a, replace
xtlogit decisionprocedure c.EU_MV##i.treatment         i.female period, re vce(robust)
est store m4
margins treatment, at(EU_MV =( -3.33(.5)2.67)) post level(95)
marginsplot, title("Predictive Margins (95% CIs)", size(medium)) ytitle("Pr(Decisionprocedure=MV)")  xtitle("E(Dy|MV)", size(medium))
graph save fig3b, replace
graph combine fig3a.gph fig3b.gph, ycommon xsize(6) ysize(4)
graph save fig3, replace

esttab m1 m2 m3 m4 using tab_ind.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


**********************
*** LR Test **********
**********************

xtlogit decisionprocedure i.rat_MV_cat i.treatment    i.female period , re 
est store m1
xtlogit decisionprocedure i.rat_MV_cat##i.treatment   i.female period, re 
est store m2
lrtest m1 m2

xtlogit decisionprocedure c.EU_MV i.treatment          i.female period , re 
est store m1
xtlogit decisionprocedure c.EU_MV##i.treatment         i.female period, re 
est store m2
lrtest m1 m2

***********************
*** Rob. without 18 ***
***********************

* 1st Stage

xtlogit decisionprocedure i.rat_MV_cat  i.treatment    i.female period if distribution!=1, re vce(robust)
est store m1
xtlogit decisionprocedure c.EU_MV       i.treatment    i.female period if distribution!=1, re vce(robust)
est store m2
xtlogit decisionprocedure i.rat_MV_cat##i.treatment    i.female period if distribution!=1, re vce(robust)
est store m3
xtlogit decisionprocedure c.EU_MV##i.treatment         i.female period if distribution!=1, re vce(robust)
est store m4
esttab m1 m2 m3 m4 using tab_rob.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


**********************************
*** 2nd Stage Robustness Check ***
**********************************

fvset base 2 ind_rat_cat

xtlogit decisionredistribution i.ind_rat_cat##i.pro_win  i.treatment  i.female i.treatment  , re vce(robust)
est store m1
margins i.ind_rat_cat##i.pro_win
marginsplot
graph save fig4a, replace

xtlogit decisionredistribution c.ind_rat_reU##i.pro_win  i.treatment  i.female i.treatment  , re vce(robust)
est store m2
margins pro_win, at(ind_rat_re =( -10(2)8))
marginsplot
graph save fig4b, replace
graph combine fig4a.gph fig4b.gph, ycommon
graph save fig4, replace

esttab m1 m2 using tab_2nd.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


**************************************
*** Check Consistency with Philipp ***
**************************************

* Table 8 / Model 8

fvset base 1 treatment
reg decisionprocedure c.EU_MV##i.treatment         i.female , robust


**************************
*** Check linear prob. ***
**************************

* 1st Stage

xtreg decisionprocedure i.rat_MV_cat i.treatment   i.female period , re vce(robust)
est store m1
margins i.rat_MV_cat
marginsplot
graph save fig1ra.gph, replace
xtreg decisionprocedure i.rat_MV_cat i.treatment   i.female period , re vce(robust)
margins i.treatment
marginsplot 
graph save fig1rb.gph, replace

xtreg decisionprocedure c.EU_MV i.treatment   i.female period , re vce(robust)
est store m2
margins, at(EU_MV =( -3.33(.5)2.67))
marginsplot
graph save fig2ra.gph, replace
xtreg decisionprocedure c.EU_MV i.treatment   i.female period , re vce(robust)
margins i.treatment
marginsplot 
graph save fig2rb.gph, replace

graph combine fig1ra.gph fig2ra.gph, ycommon
graph save figr1, replace

graph combine fig1rb.gph fig2rb.gph, ycommon
graph save figr2, replace


xtreg decisionprocedure i.rat_MV_cat##i.treatment   i.female period, re vce(robust)
est store m3
margins i.rat_MV_cat##i.treatment
marginsplot
graph save fig3ra, replace
xtreg decisionprocedure c.EU_MV##i.treatment         i.female period, re vce(robust)
est store m4
margins treatment, at(EU_MV =( -3.33(.5)2.67)) post level(95)
marginsplot
graph save fig3rb, replace
graph combine fig3ra.gph fig3rb.gph, ycommon
graph save figr3, replace

esttab m1 m2 m3 m4 using tab_ind_reg.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


******************************
* Analysis of Chat Protocols *
******************************

* Frequencies

use "C:\Users\Tepe\Dropbox\IPP_Procedural_Preferences\Daten\chat_freqeuncy.dta", clear
graph hbar frequency , over( word, sort(  feature)) 

* Keyness

use "C:\Users\Tepe\Dropbox\IPP_Procedural_Preferences\Daten\chat_key.dta", clear

graph hbar chi2 if traget==1 & var6==1, over( word, sort(  sort)) title("Target Group")
graph save fig1w.gph, replace

graph hbar chi2 if traget==0 & var6==1, over( word, sort(  sort)) title("Reference Group")
graph save fig2w.gph, replace

graph combine fig1w.gph fig2w.gph, xsize(3) ysize(4) col(1) xcommon

