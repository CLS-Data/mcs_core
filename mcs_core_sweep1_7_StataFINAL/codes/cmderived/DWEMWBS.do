
* YP Warwick-Edinburgh Mental Wellbeing Scale (WEMWBS) 
* DWEMWBS:	DV WEMWBS: Sum of raw mental welbeing scores transformed to metric scale
*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs7}mcs7_cm_derived.dta",clear	
global varlist "GDWEMWBS"
keep MCSID GCNUM00 ${varlist} 
gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs7' 


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed
rename GDWEMWBS DWEMWBS 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
*replace  CNUM00=ACNUM00 if SWEEP==1
*replace  CNUM00=BCNUM00 if SWEEP==2
*replace  CNUM00=CCNUM00 if SWEEP==3
*replace  CNUM00=DCNUM00 if SWEEP==4
*replace  CNUM00=ECNUM00 if SWEEP==5
*replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep SWEEP MCSID CNUM00 DWEMWBS

label var DWEMWBS  "DV WEMWBS: Sum of raw mental welbeing scores transformed to metric scale" 


compress
save "${temp_data_cdv}DWEMWBS.dta" ,replace

