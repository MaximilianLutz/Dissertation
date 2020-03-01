use "/Users/Max/Nextcloud/Sync/FOR2104_Papiere/Expert/Daten/Roh/raw.dta", clear

* erste Session war leider fehlerhaft: 
drop if sessionid == 1 

replace id = sessionid*100+subject

* treatments: 
gen fullinfo = 0 
replace fullinfo = 1 if sessionid > 4 

keep if check == 1
sort id period 
by id: gen c=sum(voteresult)
order id numagree c rep  voteresult  period numagree rep voteresult

sort id c
quietly by id c:  gen dap = cond(_n==_n+1,99,_n)
gen running = _n
gen dap2=.
forvalues i = 2(1)1125 {
               replace dap2 = dap[`i'-1] if running==`i'
           }


replace dap2 = 1 if running == 1
order id numagree c rep dap dap2
replace rep = dap2 
drop dap2 
*keep if voteresult == 1
drop einigung
gen with_expert = 0 
replace with_expert = 1 if treatmentside == 2
replace treatment = treatmentside

gen newperiod = c 
replace numagree = newperiod 
  /* neue Variable newperiod ist jetz zu verwenden
wie gewˆhnliche Period. Bezieht sich dann jeweils auf die Runde in der die 
Einigung erzielt wurde */


keep if role_expert == 0
bysort treatment: sum rep /* rep = repetition */
egen groupid = group(sessionid period group)

gen honest = . 
replace need = 10-endowment
replace honest = need-claim




 /* Wichtig, um nur die Rundenauszuz‰hlen, in denen 
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
