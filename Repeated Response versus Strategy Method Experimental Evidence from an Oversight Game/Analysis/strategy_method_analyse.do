set more off
cd "/Users/Max/Nextcloud/Sync/DFG_OVERSIGHT_PAPIERE/Method Approach/Daten/"
use "20181218_workingdata", clear 

gen fos=.
replace fos = 1 if study == `"Bildungs- und Sozialwissenschaften"'
replace fos = 2 if study == `"Human- und Gesellschaftswissenschaften"'
replace fos = 3 if study == `"Informatik, Wirtschafts- und Rechtswissenschaften"'
replace fos = 4 if study == `"Mathematik und Naturwissenschaften"'
replace fos = 5 if study == `"Medizin und Gesundheitswissenschaften"'
replace fos = 6 if study == `"Sprach- und Kulturwissenschaften"'

label define fos 1 "Bildungs- und Sozialwissenschaften" 2 "Human- und Gesellschaftswissenschaften" ///
 3 "Informatik, Wirtschafts- und Rechtswissenschaften" 4  "Mathematik und Naturwissenschaften" /// 
 5 "Medizin und Gesundheitswissenschaften" 6 "Sprach- und Kulturwissenschaften"
 
label values fos fos


*Auswertung 
xtset id period 
capture drop neq
capture drop neq_dif

* Definition neue DV
gen neq = . 
replace neq = 6.25 if type == 1 & payoffmatrix == 1
replace neq = 8 if type == 2 & payoffmatrix == 1
replace neq = 6.25 if type == 1 & payoffmatrix == 2
replace neq = 2 if type == 2 & payoffmatrix == 2
replace neq = 3.33 if type == 1 & payoffmatrix == 3
replace neq = 8 if type == 2 & payoffmatrix == 3
replace neq = 3.33 if type == 1 & payoffmatrix == 4
replace neq = 2 if type == 2 & payoffmatrix == 4

gen neq_dif = pc - neq


reg pc i.treatment if type == 1, robust 
estimates store d1
xtreg pc i.treatment i.c##i.f if type == 1, re robust 
estimates store d2
xtreg pc i.treatment i.c##i.f risk_base cor_sum alte geschlecht study if type == 1, re robust 
estimates store d3
esttab d1 d2 d3 using new_regression_type_A.csv, se brackets star(* .1 ** .05 *** .01)  nogaps replace label 

xtreg pc i.treatment if type == 2, re robust 
estimates store d4
xtreg pc i.treatment i.c##i.f if type == 2, re robust 
estimates store d5
xtreg pc i.treatment i.c##i.f risk_base cor_sum alte geschlecht study if type == 2, re robust 
estimates store d6

esttab d1 d2 d3 d4 d5 d6 using "method_reg2.tex", se brackets ///
 star(* .1 ** .05 *** .01)  nogaps noomitted nobaselevels replace label

* OLD STUFF
preserve
keep if type == 1
xtreg pc treatment, re robust  
estimates store m1
xtreg pc i.treatment##i.payoffmatrix, re robust 
estimates store m2
xtreg pc i.treatment##i.payoffmatrix risk_base cor_sum alte female , re robust 
estimates store m3
esttab m1 m2 m3 using regression_type_A.csv, p(2) brackets star(* .1 ** .05 *** .01)  nogaps replace label 

restore
preserve
keep if type == 2
xtreg pc treatment, re robust  
estimates store m1
xtreg pc i.treatment##i.payoffmatrix, re robust 
estimates store m2
xtreg pc i.treatment##i.payoffmatrix risk_base  alte female study1-study5, re robust 
estimates store m3
esttab m1 m2 m3 using regression_type_B.csv, p(2) brackets star(* .1 ** .05 *** .01)  nogaps replace label 

restore

*** Grafik 1: Vergleich Über Treatments, Perioden und Spielertyp (kein Zeitreiheneffekt) 

preserve 
drop if type == 2 
* Matrix 
matrix m1 = J(4,3,.)
matrix coln m1 = median ll95 ul95
matrix rown m1 = 1 2 3 4 
matrix list m1
forv i = 1/4 {
quietly ci pc if payoffmatrix ==`i' & treatment == 1
matrix m1[`i',1]=r(mean), r(lb), r(ub)
}


matrix m2 = J(4,3,.)
matrix coln m2 = median ll95 ul95
matrix rown m2 = 1 2 3 4 
matrix list m2
forv i = 1/4 {
quietly ci pc if payoffmatrix ==`i'& treatment == 2
matrix m2[`i',1]=r(mean), r(lb), r(ub)
}
matrix list m1
matrix list m2

eststo strategy: mean pc if treatment==1, over(payoffmatrix)
eststo nonstrategy: mean pc if treatment==2, over(payoffmatrix) 
coefplot (strategy) (nonstrategy), ytitle(Probability of cooperation) xtitle(Period) cismooth vertical title(Type A)
graph save g1.gph, replace

restore 
preserve 
drop if type == 1
* Matrix 
matrix m1 = J(4,3,.)
matrix coln m1 = median ll95 ul95
matrix rown m1 = 1 2 3 4 
matrix list m1
forv i = 1/4 {
quietly ci pc if payoffmatrix ==`i' & treatment == 1
matrix m1[`i',1]=r(mean), r(lb), r(ub)
}


matrix m2 = J(4,3,.)
matrix coln m2 = median ll95 ul95
matrix rown m2 = 1 2 3 4 
matrix list m2
forv i = 1/4 {
quietly ci pc if payoffmatrix ==`i'& treatment == 2
matrix m2[`i',1]=r(mean), r(lb), r(ub)
}
matrix list m1
matrix list m2

eststo strategy: mean pc if treatment==1, over(payoffmatrix)
eststo nonstrategy: mean pc if treatment==2, over(payoffmatrix) 
coefplot (strategy) (nonstrategy), ytitle(Probability of cooperation) xtitle(Period) cismooth vertical title(Type B ) 
graph save g2.gph, replace
graph combine g1.gph g2.gph, row(1) ycommon
restore 


*Daten in Ultra langem Format


keep payoffmatrix  choice1-choice10 id treatment type pc
replace pc=pc/10
preserve
keep if payoffmatrix == 1
reshape long choice, i(id)
save "long1.dta",replace 
restore 

preserve
keep if payoffmatrix == 2
reshape long choice, i(id)
save "long2.dta",replace 
restore 

preserve
keep if payoffmatrix == 3
reshape long choice, i(id)
save "long3.dta", replace
restore 

preserve
keep if payoffmatrix == 4
reshape long choice, i(id)
save "long4.dta", replace
restore 


use "long1.dta", clear 
append using "long2.dta", force
append using "long3.dta", force
append using "long4.dta", force


** Grafik 2: Vergleich Entscheidungen über Zeit (gilt nur für Non-Strategy) 
preserve 
drop if type == 2
* Matrix 
matrix m1 = J(10,3,.)
matrix coln m1 = median ll95 ul95
matrix rown m1 = 1 2 3 4 6 7 8 9 10
matrix list m1
forv i = 1/10 {
quietly ci pc if _j ==`i' & treatment == 1
matrix m1[`i',1]=r(mean), r(lb), r(ub)
}


matrix m2 = J(10,3,.)
matrix coln m2 = median ll95 ul95
matrix rown m2 = 1 2 3 4 6 7 8 9 10
matrix list m2
forv i = 1/10 {
quietly ci choice if _j ==`i'& treatment == 2
matrix m2[`i',1]=r(mean), r(lb), r(ub)
}
matrix list m1
matrix list m2

eststo strategy: mean pc if treatment==1, over(_j)
eststo nonstrategy: mean choice if treatment==2, over(_j) 
coefplot (strategy, recast(line)noci) (nonstrategy,recast(line)cismooth), ytitle(Probability of cooperation) xtitle(rep) vertical title(Type A ) 
graph save a1.gph, replace

restore 
preserve 
drop if type == 1
* Matrix 
matrix m1 = J(10,3,.)
matrix coln m1 = median ll95 ul95
matrix rown m1 = 1 2 3 4 6 7 8 9 10
matrix list m1
forv i = 1/10 {
quietly ci pc if _j ==`i' & treatment == 1
matrix m1[`i',1]=r(mean), r(lb), r(ub)
}


matrix m2 = J(10,3,.)
matrix coln m2 = median ll95 ul95
matrix rown m2 = 1 2 3 4 6 7 8 9 10
matrix list m2
forv i = 1/10 {
quietly ci choice if _j ==`i'& treatment == 2
matrix m2[`i',1]=r(mean), r(lb), r(ub)
}
matrix list m1
matrix list m2

eststo strategy: mean pc if treatment==1, over(_j)
eststo nonstrategy: mean choice if treatment==2, over(_j) 
coefplot (strategy, recast(line) noci ) (nonstrategy, recast(line)cismooth), ytitle(Probability of cooperation) xtitle(rep) vertical title(Type B ) 
graph save a2.gph, replace


graph combine a1.gph a2.gph, row(1) ycommon

**Grafik 3 (Alles) 

forvalues i = 1(1)4{
eststo a`i': mean pc if treatment==1 & payoffmatrix == `i', over(_j)
eststo b`i': mean choice if treatment==2 & payoffmatrix == `i', over(_j)
}


coefplot (a1, recast(line)) (b1, recast(line)) || ///
	(a2, recast(line))(b2, recast(line))|| ///
	(a3, recast(line))(b3, recast(line))|| ///
	(a4, recast(line))(b4, recast(line)), vertical 


	
	
	
forvalues i = 1(1)4{
eststo sa`i': mean pc if treatment==1 & payoffmatrix == `i' & type == 1, over(_j)
eststo sb`i': mean pc if treatment==1 & payoffmatrix == `i' & type == 2, over(_j)
eststo nsa`i': mean choice if treatment==2 & payoffmatrix == `i' & type == 1, over(_j)
eststo nsb`i': mean choice if treatment==2 & payoffmatrix == `i' & type == 2, over(_j)
}

coefplot (sa1, recast(line) lpattern(dash) lcolor(red) label("Strategy Player A"))(nsa1, recast(line) lpattern(solid)lcolor(red)  label("Non-Strategy Player A")) /// 
		 (sb1, recast(line) lpattern(dash)lcolor(blue) label("Strategy Player B"))(nsb1, recast(line)lpattern(solid)lcolor(blue) label("Non-Strategy Player A"))|| ///
		 (sa2, recast(line) lpattern(dash)lcolor(red) label("Strategy Player A"))(nsa2, recast(line) lpattern(solid)lcolor(red) label("Non-Strategy Player A")) ///
		 (sb2, recast(line) lpattern(dash)lcolor(blue) label("Strategy Player B"))(nsb2, recast(line)lpattern(solid)lcolor(blue) label("Non-Strategy Player B")) || ///
		 (sa3, recast(line) lpattern(dash)lcolor(red) label("Strategy Player A"))(nsa3, recast(line) lpattern(solid)lcolor(red) label("Non-Strategy Player A")) ///
		 (sb3, recast(line) lpattern(dash)lcolor(blue) label("Strategy Player B"))(nsb3, recast(line)lpattern(solid)lcolor(blue) label("Non-Strategy Player B")) || ///
		 (sa4, recast(line) lpattern(dash)lcolor(red) label("Strategy Player A"))(nsa4, recast(line) lpattern(solid)lcolor(red) label("Non-Strategy Player A")) ///
		 (sb4, recast(line) lpattern(dash)lcolor(blue) label("Strategy Player B"))(nsb4, recast(line)lpattern(solid)lcolor(blue) label("Non-Strategy Player B")), vertical noci
