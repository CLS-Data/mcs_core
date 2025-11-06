* DASIB: DV Adoptive siblings of CM in HH

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
tab1 ADASIB00 BDASIB00 CDASIB00 DDASIB00 EASIB00 FDASIB00 GDASIB00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DASIB=. 
replace  DASIB=ADASIB00 if SWEEP==1
replace  DASIB=BDASIB00 if SWEEP==2
replace  DASIB=CDASIB00 if SWEEP==3
replace  DASIB=DDASIB00 if SWEEP==4
replace  DASIB=EASIB00  if SWEEP==5
replace  DASIB=FDASIB00 if SWEEP==6
replace  DASIB=GDASIB00 if SWEEP==7

label var DASIB "DV Adoptive siblings of CM in HH"
recode DASIB (-2=-8)
label def DASIBlb      -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "At least 1 adoptive sib in HH" ///
           2 "No adoptive sibs in HH"   ,  replace
		  
label val DASIB DASIBlb
tab  DASIB SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DASIB
compress
save "${temp_data_fdv}DASIB.dta" ,replace



