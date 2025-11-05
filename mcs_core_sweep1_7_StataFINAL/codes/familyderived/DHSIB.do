* DHSIB: DV Half siblings of CM in household 

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_family_derived.dta",clear
gen SWEEP=`i'
tempfile mcs`i'
save `mcs`i''
}

use `mcs1' 
forvalues i=2(1)7{
append using 	`mcs`i''
}


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed
tab1 ADHSIB00 BDHSIB00 CDHSIB00 DDHSIB00 EHSIB00 FDHSIB00 GDHSIB00
 
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DHSIB=. 
replace  DHSIB=ADHSIB00 if SWEEP==1
replace  DHSIB=BDHSIB00 if SWEEP==2
replace  DHSIB=CDHSIB00 if SWEEP==3
replace  DHSIB=DDHSIB00 if SWEEP==4
replace  DHSIB=EHSIB00 if SWEEP==5
replace  DHSIB=FDHSIB00 if SWEEP==6
replace  DHSIB=GDHSIB00 if SWEEP==7

label var DHSIB "DV Half siblings of CM in household"
recode DHSIB (-2=-8)
label def DHSIBlb  -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "At least 1 half sib in HH" ///
           2 "No half sibs in HH" ,  replace

label val DHSIB DHSIBlb
tab  DHSIB SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DHSIB
compress
save "${temp_data_fdv}DHSIB.dta" ,replace



