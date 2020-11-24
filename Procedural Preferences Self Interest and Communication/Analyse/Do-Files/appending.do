*Experiment 1
use "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session1\20181212_exp1_s1_raw.dta", clear
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session2\20181212_exp1_s2_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session3\20181212_exp1_s3_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session4\20181130_exp1_s4_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session5\20181130_exp1_s5_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session6\20181130_exp1_s6_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session7\20181130_exp1_s7_raw.dta", force

save "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\20181212_exp1_combined_raw.dta", replace

*Experiment 2
use "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session1\20181212_exp2_s1_raw.dta", clear
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session2\20181212_exp2_s2_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session3\20181212_exp2_s3_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session4\20181130_exp2_s4_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session5\20181130_exp2_s5_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session6\20181130_exp2_s6_raw.dta", force
append using "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\Session7\20181130_exp2_s7_raw.dta", force

save "C:\Users\Lutz\Dropbox\IPP_Procedural_Preferences\Daten\20181212_exp2_combined_raw.dta", replace
