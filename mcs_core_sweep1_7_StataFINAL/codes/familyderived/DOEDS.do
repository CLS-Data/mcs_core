* DOEDS: DV Equivalised family income OECD scores

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
tab1 ADOEDS00 BDOEDS00 CDOEDS00 DDOEDS00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DOEDS=. 
replace  DOEDS=ADOEDS00 if SWEEP==1
replace  DOEDS=BDOEDS00 if SWEEP==2
replace  DOEDS=CDOEDS00 if SWEEP==3
replace  DOEDS=DDOEDS00 if SWEEP==4
replace  DOEDS=. if SWEEP==5
replace  DOEDS=. if SWEEP==6
replace  DOEDS=. if SWEEP==7

label var DOEDS "DV Equivalised family income OECD scores"
		  

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DOEDS
compress
save "${temp_data_fdv}DOEDS.dta" ,replace



