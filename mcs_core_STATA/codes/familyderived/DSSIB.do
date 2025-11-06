* DSSIB: Step siblings of CM in household 

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
tab1 ADSSIB00 BDSSIB00 CDSSIB00 DDSSIB00 ESSIB00 FDSSIB00 GDSSIB00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DSSIB=. 
replace  DSSIB=ADSSIB00 if SWEEP==1
replace  DSSIB=BDSSIB00 if SWEEP==2
replace  DSSIB=CDSSIB00 if SWEEP==3
replace  DSSIB=DDSSIB00 if SWEEP==4
replace  DSSIB=ESSIB00  if SWEEP==5
replace  DSSIB=FDSSIB00 if SWEEP==6
replace  DSSIB=GDSSIB00 if SWEEP==7
recode DSSIB (-2=-8)

label var DSSIB "DV Step siblings of CM in household "
label def DSSIBlb     -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1  "At least 1 step sib in HH" ///
           2 "No step sib in HH"   ,  replace

label val DSSIB DSSIBlb
tab  DSSIB SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DSSIB
compress
save "${temp_data_fdv}DSSIB.dta" ,replace



