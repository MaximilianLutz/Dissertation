
*use "C:\Users\Lutz\ownCloud\Sync\FOR2104_Papiere\Voting Mechanism\Daten\20180821_vm_complete.dta", clear 

use "C:\Users\Tepe\ownCloud\Shared\FOR2104_Papiere\Voting Mechanism\Daten\20180821_vm_complete.dta", clear




set more off


gen groupid = (sessionid*1000)+ (period*100)+ group

*** Dep Vars.

* Ideal (raw)

label var ideal "Ideal choice"
label var decision "Vote choice" 
label var groupdecision "Group choice"

recode ideal 0=1 30=2 70=3 100=4, gen(ideal_cat)

label define tax_lb 1 "0 perc." 2 "30 perc." 3 "70 perc." 4 "100 perc."
label values ideal_cat tax_lb 
label var ideal_cat "Ideal choice"

recode decision 0=1 30=2 70=3 100=4, gen(dec_cat)
label values dec_cat tax_lb 
label var dec_cat "Vote choice"

recode groupdecision 0=1 30=2 70=3 100=4 else=., gen(group_cat)
label values group_cat tax_lb 
label var group_cat "Groups choice"

d


***

*histogram ideal        , percent discr by(treatment)
*histogram decision     , percent discr by(treatment)
*histogram groupdecision, percent discr by(treatment)

*** cat 

histogram ideal_cat   , percent discr by(treatment)
graph save  fig1.gph, replace

histogram dec_cat     , percent discr by(treatment)
graph save  fig1.gph, replace

histogram group_cat   , percent discr by(treatment)
graph save fig1.gph, replace



*** Figure 1 ***


histogram ideal_cat     if treatment==1, percent discr title(Majority)
graph save  fig1.gph, replace

histogram ideal_cat     if treatment==2, percent discr title(Consensus) 
graph save  fig2.gph, replace

histogram ideal_cat     if treatment==3, percent discr title(Dictator) 
graph save  fig3.gph, replace

histogram ideal_cat     if treatment==4, percent discr title(Random) 
graph save  fig4.gph, replace

graph combine fig1.gph fig2.gph fig3.gph fig4.gph, ycommon col(1) xsize(2)  ysize(4)
graph save figA.gph, replace



histogram dec_cat     if treatment==1, percent discr title(Majority)
graph save  fig1.gph, replace

histogram dec_cat     if treatment==2, percent discr title(Consensus) 
graph save  fig2.gph, replace

histogram dec_cat     if treatment==3, percent discr title(Dictator) 
graph save  fig3.gph, replace

*histogram dec_cat     if treatment==4, percent discr title(Dictator) 
*graph save  fig4.gph, replace

graph combine fig1.gph fig2.gph fig3.gph, ycommon col(1) xsize(2)  ysize(4)
graph save figB.gph, replace



histogram group_cat     if treatment==1, percent discr title(Majority)
graph save  fig1.gph, replace

histogram group_cat     if treatment==2, percent discr title(Consensus) 
graph save  fig2.gph, replace

histogram group_cat     if treatment==3, percent discr title(Dictator) 
graph save  fig3.gph, replace

histogram group_cat     if treatment==4, percent discr title(Random) 
graph save  fig4.gph, replace


graph combine fig1.gph fig2.gph fig3.gph fig4.gph , ycommon col(1) xsize(2)  ysize(4)
graph save figC.gph, replace


graph combine figA.gph figB.gph figC.gph,  col(3)



*** Satisfaction 

tabstat satisfaction, by(treatment)

graph box satisfaction, over(treatment)

*** Rational 

scatter correct2 correct1

gen dif=  correct2  - correct1
label var dif "Real effort 2 minus real effort 1"

gen eff_reduc = . 
replace eff_reduc = 0 if dif >=0
replace eff_reduc = 1 if dif <0
replace eff_reduc = . if dif==.





histogram dif


***

sort sessionid period group subject

by sessionid period group: egen mean_ginc = mean(correct1)

gen rat_vote = . 
replace rat_vote = 0   if correct1 >mean_ginc
replace rat_vote = 50  if correct1==mean_ginc
replace rat_vote = 100 if correct1 <mean_ginc

label define rat_lb 0 "0 perc." 50 "50 perc." 100 "100 perc." 
label values rat_vote rat_lb 
label var rat_vote "Rational vote"


sort sessionid period group subject


gen netpay =  bruttoincome - pay1 if groupdecision!=999
label var netpay "Net payment"

gen netpay_ln =  (bruttoincome / pay1) if groupdecision!=999
label var netpay_ln "Net payment (rat.)"




* OLD
*gen netpay_cat = . 
*replace netpay_cat = 1 if netpay >=0
*replace netpay_cat = 0 if netpay <0
*replace netpay_cat = . if groupdecision ==999

* NEW
gen netpay_cat = . 
replace netpay_cat = 1 if netpay<0
replace netpay_cat = 2 if netpay==0
replace netpay_cat = 3 if netpay>0
replace netpay_cat = . if groupdecision ==999
label define netpay_catlb 1 "net gain" 2 "same" 3 "net loss" 
label values netpay_cat netpay_catlb 
label var netpay_cat "Net payment"


gen netpay_lost = 0 
replace netpay_lost = netpay if netpay>0
replace netpay_lost = . if groupdecision ==999

gen netpay_win = 0 
replace netpay_win = (netpay*(-1)) if netpay<0
replace netpay_win = . if groupdecision ==999



gen vote_dif = ideal - groupdecision if groupdecision!=999

tab vote_dif

gen vote_dif_cat = .
replace vote_dif_cat = 1 if vote_dif ==-100
replace vote_dif_cat = 1 if vote_dif ==-70
replace vote_dif_cat = 1 if vote_dif ==-40
replace vote_dif_cat = 1 if vote_dif ==-30

replace vote_dif_cat = 2 if vote_dif ==0

replace vote_dif_cat = 3 if vote_dif ==30
replace vote_dif_cat = 3 if vote_dif ==40
replace vote_dif_cat = 3 if vote_dif ==70
replace vote_dif_cat = 3 if vote_dif ==100

label define vote_lb 1 "I wannted lower tax" 2 "Same" 3 "I wannted higher tax" 
label values vote_dif_cat vote_lb 
label var vote_dif_cat "Vote dif."


tab vote_dif_cat, gen(vote_dif_cat)

tab study, gen(stud)

gen grouptax = groupdecision
replace grouptax = . if groupdecision==999

***


twoway (scatter dif netpay if treatment==1) (lfit dif netpay if treatment==1 & netpay<=0) (lfit dif netpay if treatment==1 & netpay>=0)
graph save  fig1.gph, replace

twoway (scatter dif netpay if treatment==2) (lfit dif netpay if treatment==2 & netpay<=0) (lfit dif netpay if treatment==2 & netpay>=0)
graph save  fig2.gph, replace

twoway (scatter dif netpay if treatment==3) (lfit dif netpay if treatment==3 & netpay<=0) (lfit dif netpay if treatment==3 & netpay>=0)
graph save  fig3.gph, replace

graph combine fig1.gph fig2.gph fig3.gph, ycommon xcommon col(1) xsize(2)  ysize(4)


***

twoway (scatter dif vote_dif  if treatment==1) (lfit dif vote_dif  if treatment==1 & vote_dif <=0) (lfit dif vote_dif  if treatment==1 & vote_dif >=0)
graph save  fig1.gph, replace

twoway (scatter dif vote_dif  if treatment==2) (lfit dif vote_dif  if treatment==2 & vote_dif <=0) (lfit dif vote_dif  if treatment==2 & vote_dif >=0)
graph save  fig2.gph, replace

twoway (scatter dif vote_dif  if treatment==3) (lfit dif vote_dif  if treatment==3 & vote_dif <=0) (lfit dif vote_dif  if treatment==3 & vote_dif >=0)
graph save  fig3.gph, replace

graph combine fig1.gph fig2.gph fig3.gph, ycommon xcommon col(1) xsize(2)  ysize(4)


*** NEW *** 24.09.2018

tsset id period

fvset base 4 treatment
fvset base 2 netpay_cat
fvset base 0 grouptax

xtreg satisfaction                     i.netpay_cat##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein, re 
estimates store m1

xtreg satisfaction                     i.netpay_cat##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if netpay_cat!=2 , re 
estimates store m2

xtreg dif                              i.netpay_cat##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein, re 
estimates store m3

xtreg dif                              i.netpay_cat##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if netpay_cat!=2, re 
estimates store m4

esttab m1 m2 m3 m4  using tab_new.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) r2 nogaps replace label


***********************
*** 12.02.2019 ********
***********************

* Two types of Loosers / Winners

* Share of Elec. Win-Loser by Treatment
tab vote_dif_cat treatment, row

* Share of Net Recipient / Net Payer by Treatment
tab netpay_cat treatment, row

* Two Types of Aceptance (Saisfaction / Effort)

* Regressions

tsset id period
fvset base 2 vote_dif_cat

xtreg satisfaction                     c.netpay i.vote_dif_cat i.treatment  age stud1 stud3 stud4 stud5 i.period i.grouptax, re robust
xtreg dif                              c.netpay i.vote_dif_cat i.treatment  age stud1 stud3 stud4 stud5 i.period i.grouptax, re robust

* netpay
xtreg satisfaction                     c.netpay##i.treatment i.vote_dif_cat   age stud1 stud3 stud4 stud5 i.period i.grouptax, re robust
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

xtreg dif                              c.netpay##i.treatment i.vote_dif_cat   age stud1 stud3 stud4 stud5 i.period i.grouptax, re robust
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

* vote
xtreg satisfaction                     c.netpay i.vote_dif_cat##i.treatment  age stud1 stud3 stud4 stud5 i.period i.grouptax, re robust
margins vote_dif_cat#treatment
marginsplot

xtreg dif                              c.netpay i.vote_dif_cat##i.treatment  age stud1 stud3 stud4 stud5 i.period i.grouptax, re robust
margins vote_dif_cat#treatment
marginsplot


**** TEST

* muss die grouptax in das model?
* ja weil effekte konditional
* nein weil vote_cat beinhaltet bereits die grouptax


xtreg    satisfaction                     c.netpay i.vote_dif_cat i.treatment  age stud1 stud3 stud4 stud5 i.period  , re robust

xtmixed  satisfaction                     c.netpay i.vote_dif_cat i.treatment  age stud1 stud3 stud4 stud5 i.period   || groupid:

xtmixed  satisfaction                     c.netpay##i.treatment i.vote_dif_cat   age stud1 stud3 stud4 stud5 i.period   || groupid:
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))


xtmixed  satisfaction                     c.netpay i.vote_dif_cat i.treatment  age stud1 stud3 stud4 stud5 i.period   || groupid: c.netpay


************* TRASH







*** netpay = 0 299 fälle (exclude netpay==0)!

gen netpay0 = netpay
replace netpay0 = . if netpay==0

gen grouptax2 = grouptax
replace grouptax2 = . if grouptax==0


xtreg satisfaction                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 i.period, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

*** higher vs. lower prefered 
*** lr no














***






xtreg satisfaction                     c.netpay_ln##i.treatment i.vote_dif_cat age stud1 stud3 stud4 stud5 pol_selbstein, re robust
margins treatment, at(netpay_ln= (.5(.1)1.5))
marginsplot, xdimensions(at(netpay_ln))

***


xtreg satisfaction                     c.netpay##i.treatment i.grouptax2 age stud1 stud3 stud4 stud5 pol_selbstein, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))


*xtreg satisfaction                     c.netpay0##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein, re 
*margins treatment, at(netpay0= (-50(10)50))
*marginsplot, xdimensions(at(netpay0))


xtreg satisfaction                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==0, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

xtreg satisfaction                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==30, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))


xtreg satisfaction                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==70, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

xtreg satisfaction                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==100, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))


***


xtreg dif                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

xtreg dif                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==30, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

xtreg dif                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==70, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))

xtreg dif                     c.netpay##i.treatment i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==100, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))




***** other bits




***

xtreg satisfaction                     i.vote_dif_cat##i.treatment c.netpay i.vote_dif_cat age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==0, re robust 
margins vote_dif_cat#treatment
marginsplot





***

xtreg dif                     c.netpay##i.treatment i.grouptax2 age stud1 stud3 stud4 stud5 pol_selbstein, re 
margins treatment, at(netpay= (-50(10)50))
marginsplot, xdimensions(at(netpay))


***


xtreg satisfaction                     c.vote_dif##i.treatment i.grouptax netpay age stud1 stud3 stud4 stud5 pol_selbstein, re 
margins treatment, at(vote_dif= (-100(10)100))
marginsplot, xdimensions(at(vote_dif))

xtreg dif                     c.vote_dif##i.treatment i.grouptax netpay age stud1 stud3 stud4 stud5 pol_selbstein, re 
margins treatment, at(vote_dif= (-100(10)100))
marginsplot, xdimensions(at(vote_dif))





***


xtreg satisfaction                     i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==0  , re 
estimates store m1
xtreg satisfaction                     i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==30 , re 
estimates store m2
xtreg satisfaction                     i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==70 , re 
estimates store m3
xtreg satisfaction                     i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==100, re 
estimates store m4

xtreg dif                              i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==0  , re 
estimates store m5
xtreg dif                              i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==30 , re 
estimates store m6
xtreg dif                              i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==70 , re 
estimates store m7
xtreg dif                              i.netpay_cat##i.treatment  age stud1 stud3 stud4 stud5 pol_selbstein if grouptax==100, re 
estimates store m8

esttab m1 m2 m3 m4  m5 m6 m7 m8 using tab_new.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) r2 nogaps replace label

xtreg satisfaction                     i.netpay_cat##i.treatment##i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein, re 
xtreg dif                              i.netpay_cat##i.treatment##i.grouptax age stud1 stud3 stud4 stud5 pol_selbstein, re 





**** FIN

xtlogit eff_reduc      i.vote_dif_cat               c.netpay_lost              c.netpay_win  i.treatment  age fem stud1 stud3 stud4 stud5, re vce(robust)
estimates store m1
xtlogit eff_reduc      i.vote_dif_cat               c.netpay_lost##i.treatment c.netpay_win##i.treatment  age fem stud1 stud3 stud4 stud5, re vce(robust)
estimates store m2
xtlogit eff_reduc      i.vote_dif_cat##i.treatment  c.netpay_lost##i.treatment c.netpay_win##i.treatment  age fem stud1 stud3 stud4 stud5, re vce(robust)
estimates store m3
esttab m1 m2 m3 using tabv1.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) r2 nogaps replace label


****

xtreg satisfaction      i.vote_dif_cat               c.netpay_lost              c.netpay_win  i.treatment  age fem stud1 stud3 stud4 stud5, re 
estimates store m4
xtreg satisfaction      i.vote_dif_cat               c.netpay_lost##i.treatment c.netpay_win##i.treatment  age fem stud1 stud3 stud4 stud5, re 
estimates store m5
xtlogit eff_reduc      i.vote_dif_cat##i.treatment  c.netpay_lost##i.treatment c.netpay_win##i.treatment  age fem stud1 stud3 stud4 stud5, re vce(robust)
estimates store m6
esttab m4 m5 m6 using tabv2.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) r2 nogaps replace label 	


**** TRASH

xtlogit eff_reduc      i.vote_dif_cat                            c.netpay  i.treatment  age fem stud1 stud3 stud4 stud5, re

xtlogit eff_reduc      i.vote_dif_cat##i.treatment               c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re


xtreg dif                     c.vote_dif c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust

xtreg satisfaction            c.vote_dif c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust

xtreg dif                     c.vote_dif##i.treatment c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust

xtreg satisfaction            c.vote_dif##i.treatment c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust




********************************************************

xtreg ideal_cat    i.rat_vote i.treatment age fem, re robust 

xtreg dec_cat      i.rat_vote i.treatment age fem, re robust

xtologit ideal_cat i.rat_vote i.treatment age fem, vce(robust)

xtologit dec_cat   i.rat_vote i.treatment age fem, vce(robust)

*** dif

histogram dif

graph box dif, over(treatment)

xtreg dif i.rat_vote i.treatment age fem, re robust 

***

gen looser = 0
replace looser = 1 if decision != groupdecision
replace looser = . if groupdecision==999

xtreg dif             i.rat_vote i.treatment looser age fem, re robust 

xtreg dif i.group_cat i.rat_vote##i.treatment looser age fem, re robust 

****

xtreg dif                     c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust

xtreg satisfaction            c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust



vote_diff

xtreg dif                     c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust

xtreg satisfaction            c.netpay##i.treatment  age fem stud1 stud3 stud4 stud5, re robust


