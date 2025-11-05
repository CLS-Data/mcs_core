* DMINH: DV Natural mother in HH

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
tab1 ADMINH00 BDMINH00 CDMINH00 DDMINH00 EMINH00 FDMINH00 GDMINH00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DMINH=. 
replace  DMINH=ADMINH00 if SWEEP==1
replace  DMINH=BDMINH00 if SWEEP==2
replace  DMINH=CDMINH00 if SWEEP==3
replace  DMINH=DDMINH00 if SWEEP==4
replace  DMINH=EMINH00  if SWEEP==5
replace  DMINH=FDMINH00 if SWEEP==6
replace  DMINH=GDMINH00 if SWEEP==7

label var DMINH "DV Natural mother in HH"
label def DMINHlb          -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Resident in household" ///
           2 "Not resident in household" ///
           3 "Deceased",  replace
		  
label val DMINH DMINHlb
tab  DMINH SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DMINH
compress
save "${temp_data_fdv}DMINH.dta" ,replace



