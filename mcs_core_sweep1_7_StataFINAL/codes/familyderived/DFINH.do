* DFINH: DV Natural father in HH 

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
tab1 ADFINH00 BDFINH00 CDFINH00 DDFINH00 EFINH00 FDFINH00 GDFINH00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DFINH=. 
replace  DFINH=ADFINH00 if SWEEP==1
replace  DFINH=BDFINH00 if SWEEP==2
replace  DFINH=CDFINH00 if SWEEP==3
replace  DFINH=DDFINH00 if SWEEP==4
replace  DFINH=EFINH00  if SWEEP==5
replace  DFINH=FDFINH00 if SWEEP==6
replace  DFINH=GDFINH00 if SWEEP==7

label var DFINH "DV Natural father in HH"
label def DFINHlb          -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Resident in household" ///
           2 "Not resident in household" ///
           3 "Deceased",  replace
		  
label val DFINH DFINHlb
tab  DFINH SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DFINH
compress
save "${temp_data_fdv}DFINH.dta" ,replace



