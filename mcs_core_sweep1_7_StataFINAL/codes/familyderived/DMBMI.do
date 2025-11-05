* DMBMI: DV Natural Mothers BMI at Interview 
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
sum ADMBMI00 BDMBMI00 CDMBMI00 DDMBMI00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DMBMI=. 
replace  DMBMI=ADMBMI00 if SWEEP==1
replace  DMBMI=BDMBMI00 if SWEEP==2
replace  DMBMI=CDMBMI00 if SWEEP==3
replace  DMBMI=DDMBMI00 if SWEEP==4
replace  DMBMI=. if SWEEP==5
replace  DMBMI=. if SWEEP==6
replace  DMBMI=. if SWEEP==7
recode DMBMI (-2=-8) // -2 "Pregnant no BMI calc." 
label var DMBMI "DV Natural Mothers BMI at Interview"
label def DMBMIlb   -9 "Refusal" /// 
-8 "Don't know" /// 
          -1 "Not applicable"   ,  replace
		  
label val DMBMI DMBMIlb

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DMBMI
compress
save "${temp_data_fdv}DMBMI.dta" ,replace



