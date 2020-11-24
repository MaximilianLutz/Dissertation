use "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\20181212_exp2_combined_raw.dta", clear

* Grundsätzliches  
egen id = group(session subject) 

rename treatmentnumber experimentnumber
rename decisionredistribution decisionpg
replace geschlecht = "1" if geschlecht == "Weiblich"
replace geschlecht = "0" if geschlecht != "1"
destring geschlecht, replace force 
rename geschlecht female

gen treatment = 1 
replace treatment = 2 if sessionid ==  "181130_0744"
replace treatment = 2 if sessionid == "181130_0936"
replace treatment = 3 if sessionid == "181130_1242"
replace treatment = 3 if sessionid == "181130_1540"

drop subjects netpay1-netpay3 totalprofit participate randomnumber randomorder randomsubject ///
 netpay_textz timeokintrook vorz majority_text timeokdecisionprocedureok /// 
 ballot lotteryprocedure timeokdecisionpgok lotteryredistribution pay /// 
 timeokinfopgok timezumfragebogenpayoffok draw 

 * Zusaätzliche Variablen für spätere Analyse
 gen member_majority = 0 
 replace member_majority = 1 if  netpay > 0 & majority == 1
 replace member_majority = 1 if  netpay < 0 & majority == 0
 

 
 
*Variablenlabels
label variable treatment "Treatment for respective session"
label variable distribution "distribution of endowment for current period"
label variable chosenone "Which subjects decides about pg"
label variable groupdecisionpg "final decision about pg"
label variable netpay "Loss/Gain from PG" 
label variable decisionprocedure "individual decision about procedure"
label variable netinc "net income"
label variable majority "Will majority profit from pg?"
label variable lotterypayoff "lottery for random selection of period to pay"
label variable client "computer in lab"
label variable sem "Semester"
label variable decisionpg "Sind für die Anschaffung des Gutes?" 

label variable dem_1 "Bei politischen Entscheidungen sollte immer das Gemeinwohl und nicht das eigene Interesse im Vordergrund stehen"
label variable dem_2 "Es ist in der Demokratie wichtig zu verstehen, aus welchen Gründen andere Menschen andere Meinungen haben"
label variable dem_3 "Demokratisch getroffene Entscheidungen muss man auf jeden Fall akzeptieren, auch wenn sie den eigenen Interessen widersprechen."
label variable dem_4 "Wenn sich für eine Entscheidung eine große Mehrheit findet, spricht das dafür, dass die Entscheidung richtig ist."
label variable dem_5 "Was ist für Sie im Zweifelsfall wichtiger?"

label variable sterben "Die Zulässigkeit von Sterbehilfe"
label variable zuwandern "Die Steuerung der Zuwanderung"
label variable steuer "Steuergerichtigkeit"
label variable gruenenergie "Die Förderung erneuerbarer Energien"

label variable self_sterben "Eigene Meinung: Die Zulässigkeit von Sterbehilfe"
label variable self_zuwandern "Eigene Meinung: Die Steuerung der Zuwanderung"
label variable self_steuer "Eigene Meinung: Steuergerichtigkeit"
label variable self_grueneenergie "Eigene Meinung: Die Förderung erneuerbarer Energien"

label variable mehrheit_sterben "Deutschland: Die Zulässigkeit von Sterbehilfe"
label variable mehrheit_zuwandern "Deutschland: Die Steuerung der Zuwanderung"
label variable mehrheit_steuer "Deutschland: Steuergerichtigkeit"
label variable mehrheit_grueneenergie "Deutschland: Die Förderung erneuerbarer Energien"

label variable gefallen "Wenn mir jemand einen Gefallen tut, bin ich bereit dies zu erwidern." 
label variable rache "Wenn mir schweres Unrecht zuteil wird, werde ich mich um jeden Preis bei der nächsten Gelegenheit dafür rächen."
label variable lage "Wenn mich jemand in eine schwierige Lage bringt, werde ich das Gleiche mit ihm machen."
label variable helfen "Ich strenge mich besonders an, um jemandem zu helfen, der mir früher schon mal geholfen hat."
label variable beleidigt "Wenn mich jemand beleidigt hat, werde ich mich ihm gegenüber auch beleidigend verhalten."
label variable kosten "Ich bin bereit Kosten auf mich zu nehmen, um jemandem zu helfen, der mir früher einmal geholfen hat."

label variable risk_base "Risikobereitschaft"
label variable risk2 "bei Geldanlagen?"
label variable risk3 "bei Freizeit und Sport?"
label variable risk4 "bei Ihrer beruflichen Karriere?"
label variable risk5 "bei Ihrer Gesundheit?"
label variable risk6 "beim Vertrauen in fremde Menschen?"
label variable risk1 "beim Autofahren" 

label variable pol_selbstein "Links-Rechts selbsteinstufung" 

* Value Labels 
label define zustimmung7 0 "stimme voll zu" 6 "lehne voll ab"
label values dem_1 - dem_4 zustimmung7
label define treatment 1 "Majority" 2 "Group benefit" 3 "No info" 
label define process 1 "Mehrheitswahl" 0 "Computer" 
label define procon 1 "Ich bin dafür" 5 "Ich bin dagegen"
label define germany 1  "klare Mehrheit dafür" 5 "klare Mehrheit dagegen" 
label define personality 1 "trifft überhaupt nicht zu" 2 "trifft eher nicht zu" 3 "weder noch"  4 "eher zutreffend" 5 "trifft voll und ganz zu"
label define rec 1 "stimme voll und ganz zu" 2 "+" 3 " "  4 "-" 5 "stimme überhaupt nicht zu"
label define risk 0 "gar nicht risikobereit" 10 "sehr risikobereit" 
label define lr 0 "links" 10 "rechts" 
label define maj 1 "Majority has posivite use" 0 "Majority has negative use" 
label define sex 1 "Weiblich" 0 "Maennlich" 


label define entscheidung4 1 "Nach einer öffentlichen Debatte sollte eine Volksabstimmung stattfinden." ///
2 "Der Deutsche Bundestag sollte auf Grundlage der Diskussion in den Parteien und im Bundestag entscheiden." ///
3 "Ein unabhängiges Expertengremium sollte eine Empfehlung erarbeiten, die dann umgesetzt werden sollte" ///
4 "Vertreter aller betroffenen Gruppen sollten sich an einen Tisch setzen und gemeinsam eine Lösung finden." 

label values sterben entscheidung4
label values zuwandern entscheidung4
label values steuer entscheidung4
label values gruenenergie entscheidung4
label values treatment treatment
label values decisionprocedure process
label values decisionpg procon
label values self_sterben procon
label values self_steuer procon
label values self_grueneenergie procon
label values self_zuwandern procon
label values mehrheit_sterben germany
label values mehrheit_steuer germany
label values mehrheit_grueneenergie germany
label values mehrheit_zuwandern germany
label values bfi_1-bfi_10 personality
label values gefallen-kosten rec
label values risk_base-risk6 risk 
label values pol_selbstein-polparteilinke lr


encode pol_interesse, gen(pol_int)
encode wahlbeteiligung09 , gen(wahlbeteiligung17)


* Abschluss 
order sessionid treatment id 
save "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\20181212_exp2_workingdata.dta", replace
