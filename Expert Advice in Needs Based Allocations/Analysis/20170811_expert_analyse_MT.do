********************************************************************************
**************************        Zur Analyse:        **************************
*****	Da das Treatment unendlich laufen sollte, sind die 			
*****	regulären Perioden nicht zu gebrauchten. Eine "Periode" ist 
*****	- analysegerecht - abgeschlossen, wenn sich die Gruppe geeinigt 
*****	hat. Dann gilt: numagree = numagree+1. Siehe auch "newperiod" als  
*****	jetzt eigentliche Periodenvariable
*****	
*****	Die Liebig Items stecken in den Linos_* Variablen. 
*****	Sonst: fullinfo 0 = Mitglieder kennen Bedarfe nicht; 1 = zweite Welle 
*****	Variable rep  (für Repetition) ist jetzt verwendbar  und zeigt an,  
*****	wieviele Versuche zur Einigungbenötigt wurden. 
********************************************************************************
********************************************************************************
 
cd "C:\Users\Lutz\ownCloud\Sync\FOR2104_Papiere\Expert\Daten"
use "20170721_expert_arbeitsdatei.dta", clear 

*use "C:\Users\Tepe\ownCloud\Shared\Expertenhypothese\Daten\20170721_expert_arbeitsdatei.dta", clear

set more off


***** ----------------------- **********
*Wichtige Anpassungen, um Anzahl der Versuche verwenden zu können 
keep if check == 1
sort id period 
by id: gen c=sum(voteresult)
order id numagree c rep  voteresult  period numagree rep voteresult



sort id c
quietly by id c:  gen dap = cond(_n==_n+1,99,_n)
gen running = _n
gen dap2=.
forvalues i = 2(1)861 {
               replace dap2 = dap[`i'-1] if running==`i'
           }


	replace dap2 = 1 if running == 1
	order id numagree c rep dap dap2
	replace rep = dap2 
	drop dap2 
	keep if voteresult == 1
	drop einigung
	gen fullinfo = 0 
	replace fullinfo = 1 if sessionid > 3
	gen with_expert = 0 
	replace with_expert = 1 if treatmentside == 2
	replace treatment = treatmentside

gen newperiod = c 
replace numagree = newperiod 
  /* neue Variable newperiod ist jetz zu verwenden
wie gewöhnliche Period. Bezieht sich dann jeweils auf die Runde in der die 
Einigung erzielt wurde */


keep if role_expert == 0
bysort treatment: sum rep /* rep = repetition */
keep if voteresult== 1    
egen groupid = group(sessionid period group)


***** ----------------------- **********



 /* Wichtig, um nur die Rundenauszuzählen, in denen 
es auch eine Einigung gab. */  
gen ed = .
replace ed = distributeex1 if groupmember == 1
replace ed = distributeex2 if groupmember == 2
replace ed = distributeex3 if groupmember == 3

gen cd = . 
replace cd = distributeco1 if groupmember == 1
replace cd = distributeco2 if groupmember == 2
replace cd = distributeco3 if groupmember == 3

gen endowment_q = .
replace endowment_q =1 if endowment <=2
replace endowment_q =2 if endowment >2 & endowment < 7
replace endowment_q =3 if endowment >=7


gen success_m =  0
replace success_m = 1 if groupmember == 1 & distributeco1+endowment > 9 
replace success_m = 1 if groupmember == 2 & distributeco2+endowment > 9 
replace success_m = 1 if groupmember == 3 & distributeco3+endowment > 9 

gen success_e =  0
replace success_e = 1 if groupmember == 1 & distributeex1+endowment > 9 
replace success_e = 1 if groupmember == 2 & distributeex2+endowment > 9 
replace success_e = 1 if groupmember == 3 & distributeex3+endowment > 9 



bysort groupid: egen sum_success =sum(success)
bysort groupid: egen sum_success_m =sum(success_m)
bysort groupid: egen sum_success_e =sum(success_e)
sort groupid

*Heterogenität der Gruppe über range: 
gen range = . 
 forvalues i = 1(1)468 {
                 sum  endowment if groupid == `i'
				 replace range = r(max)-r(min) if groupid == `i'
           }

*******************************************************************************
* keep if chosenone == 1   
/* Für manche Analysen kann es Sinn ergeben, nur das Gruppenmitglied 
einzubeziehen, dessen Vorschlag zur Umverteilung herangezogen wurde. */ 
*******************************************************************************

tab treatment success, col

preserve 
keep if fullinfo == 0
bysort ressources: tab treatment success, col
bysort ressources: tab treatment sum_success_m, col row 
bysort ressources: tab treatment sum_success_e, col row 
restore 

**** Distribution analysis 

bysort groupid: egen inc_pos = rank(endowment)
tab inc_pos, gen(inc_pos_)


gen distribute = distributeex1 if groupmember == 1
replace distribute = distributeex2 if groupmember == 2
replace distribute = distributeex3 if groupmember == 3


*** LIEBIG Items 

gen linos_equality = (linos_c + linos_k + linos_g)/3
gen linos_need = (linos_e + linos_j + linos_a)/3
gen linos_equity = (linos_b + linos_i + linos_h)/3
gen linos_entitlement = (linos_d + linos_l + linos_f)/3

* Regression 

gen needorientation = 0
replace needorientation = 1 if sum_success_m == 3
*preserve 
*keep if fullinfo == 0 
xtset id newperiod
*keep if chosenone==1
*keep if fullinfo == 0   /*Analyse nur auf Gruppeneben */ 


** NEW


keep if chosenone == 1

*** save zwisschenablage

*** Aditional coding



gen treat_cat = . 
replace treat_cat = 1 if with_expert==0 & fullinfo==0
replace treat_cat = 2 if with_expert==1 & fullinfo==0
replace treat_cat = 3 if with_expert==0 & fullinfo==1
replace treat_cat = 4 if with_expert==1 & fullinfo==1

label define treat_cat_lb 1 "no expert no info" 2 "expert no info" 3 "no expert info" 4 "expert info"
label values treat_cat treat_cat_lb 
label var treat_cat "Treatment condition"



gen need_just = 0
replace need_just = 1 if sum_success_m==3


******************




xtset id newperiod

fvset base 15 ressources


xtologit sum_success_m i.ressources i.treat_cat   range newperiod 
est store m1
xtologit sum_success_m              i.treat_cat   range newperiod if ressources==10,  
est store m2
xtologit sum_success_m              i.treat_cat   range newperiod if ressources==15,  
est store m3
xtologit sum_success_m              i.treat_cat   range newperiod if ressources==20, 
est store m4
xtologit sum_success_m i.ressources##i.treat_cat  range newperiod 
est store m5
esttab m1 m2 m3 m4 m5 using tab_A.csv, se(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label 




xtologit sum_success_m i.ressources##i.treat_cat  range newperiod if fullinfo==0 
xtologit sum_success_m i.ressources##i.treat_cat  range newperiod if fullinfo==1 


xtologit sum_success_m i.ressources i.with_expert##i.fullinfo   range newperiod 
















xtologit sum_success_m i.ressources                   newperiod
estimates store m1

xtologit sum_success_m i.ressources i.with_expert     newperiod
estimates store m2

xtologit sum_success_m i.ressources##i. with_expert   newperiod
estimates store m3

xtologit sum_success_m i.ressources i.treat_cat       newperiod
estimates store m4

xtologit sum_success_m i.ressources##i.treat_cat      newperiod
estimates store m5


esttab m1 m2 m3 m4 m5 using tab_A.csv, p(2) brackets star(* 0.10 ** 0.05 *** 0.01) ar2 bic nogaps replace label 

