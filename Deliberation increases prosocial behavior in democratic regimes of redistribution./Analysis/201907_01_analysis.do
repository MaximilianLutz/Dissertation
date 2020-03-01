/* Analysis of decision time based on Data by previous experiment 
(Tepe, Lutz, 2018) */ 
use "/Users/Max/Nextcloud/Sync/Decision_Time_Project/Analyse/productivity_gg6.dta"
set more off



* Descriptive overview
d 

tab treatment

bysort treatment: sum votingtime

tab ratpred
tab incomeposition ratpred, r

* Value labels

label define ratpred4 0 "Ego. Low" 1 "Ego. High"
label value ratpred ratpred4

label define incomeposition 1 "Poor" 2 "Medium" 3 "Rich"  
label value incomeposition incomeposition

label var votingtime "Votingtime"
label var earned "Earned Productivity (Dummy)"
label var female "Female" 
label var age "Age"
label var pol_selbstein "Right-leaning"

* Regression analysis 

xtset id period 

*Model1
xtreg decision ib2.incomeposition##c.votingtime earned female age pol_selbstein lab
estimates  store m1

*Model2a and Model 2b 
xtreg decision ib2.incomeposition##c.votingtime female age pol_selbstein ib2.study  lab  info if earned==1, re robust
estimates store m2a
xtreg decision ib2.incomeposition##c.votingtime female age pol_selbstein  ib2.study lab info if earned==0, re robust
estimates store m2b

*Model4 
xtreg decision ib2.incomeposition##c.votingtime female age pol_selbstein  ib2.study lab  info ///
ib2.incomeposition##c.linosEquality ib2.incomeposition##c.linosNeed  ///
ib2.incomeposition##c.linosEquity ib2.incomeposition##c.linosEntitlement if earned==1, re robust
estimate store m4

xtreg decision ib2.incomeposition##c.votingtime female age pol_selbstein ib2.study lab   info ///
ib2.incomeposition##c.linosEquality ib2.incomeposition##c.linosNeed  ///
ib2.incomeposition##c.linosEquity ib2.incomeposition##c.linosEntitlement if earned==0, re robust
estimate store m5


esttab m1 m2a m4 m2b m5 using "/Users/Max/Nextcloud/Sync/Decision_Time_Project/Text/Paper/20190601_votingtime_regressions_A.tex", se brackets ///
 star(* .1 ** .05 *** .01)  nogaps noomitted nobaselevels replace label ///
  sca("rho Rho" "sigma_u Sigma U" "sigma_e Sigma E")

 
 * Alternate Regression
 
	 xtset id period 

	 
	*Model1
	xtreg decision ib0.ratpred##c.votingtime earned female age pol_selbstein fos lab, re robust
	estimates  store b1

	*Model2a and Model 2b 
	xtreg decision ib0.ratpred##c.votingtime female age pol_selbstein fos lab if earned==1, re robust
	estimates store b2a
	xtreg decision ib0.ratpred##c.votingtime female age pol_selbstein fos lab if earned==0, re robust
	estimates store b2b

/*	Model4 
	xtreg decision ib0.ratpred##c.votingtime female age pol_selbstein fos lab ///
	i.ratpred##c.linosEquality i.ratpred##c.linosNeed  ///
	i.ratpred##c.linosEquity i.ratpred##c.linosEntitlement if earned==1, re robust
	estimate store b4

	xtreg decision ib0.ratpred##c.votingtime female age pol_selbstein fos lab  ///
	i.ratpred##c.linosEquality i.ratpred##c.linosNeed  ///
	i.ratpred##c.linosEquity i.ratpred##c.linosEntitlement lab if earned==0, re robust
	estimate store b5*/

	
* NEW Linos Regression (Do Subjects with high morality wait longer?) 

xtreg votingtime i.incomeposition linosNeed linosEquality linosEquity linosEntitlement earned female age pol_selbstein

xtreg votingtime ratpred linosNeed linosEquality linosEquity linosEntitlement if earned == 1

xtreg votingtime ratpred linosNeed linosEquality linosEquity linosEntitlement if earned == 0

	esttab b1 b2a b2b using "/Users/Max/Nextcloud/Sync/Decision_Time_Project/20190701_votingtime_regressions_B.tex", se brackets ///
	 star(* .1 ** .05 *** .01)  nogaps noomitted nobaselevels replace label ///
	 sca("rho Rho" "sigma_u Sigma U" "sigma_e Sigma E")
 
 * Fixed effects model
 
 *Model1
xtreg decision i.ratpred##c.votingtime, fe
estimates  store c1

*Model2a and Model 2b 
xtreg decision i.ratpred##c.votingtime  if earned==1, fe 
estimates store c2a
xtreg decision i.ratpred##c.votingtime if earned==0, fe
estimates store c2b

esttab c1 c2a c2b using "/Users/Max/Nextcloud/Sync/Decision_Time_Project/Text/Paper/20190601_votingtime_regressions_C.tex", se brackets ///
 star(* .1 ** .05 *** .01)  nogaps noomitted nobaselevels replace label 
