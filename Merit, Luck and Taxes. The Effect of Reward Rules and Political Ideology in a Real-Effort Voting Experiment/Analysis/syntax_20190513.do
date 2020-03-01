*****************
* Final *********
*****************

use "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Daten\20170821_productivity_redistribution_master.dta", replace 


set more off

drop incomeposition

***********
*** ID ****
***********

replace id = 1800 + subject if sessionid==18

***********
*** MAX ***
***********

replace lab = 1 if sessionid==1

replace lab = 2 if sessionid==17
replace lab = 2 if sessionid==19
replace lab = 2 if sessionid==18


*** Group ID

** egen groupid = group(sessionid period group)
gen group_id = (sessionid *10000) + (period *1000) + group
drop groupid
gen  groupid = group_id

******************
*** Treatment ****
******************

*** alle 5
label define treat_lb 1 "Earned info" 2 "Random info" 3 "Earned no info" 4 "Random no info" 5 "Equal"
label values treatment treat_lb 
label var treatment "Treatment condition"


*** nur 2 main (=930 Obs.)
recode treatment 1=1 2=2 else=., gen(treat01)
label define treat01_lb 1 "Unequal Earned" 2 "Unequal Random" 
label values treat01 treat01_lb 
tab treat01

*** nur 3 main (=1125 Obs.)
recode treatment 1=1 2=2 5=3 else=., gen(treat03)
label define treat03_lb 1 "Unequal Earned" 2 "Unequal Random" 3 "Equal"
label values treat03 treat03_lb 
tab treat03


*** nur 4 main und noinfo 
recode treatment 1=1 2=2 3=3 4=4 else=., gen(treat04)
label define treat04_lb 1 "Unequal Earned" 2 "Unequal Random" 3 "Unequal Earned (no info)" 4 "Unequal Random (no info)" 
label values treat04 treat04_lb 
tab treat04

*** sample FILTER dummies
recode treat01 1=1 2=1             , gen(sample01)
recode treat03 1=1 2=1 3=1         , gen(sample03)
recode treat04 1=1 2=1 3=1 4=1     , gen(sample04)



*********************
*** Recoding Vars ***
*********************

*** Variables

label var rate "Productivity"
label var age "Age"
label var female "Female"
label var sem "Semester"

tab study, gen(study)
label var study1 "Natural science"
label var study2 "Other"
label var study3 "Social science"
label var study4 "Arts Humanities"
label var study5 "Business science"


* Partisan orientation
recode pol_selbstein 0=1 1=.9 2=.8 3=.7 4=.6 5=.5 6=.44 7=.33 8=.2 9=.1 10=0, gen(leftright)
su leftright
label var leftright "Right Left"

**********************************
*** Rational choice prediction ***
**********************************

sort sessionid period group subject

bysort groupid: egen bruttoincome_sum  = sum(bruttoincome)
bysort groupid: egen bruttoincome_min  = min(bruttoincome)
bysort groupid: egen bruttoincome_max  = max(bruttoincome)
bysort groupid: egen bruttoincome_mean = mean(bruttoincome)

gen rat_vote = . 
replace rat_vote = 0   if bruttoincome >bruttoincome_mean
replace rat_vote = 50  if bruttoincome==bruttoincome_mean
replace rat_vote = 100 if bruttoincome <bruttoincome_mean

label define rat_lb 0 "0%" 50 "indifferent" 100 "100%" 
label values rat_vote rat_lb 
label var rat_vote "Rational vote"

tab rat_vote, gen(rat_vote)

gen ginc_d = bruttoincome-bruttoincome_mean 

gen ginc_ln = ln(bruttoincome/bruttoincome_mean)

*********************************
*** Signaling Hypothesis ********
*********************************

*** Was the low rate guy very diligent (fleißig)

gen                  correct_r3    = .
replace              correct_r3    = correct if rate==3
bysort groupid: egen correct_r3_gr = sum(correct_r3)

* je mehr desto fleißiger war der low rate guy -> wenn signal matters -> higher tax
gen R3_perf = correct_r3_gr - correct 

*** was the high rate guy very diligent (fleißig)

gen                  correct_r9    = .
replace              correct_r9    = correct if rate==9
bysort groupid: egen correct_r9_gr = sum(correct_r9)

* je mehr desto fleißiger war der high rate guy -> wenn signal matters -> lower tax
gen R9_perf = correct_r3_gr - correct 


gen decision01 = decision/100

*** Linos

recode linos_b 1=5 2=4 3=3 4=2 5=1 , gen(linos_br) 
recode linos_h 1=5 2=4 3=3 4=2 5=1 , gen(linos_hr) 
recode linos_i 1=5 2=4 3=3 4=2 5=1 , gen(linos_ir) 

gen linos = linos_br +linos_hr +linos_ir 
gen merit01 = (linos-3)/12
label var merit01 "Preference for the Merit Principle "

********************************************************************************
*** Analysis   *****************************************************************
********************************************************************************

* Fig. 1 (Descriptive (Test Rate on Effort and Gross Income)) 
twoway kdensity  correct      if rate==3 & sample01==1 || kdensity  correct      if rate==6 & sample01==1 || kdensity  correct      if rate==9 & sample01==1, legend(order(1 "Low" 2 "Medium" 3 "High") rows(1) position(6)) xtitle("Correctly solved tasks") ytitle("Density")
graph save fig0a.gph, replace
twoway kdensity  bruttoincome if rate==3 & sample01==1 || kdensity  bruttoincome if rate==6 & sample01==1 || kdensity  bruttoincome if rate==9 & sample01==1, legend(order(1 "Low" 2 "Medium" 3 "High") rows(1) position(6)) xtitle("Gross income") ytitle("Density")
graph save fig0b.gph, replace

graph combine fig0a.gph fig0b.gph, xsize(4) ysize(2) 
* graph save fig0.gph, replace
* graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig0.png", as(png) replace



* Regression Analysis (Model 1a 2a 3a)
tsset id period
fvset base 0  rat_vote
fvset base 1  treat03
fvset base 1  treat04

fracreg logit   decision01 i.treat03 i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
est store m1_ind
fracreg logit   decision01 i.treat03##c.leftright i.rat_vote          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
est store m2_ind
fracreg logit   decision01 i.treat04 i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
est store m3_ind
fracreg logit   decision01 i.treat03##c.merit01   i.rat_vote          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
est store m4_ind

esttab m1_ind m2_ind m3_ind m4_ind using tab_ind.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels

*** Test Treat on LR

twoway kdensity  leftright      if treat03==1  || kdensity  leftright      if treat03==3 || kdensity leftright      if treat03==3, legend(order(1 "Earned" 2 "Random" 3 "Equal") rows(1) position(6)) xtitle("Right-Left Scale") ytitle("Density")

graph box leftright, over(treat03)
graph save fig_lr.gph, replace
graph box merit01, over(treat03)
graph save fig_mer.gph, replace
graph combine fig_lr.gph fig_mer.gph, xsize(4) ysize(2)


tabstat leftright, by(treat03)

reg leftright i.treat03  age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)



*** Robustness Test: LR on split samples (earned vs. random)

*** Es fehllen Obs weil Liebig nicht immer erfragt wurde WTF MAX!
*** Linos fehlt in 3 von insg. 19 sessions


fracreg logit   decision01  i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment==1 , vce(cluster id)
est store m1_sp
fracreg logit   decision01  i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment==2 , vce(cluster id)
est store m2_sp
fracreg logit   decision01  i.rat_vote           c.leftright age fem sem study1 study3 study4 study5       i.period if treatment==3 , vce(cluster id)
est store m3_sp
fracreg logit   decision01  i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment==4 , vce(cluster id)
est store m4_sp
fracreg logit   decision01  i.rat_vote           c.leftright age fem sem study1 study3 study4 study5       i.period if treatment==5 , vce(cluster id)
est store m5_sp

fracreg logit   decision01  i.rat_vote           c.merit01   age fem sem study1 study3 study4 study5 i.lab i.period if treatment==1 , vce(cluster id)
est store m1_sp2
fracreg logit   decision01  i.rat_vote           c.merit01   age fem sem study1 study3 study4 study5 i.lab i.period if treatment==2 , vce(cluster id)
est store m2_sp2
fracreg logit   decision01  i.rat_vote           c.merit01   age fem sem study1 study3 study4 study5       i.period if treatment==3 , vce(cluster id)
est store m3_sp2
fracreg logit   decision01  i.rat_vote           c.merit01   age fem sem study1 study3 study4 study5 i.lab i.period if treatment==4 , vce(cluster id)
est store m4_sp2
fracreg logit   decision01  i.rat_vote           c.merit01   age fem sem study1 study3 study4 study5       i.period if treatment==5 , vce(cluster id)
est store m5_sp2

esttab m1_sp m2_sp m3_sp m4_sp m5_sp m1_sp2 m2_sp2 m3_sp2 m4_sp2 m5_sp2 using tab_sp.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels

*M1 Earned info
*M2 Random info
*M3 Earned no info
*M4 Random no info
*M5 Equal



**** IA Plots for Individual Level Analysis

* Rational cat

fracreg logit   decision01 i.treat03 i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
margins i.rat_vote,  level(95)
marginsplot, recast(scatter) title(Individual, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) xtitle(Ego. preference, size(medsmall))
graph save fig1_ind.gph, replace

* Treat 03

fracreg logit   decision01 i.treat03 i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
margins i.treat03,  level(95)
marginsplot, recast(scatter) title(Individual, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) xtitle(Treatment, size(medium))
graph save fig2_ind.gph, replace

* Treat 03 x LR 

fracreg logit   decision01 i.treat03##c.leftright i.rat_vote          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
margins i.treat03, at(c.leftright = (0(.1)1)) level(95)
marginsplot,  title(Individual, size(medium))  ytitle(Conditional mean of tax decision, size(medium)) legend( rows(1) position(6))
*gr save fig3_ind.gph, replace


* Treat 03 x Merit01 

fracreg logit   decision01 i.treat03##c.merit01 i.rat_vote          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
margins i.treat03, at(c.merit01 = (0(.1)1)) level(95)
marginsplot,  title(Individual, size(medium))  ytitle(Conditional mean of tax decision, size(medium))  legend( rows(1) position(6))
*gr save fig5_ind.gph, replace


* Treat 04

fracreg logit   decision01 i.treat04 i.rat_vote           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
margins i.treat04,  level(95)
marginsplot, recast(scatter) title(Individual, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) xtitle(Treatment) xlabel(, angle(45))
graph save fig4_ind.gph, replace

save data_raw,replace


**************************************************
**** Effect of Pay Rate on Effort by Treatment ***
**************************************************

save data_fig, replace
use data_fig.dta, clear

xtreg correct i.treat03  i.rate  c.leftright age fem sem study1 study3 study4 study5 i.lab i.period  , vce(cluster id)
est store m1_null

** earned
xtreg correct i.rate  c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat03==1 , vce(cluster id)
est store m1_ue
margins i.rate,  level(90)
marginsplot, title("Unequal earned") ytitle(Predicted) xtitle(Rate)
graph save fig1_corr.gph, replace
** random 
xtreg correct i.rate  c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat03==2 , vce(cluster id)
est store m1_ur
margins i.rate,  level(90)
marginsplot, title("Unequal random") ytitle(Predicted) xtitle(Rate)
graph save fig3_corr.gph, replace
** equal 
xtreg correct i.rate  c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat03==3 , vce(cluster id)
est store m1_eq
margins i.rate,  level(90)
marginsplot, title("Equal") ytitle(Predicted) xtitle(Rate)
graph save fig2_corr.gph, replace

graph combine fig1_corr.gph fig2_corr.gph fig3_corr.gph, ycommon row(1)  xsize(4) ysize(2) 
graph save fig_corr.gph, replace
*graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig_bar.png", as(png) replace

esttab m1_null m1_ue  m1_eq m1_ur using tab_corr.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) scalars(r2 r2_a r2_w r2_o r2_b)  nogaps replace label  nobaselevels

*** Figure 2 Main Text

drop if treat03==.
collapse (mean) meancor= correct (sd) sdcor=correct (count) n=correct, by(rate treat03)
generate hicor = meancor + invttail(n-1,0.025)*(sdcor / sqrt(n))
generate lowcor = meancor - invttail(n-1,0.025)*(sdcor / sqrt(n))
 
 *graph twoway (bar meancor rate) (rcap hicor lowcor rate), by(treat03) 
 
graph twoway (bar meancor rate if treat03==1, xtitle(Rate) xlabel(3 "Low" 6 "Medium" 9 "High") title(Unequal earned) legend(off)) (rcap hicor lowcor rate if treat03==1) 
graph save bar1.gph, replace
 
graph twoway (bar meancor rate if treat03==2, xtitle(Rate) xlabel(3 "Low" 6 "Medium" 9 "High") title(Unequal random) legend(off)) (rcap hicor lowcor rate if treat03==2)
graph save bar2.gph, replace
 
graph twoway (bar meancor rate if treat03==3, xtitle(Rate) xlabel(3 "Low" 6 "Medium" 9 "High") title(Equal)          legend(off)) (rcap hicor lowcor rate if treat03==3)
graph save bar3.gph, replace
 
graph combine bar2.gph bar3.gph bar1.gph, ycommon xcommon row(1) xsize(4) ysize(2)
* graph save bar_corr.gph, replace
*graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig_bar.png", as(png) replace




********************************************************************************************************************************
**** Collapse *** Group level analysis *****************************************************************************************
********************************************************************************************************************************

use data_raw.dta, clear



collapse sessionid ///
         decision decision01 correct bruttoincome ///
		 treatment treat01 treat03 treat04 ///
		 rat_vote ginc_d ///
		 lab period ///
		 R3_perf  R9_perf  ///
		 study1 study3 study4 study5 merit01 ///
		 age fem sem leftright , by(groupid)

		 
save group_data, replace
use "group_data.dta", clear	
		 
label define treat03_lb 1 "Unequal Earned" 2 "Unequal Random" 3 "Equal"
label values treat03 treat03_lb 	 
	
label define treat04_lb 1 "Unequal Earned" 2 "Unequal Random" 3 "Unequal Earned (no info)" 4 "Unequal Random (no info)" 
label values treat04 treat04_lb 
	
gen rat_vote_cat = .
replace rat_vote_cat = 1 if rat_vote>=  33.33333
replace rat_vote_cat = 2 if rat_vote==  50
replace rat_vote_cat = 3 if rat_vote>=  66.66666

label define rat_vote_cat_lb 1 "Tax 33%" 2 "Tax 50%" 3 "Tax 66%"  
label values rat_vote_cat rat_vote_cat_lb 

label var decision "Average group Decision" 
label var lab "Subject pool"
label var period "Period"
label var leftright "Right Left"
label var age "Age"
label var fem "Female"
label var merit01 "Preference for the Merit Principle "



* Regression Analysis

fvset base 1  treat03
fvset base 1  treat04
fvset base 1  rat_vote_cat


* Regression Analysis M1b M2b M3b

tsset groupid period
fvset base 0  rat_vote
fvset base 1  treat03
fvset base 1  treat04

fracreg logit   decision01 i.treat03 i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
est store m1_gr
fracreg logit   decision01 i.treat03##c.leftright i.rat_vote_cat          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
est store m2_gr
fracreg logit   decision01 i.treat04 i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
est store m3_gr
fracreg logit   decision01 i.treat03##c.merit01 i.rat_vote_cat            age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
est store m4_gr



esttab m1_gr m2_gr m3_gr m4_gr using tab_gr.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


*** Final Reg Tab
esttab m1_ind m1_gr m2_ind m2_gr m4_ind m4_gr using tab_both.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


*** Appendix Tab on IA
esttab m3_ind m3_gr using tab_merit.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels



*** Robustenss Test: LR on split samples (earned vs random) 



fracreg logit   decision01  i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment==1 , vce(cluster groupid)
est store m1g_sp
fracreg logit   decision01  i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment==2 , vce(cluster groupid)
est store m2g_sp
fracreg logit   decision01  i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5       i.period if treatment==3 , vce(cluster groupid)
est store m3g_sp
fracreg logit   decision01  i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment==4 , vce(cluster groupid)
est store m4g_sp
fracreg logit   decision01  i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5       i.period if treatment==5 , vce(cluster groupid)
est store m5g_sp


fracreg logit   decision01  i.rat_vote_cat           c.merit01   age fem sem study1 study3 study4 study5 i.lab i.period if treatment==1 , vce(cluster groupid)
est store m1g_sp2
fracreg logit   decision01  i.rat_vote_cat           c.merit01   age fem sem study1 study3 study4 study5 i.lab i.period if treatment==2 , vce(cluster groupid)
est store m2g_sp2
fracreg logit   decision01  i.rat_vote_cat           c.merit01   age fem sem study1 study3 study4 study5       i.period if treatment==3 , vce(cluster groupid)
est store m3g_sp2
fracreg logit   decision01  i.rat_vote_cat           c.merit01   age fem sem study1 study3 study4 study5 i.lab i.period if treatment==4 , vce(cluster groupid)
est store m4g_sp2
fracreg logit   decision01  i.rat_vote_cat           c.merit01   age fem sem study1 study3 study4 study5       i.period if treatment==5 , vce(cluster groupid)
est store m5g_sp2

esttab m1_sp  m1g_sp  m2_sp  m2g_sp  m5_sp  m5g_sp m1_sp2 m1g_sp2 m2_sp2 m2g_sp2 m5_sp2 m5g_sp2 using tab_sp_new.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels


***






*** IA Effect Plot with group averages


* Rational cat

fracreg logit   decision01 i.treat03 i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
margins i.rat_vote_cat,  level(95)  
marginsplot, recast(scatter) title(Group, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) xtitle(Ego. preference, size(medium))
graph save fig1_gr.gph, replace

* Treat 03

fracreg logit   decision01 i.treat03 i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
margins i.treat03,  level(95)
marginsplot, recast(scatter) title(Group, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) xtitle(Treatment, size(medium))
graph save fig2_gr.gph, replace

* Treat 03 x LR 

fracreg logit   decision01 i.treat03##c.leftright i.rat_vote_cat          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
margins i.treat03, at(c.leftright = (0(.1)1)) level(95)
marginsplot,  title(Group, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) legend( rows(1) position(6))
*gr save fig3_gr.gph, replace

* Treat 03 x Merit01 

fracreg logit   decision01 i.treat03##c.merit01 i.rat_vote_cat          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
margins i.treat03, at(c.merit01 = (0(.1)1)) level(95)
marginsplot,  title(Group, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) legend( rows(1) position(6))
*gr save fig5_gr.gph, replace

* Treat 04

fracreg logit   decision01 i.treat04 i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
margins i.treat04,  level(95)
marginsplot, recast(scatter) title(Group, size(medium)) ytitle(Conditional mean of tax decision, size(medium)) xtitle(Treatment, size(medium)) xlabel(, angle(45))
graph save fig4_gr.gph, replace






*** Combine figures

graph combine fig1_ind.gph fig1_gr.gph, ycommon  xsize(4) ysize(2)  
graph save fig1.gph, replace
graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig1.png", as(png) replace

graph combine fig2_ind.gph fig2_gr.gph, ycommon  xsize(4) ysize(2) 
graph save fig2.gph, replace
graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig2.png", as(png) replace

graph combine fig3_ind.gph fig3_gr.gph, ycommon  xsize(4) ysize(2) 
graph save fig3.gph, replace
graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig3.png", as(png) replace

graph combine fig5_ind.gph fig5_gr.gph, ycommon  xsize(4) ysize(2) 
graph save fig5.gph, replace
graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig5.png", as(png) replace

graph combine fig4_ind.gph fig4_gr.gph, ycommon  xsize(4) ysize(2) 
graph save fig4.gph, replace
graph export "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Heterogeneous Productivity\Text\img\fig4.png", as(png) replace







********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************

*** OLD STUFF ***

********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************













fracreg logit   decision01 i.treat03 i.rat_vote_cat           c.leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
est store m1_gr

fracreg logit   decision01 i.treat03##c.leftright i.rat_vote_cat          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
est store m2_gr

esttab m1_ind m1_gr m2_ind m2_gr  using tab1.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) pr2 aic bic nogaps replace label  nobaselevels





fracreg logit   decision01 i.treat03##c.leftright i.rat_vote_cat          age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster groupid)
margins i.treat03, at(c.leftright = (0(.1)1)) level(90)
marginsplot,  title(Individual)
gr save fig_ginc2.gph, replace



*** Main
fracreg logit   decision01 i.treat03 i.rat_vote_cat         leftright age fem sem study1 study3 study4 study5 i.lab i.period 
est store m1g
*fracreg logit   decision01 i.treat01 i.rat_vote_cat R3_perf leftright age fem sem study1 study3 study4 study5 i.lab i.period 
*est store m2g
*fracreg logit   decision01 i.treat01 i.rat_vote_cat R9_perf leftright age fem sem study1 study3 study4 study5 i.lab i.period 
*est store m3g

*** Robust
fracreg logit   decision01 i.treat04 i.rat_vote_cat         leftright age fem sem study1 study3 study4 study5 i.lab i.period 
est store m2g

esttab m1g m2g using tab2.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label





* Fig. 3 Main Treatment Effect 

fracreg logit   decision01 i.treat03 i.rat_vote_cat         leftright age fem sem study1 study3 study4 study5 i.lab i.period 
margins i.treat03,  level(90)
marginsplot, title(Group)
graph save fig2a.gph, replace

fracreg logit   decision01 i.treat03 i.rat_vote_cat         leftright age fem sem study1 study3 study4 study5 i.lab i.period 
margins i.rat_vote_cat,  level(90)
marginsplot, title(Group)
graph save fig2b.gph, replace

fracreg logit   decision01 i.treat04 i.rat_vote_cat         leftright age fem sem study1 study3 study4 study5 i.lab i.period 
margins i.treat04,  level(90)
marginsplot, title(Group)
graph save fig2c.gph, replace






*** Mirco and Group
/*
graph combine fig1a.gph fig2a.gph, ycommon
graph save fig1_fin.gph, replace

graph combine fig1b.gph fig2b.gph, ycommon
graph save fig2_fin.gph, replace

graph combine fig1c.gph fig2c.gph, ycommon
graph save fig2_fin.gph, replace

graph combine fig_ginc1.gph fig_ginc2.gph, ycommon col(1) xsize(2) ysize(4)
graph save fig4_fin.gph, replace
*/










** neo neu 


fracreg logit  decision01 i.treat03 c.ginc_d leftright age fem sem i.lab i.period , vce(cluster id)
margins, at(ginc_d==(-313(50)413))
marginsplot, xline(0)
gr save fig5a.gph, replace


*** Interaction 

fracreg logit  decision01 c.ginc_d##i.treat03  leftright age fem sem study1 study3 study4 study5 i.lab i.period , vce(cluster id)
margins i.treat03, at(c.ginc_d = (-313(50)413)) level(90)
marginsplot, xline(0) title(treat)
gr save fig6a.gph, replace









********************************************************************************************************************************
********************************************************************************************************************************
********************************************************************************************************************************






*************
*** TRASH ***
*************



** Income position [Creates a simple ordinal rank of income position | 1 = poor | 2 = mid | 3 = rich]
bysort sessionid period group: egen income_position = rank(bruttoincome), track

twoway (scatter decision diff if rate==9 & income_position==3) (lfit decision diff if rate==9 & income_position==3)
twoway (scatter decision diff if rate==6 & income_position==2) (lfit decision diff if rate==6 & income_position==2)





xtreg decision i.treat01 i.rat_vote diff leftright age fem sem study1 study3 study4 study5 i.lab i.period , re robust



*** treat01 2=random

xtreg decision diff  i.income_position leftright if rate!=3 & income_position>=2 & treat01 ==1, re robust
xtreg decision diff  i.income_position leftright if rate!=3 & income_position>=2 & treat01 ==2, re robust

xtreg decision diff  i.income_position leftright if  income_position==2 & rate==6 & treat01 ==2, re robust
xtreg decision diff  i.income_position leftright if  income_position==3 & rate==9 & treat01 ==2, re robust


xtreg decision i.treat01 i.rat_vote diff leftright if income_position2 , re robust





***************************************************************************************************************
*** trash *****************************************************************************************************
***************************************************************************************************************

xtreg decision i.treat01 i.rat_vote diff leftright age fem sem study1 study3 study4 study5 i.lab i.period if rate==6, re robust

xtreg decision i.treat01 i.rat_vote diff leftright age fem sem study1 study3 study4 study5 i.lab i.period if rate==9, re robust


xtreg decision   diff leftright  if rate==9 & treat01==2, re robust






















fvset base 1 treatment
fvset base 6 rate


fvset base 2 income_position
fvset base 2 effort_position











**** OLD STUFF ****

*** Rational group choice

sort groupid
by groupid: egen rat_vote3_sum = sum(rat_vote3)
gen     pred_group100 = 0
replace pred_group100 = 1 if rat_vote3_sum >=2




*** CODING POOR HIGH EFFORT
** Income position [Creates a simple ordinal rank of income position | 1 = poor | 2 = mid | 3 = rich]
bysort sessionid period group: egen income_position = rank(bruttoincome), track

*** Effort position [Creates a simple ordinal rank of effort position | 1 = low | 2 = mid | 3 = high]
bysort sessionid period group: egen effort_position = rank(correct), track



* Test doppelte rangplätze
bysort groupid: egen income_position_test = sum(income_position)
bysort groupid: egen effort_position_test = sum(effort_position)

keep if  income_position_test==6
keep if  effort_position_test==6


******************** Focus is on rate *******************

gen rate3_effort_high = 0
replace rate3_effort_high = 1 if effort_position==3 & rate==3
bysort groupid: egen rate3_effort_high_g = sum(rate3_effort_high)


gen rate9_effort_low = 0
replace rate9_effort_low = 1 if effort_position==1 & rate==9
bysort groupid: egen rate9_effort_low_g = sum(rate9_effort_low)

************************************************************

* Undeserving poor

gen poor_effort_high = 0
replace poor_effort_high = 1 if effort_position==3 & income_position==1
bysort groupid: egen poor_effort_high_g = sum(poor_effort_high)

* Deserving poor

gen poor_effort_low = 0
replace poor_effort_low = 1 if effort_position==1 & income_position==1
bysort groupid: egen poor_effort_low_g = sum(poor_effort_low)
replace poor_effort_low_g = 1 if poor_effort_low_g==2

* Undeserving rich

gen rich_effort_low = 0
replace rich_effort_low = 1 if effort_position==1 & income_position==3
bysort groupid: egen rich_effort_low_g = sum(rich_effort_low)

* Deserving rich

gen rich_effort_high = 0
replace rich_effort_high = 1 if effort_position==3 & income_position==3
bysort groupid: egen rich_effort_high_g = sum(rich_effort_high)


*** Effort Matrix

gen just = 0
replace just = 1 if effort_position==income_position
bysort groupid: egen just_g = sum(just)

gen just_group = 0
replace just_group = 1 if just_g==3


*** Effort von M1 und M3 kategorial

gen M1_effort = 0
replace M1_effort = effort_position if income_position==1
bysort groupid: egen M1_effort_g = sum(M1_effort)

gen M2_effort = 0
replace M2_effort = effort_position if income_position==2
bysort groupid: egen M2_effort_g = sum(M2_effort)

gen M3_effort = 0
replace M3_effort = effort_position if income_position==3
bysort groupid: egen M3_effort_g = sum(M3_effort)

*drop if M2_effort_g==0
*drop if M2_effort_g==4
*drop if M3_effort_g==0


*** Rob ana
tab treatment, gen(treat)


**** Focus on rate 

gen r3_effort = .
replace r3_effort = effort_position if rate==3
bysort groupid: egen r3_effort_g = sum(r3_effort)
replace r3_effort_g = . if r3_effort_g==0

gen r9_effort = .
replace r9_effort = effort_position if rate==9
bysort groupid: egen r9_effort_g = sum(r9_effort)
replace r9_effort_g = . if r9_effort_g==0



*** Micro and Group

esttab m3 m4 m1c m2c m3g m4g using tab_final.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label





*** Regression Final Tab

xtreg   decision i.treat_cut                                                                                    , re robust
estimate store m1
xtreg   decision i.treat_cut  i.rat_vote                                                                  , re robust
estimate store m2
xtreg   decision i.treat_cut  i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period , re robust
estimate store m3
esttab m1 m2 m3  using tab_B.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label


*xtreg   decision i.treatment i.rate i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period , re robust
*xtmixed decision i.treatment i.rate i.rat_vote age fem sem study1 study3 study4 study5 i.lab|| group: || id: , mle
* xtreg   decision i.treatment i.effort_position##i.income_position i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period , re robust


reg decision i.treatment if treatment!=5
margins i.treatment,  level(95)
marginsplot, title(Average tax rate)
graph save avtax, replace


xtreg   decision i.treatment  i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period if treatment!=5      , re robust
estimate store m0
xtreg   decision i.treatment  i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat1==1|treat2==1, re robust
estimate store m1
xtreg   decision i.treatment  i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat1==1|treat3==1, re robust
estimate store m2
xtreg   decision i.treatment  i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat1==1|treat4==1, re robust
estimate store m3
xtreg   decision i.treatment  i.rat_vote leftright age fem sem study1 study3 study4 study5 i.lab i.period if treat1==1|treat5==1, re robust
estimate store m4
esttab m0 m1 m2 m3  m4 using tab_B_rob.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label


*************************************
*** Test effect of rate on effort ***
*************************************

xtreg correct i.treatment  i.rate  leftright age fem sem study1 study3 study4 study5 i.lab i.period , re robust

xtreg correct i.treatment##i.rate  leftright age fem sem study1 study3 study4 study5 i.lab i.period , re robust



	
*******************************************
**** Collapse *** Group level analysis ****
*******************************************

collapse sessionid  ///
         decision groupdecision ///
		 treatment treat_cut earned inform ///
 		 correct bruttoincome_sum bruttoincome_mean range bruttoincome_min bruttoincome_max  ///
		 pred_group100 rat_vote lab period ///
		 rate3_effort_high_g rate9_effort_low_g ///
		 r3_effort_g r9_effort_g ///
		 poor_effort_high_g ///
		 poor_effort_low_g ///
		 rich_effort_low_g ///
		 rich_effort_high_g ///
		 M1_effort_g M2_effort_g  M3_effort_g  ///
		 age fem sem leftright , by(groupid)

* replace deserved_poor = 0 if deserved_poor ==.5

*label define treat_lb 1 "Random info" 2 "Earned info" 3 "Random no info" 4 "Earned no info"
label values treatment treat_lb 
label values treat_cut treat_cut_lb 

*gen poor_high_effort = 0
*replace poor_high_effort = 1 if poor_effort_g==3

*gen rich_low_effort = 0
*replace rich_low_effort  = 1 if rich_effort_g==1

gen rat_vote_cat = .
replace rat_vote_cat = 1 if rat_vote>=  33.33333
replace rat_vote_cat = 2 if rat_vote==  50
replace rat_vote_cat = 3 if rat_vote>=  66.66666


recode r3_effort_g 1=0 2=1 3=1, gen(rate3_over) 
recode r9_effort_g 1=1 2=1 3=0, gen(rate9_under) 


label var groupdecision "Group decision"
label var decision "Average group Decision" 
label var treatment "Treatment condition"
label var treat_cut "Treatment condition"
label var pred_group100 "Rational 100" 
label var lab "Subject pool"
label var period "Period"
label var leftright "Right Left"
label var age "Age"
label var fem "Female"

*************************
drop if rat_vote_cat==2
*************************

*** Regression analysis

fvset base 1 treatment
fvset base 1 treat_cut
fvset base 1 M1_effort_g
fvset base 1 M2_effort_g
fvset base 1 M3_effort_g

fvset base 0 earned 
fvset base 0 inform


fvset base 1 r3_effort_g 
fvset base 3 r9_effort_g

*** Figure 1 & 2

reg  decision i.treat_cut                 , cluster(groupid)
margins i.treat_cut,  level(95)
marginsplot, title(Average tax rate)
graph save main_effect, replace


reg  decision i.rat_vote_cat                 , cluster(groupid)
margins i.rat_vote_cat,  level(95)
marginsplot, title(Average tax rate)
graph save rat_pred, replace



reg  correct i.treat_cut                  , cluster(groupid)
margins i.treat_cut,  level(95)
marginsplot, title(Average number of correct tasks)
graph save avtax2, replace



*** Regression Main Finding

reg  decision               i.rat_vote_cat   if  treat_cut==1|treat_cut==2|treat_cut==3, cluster(groupid)
estimate store m1
reg  decision i.treat_cut   i.rat_vote_cat                                               , cluster(groupid)
estimate store m2
reg  decision i.treat_cut   i.rat_vote_cat   leftright age fem i.lab i.period            , cluster(groupid)
estimate store m3
esttab m1 m2 m3 using tab_A.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label


*** Effort compensation storry (only für unequal info)

reg  decision  i.treat_cut i.rat_vote_cat  i.r3_effort_g i.r9_effort_g leftright age fem i.lab i.period if treat_cut!=3, cluster(groupid)
estimate store m4
reg  decision              i.rat_vote_cat  i.r3_effort_g i.r9_effort_g leftright age fem i.lab i.period if treat_cut==1, cluster(groupid)
estimate store m5
reg  decision              i.rat_vote_cat  i.r3_effort_g i.r9_effort_g leftright age fem i.lab i.period if treat_cut==2, cluster(groupid)
estimate store m6
esttab m1 m2 m3 m4 m5 m6 using tab_A.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label










*** PLot deserv story

reg  decision  i.treat_cut i.rat_vote_cat  i.r3_effort_g i.r9_effort_g leftright age fem i.lab i.period if treat_cut!=3, cluster(groupid)
margins i.r3_effort_g,  level(95)
marginsplot, title(Average group tax)
graph save fig_1, replace

reg  decision  i.treat_cut i.rat_vote_cat  i.r3_effort_g i.r9_effort_g leftright age fem i.lab i.period if treat_cut!=3, cluster(groupid)
margins i.r9_effort_g,  level(95)
marginsplot, title(Average group tax)
graph save fig_2, replace

graph combine fig_1.gph fig_2.gph
graph save deserv, replace




*** Probing Deeper

tab treatment, gen(treat)

reg  decision ii.treatment  i.rat_vote_cat  leftright age fem i.lab i.period if treatment!=5    , cluster(groupid)
margins i.treatment,  level(95)
marginsplot, title(Average tax rate)
graph save robust, replace


reg  decision i.treatment  i.rat_vote_cat  leftright age fem i.lab i.period                        , cluster(groupid)
estimate store m0
reg  decision i.treatment  i.rat_vote_cat  leftright age fem i.lab i.period if treat1==1|treat2==1 , cluster(groupid)
estimate store m1
reg  decision i.treatment  i.rat_vote_cat  leftright age fem i.lab i.period if treat1==1|treat3==1 , cluster(groupid)
estimate store m2
reg  decision i.treatment  i.rat_vote_cat  leftright age fem i.lab i.period if treat1==1|treat4==1 , cluster(groupid)
estimate store m3
reg  decision i.treatment  i.rat_vote_cat  leftright age fem i.lab i.period if treat1==1|treat5==1 , cluster(groupid)
estimate store m4
esttab m0 m1 m2 m3 m4 using tab_A_rob.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label





***********************
*** CRAP **************
***********************








*** Best shot!

reg  groupdecision i.treatment ///
                   i.poor_effort_high_g  i.rich_effort_low_g ///
				   i.poor_effort_low_g   i.rich_effort_high_g ///
				   i.pred_group100  i.lab i.period leftright , cluster(groupid)

*** no good weil wir auf den median voter focussieren... 
				   
reg  decision      i.treatment ///
                   i.poor_effort_high_g  i.rich_effort_low_g ///
				   i.poor_effort_low_g   i.rich_effort_high_g ///
				   i.pred_group100  i.lab i.period leftright , cluster(groupid)

		
		
reg  decision      i.treatment i.poor_effort_high_rate3g ///
                   leftright rat_vote i.lab i.period, cluster(groupid)
				   
				   
****************************
*** Additional Regessions **
****************************


** m5 und m6 noch nicht diskutieren
reg  groupdecision i.treatment##i.poor_high_effort                   i.pred_group100 i.lab i.period  , cluster(groupid)
estimate store m5
reg  groupdecision i.treatment##i.rich_low_effort                   i.pred_group100 i.lab i.period  , cluster(groupid)
estimate store m6


* Regression

reg  groupdecision i.treatment i.poor_high_effort  i.pred_group100 i.lab i.period  , cluster(groupid)
reg  groupdecision i.treatment##i.poor_high_effort i.pred_group100 i.lab i.period  , cluster(groupid)


*** Aditional Tests

reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==1, cluster(sessionid)
reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==2, cluster(sessionid)
reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==3, cluster(sessionid)
reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==4, cluster(sessionid)

reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==1, cluster(groupid)
reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==2, cluster(groupid)
reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==3, cluster(groupid)
reg  groupdecision  i.poor_high_effort i.pred_group100 i.lab i.period if treat==4, cluster(groupid)






***********************************************************************************

***********************************************************************************

***********************************************************************************

***********************************************************************************

***********************************************************************************

***********************************************************************************



****************
*** OLD CODE ***
****************

*** Lazy


** mean performance [Just a simple step to simplify the process]
*bysort groupid: egen median_correct = median(correct)

** Types 

* Initialization 
*gen deserved_poor = . 
*gen deserved_rich = .

/* Let's assume: 
- If you are poor and worked little, you deserve poverty
- If you are rich and worked a lot, you deserve wealth 
- If you are poor and worked hard, you DON'T deserve poverty
- If you are rich and worked litttle, you DON'T deserve wealth

Notice: I operationalized high performance in relation to the overall mean (In the data mean and median are equal). 
So, you worked a lot if you worked more than average and vice versa. This could be reconsidered, I guess. 
However, I don't think comparing group members with respect to performance is a good idea, because 
individual performance would be biased by average group performance
*/ 
* Deserved level of income: 
*replace deserved_poor = 1 if incomeposition == 1 & correct < median_correct // INCOME LOW & PERFORMANCE LOW 
*replace deserved_rich = 1 if incomeposition == 3 & correct > median_correct // INCOME HIGH & PERFORMANCE HIGH 
* Undeserved level of income: 
*replace deserved_poor = 0 if incomeposition == 1 & correct >= median_correct // INCOME LOW & PERFORMANCE HIGH 
*replace deserved_rich = 0 if incomeposition == 3 & correct <= median_correct // INCOME HIGH & PERFORMANCE LOW 

/* Notice: This is basically the interaction of legitimation of income level and income level. Interpretation is 
probably easier if poor and rich are generated seperately. */

/*We need to a assign the legitimacy of the poor/rich player in each group to the respective other two players
Of course, we could exclude the median voter from this model.  For now this is the perspective of the two
OTHER group members  */
*egen legitimate_poor = max(deserved_poor), by(groupid) 
*egen legitimate_rich = max(deserved_rich), by(groupid) 

* Exclude self from  information about groups poor/rich player
/* replace legitimate_poor = . if incomeposition == 1
replace legitimate_rich = . if incomeposition == 3
*/ 


*** Poor aber high effort

gen poor_effort = effort_position if income_position == 1
replace poor_effort = 0 if poor_effort==.

bysort groupid: egen poor_effort_g = sum(poor_effort)
label define effort_lb 1 "low" 2 "medium" 3 "high" 
label values poor_effort_g effort_lb 

gen poor_effort_high = 0
replace poor_effort_high = 1 if poor_effort_g==3


*** Rich aber low effort

gen rich_effort = effort_position if income_position == 3
replace rich_effort = 0 if rich_effort==.

bysort groupid: egen rich_effort_g = sum(rich_effort)

*label define effort_lb 1 "low" 2 "medium" 3 "high" 
label values rich_effort_g effort_lb 

gen rich_effort_low = 0
replace rich_effort_low = 1 if rich_effort_g==1




