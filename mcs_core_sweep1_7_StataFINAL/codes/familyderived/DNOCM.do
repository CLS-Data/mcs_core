* DNOCM: DV Number of CM in household

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
tab1 ADNOCM00 BDNOCM00 CDNOCM00 DDNOCM00 ENOCM00 FDNOCM00 GDNOCM00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DNOCM=. 
replace  DNOCM=ADNOCM00 if SWEEP==1
replace  DNOCM=BDNOCM00 if SWEEP==2
replace  DNOCM=CDNOCM00 if SWEEP==3
replace  DNOCM=DDNOCM00 if SWEEP==4
replace  DNOCM=ENOCM00 if SWEEP==5
replace  DNOCM=FDNOCM00 if SWEEP==6
replace  DNOCM=GDNOCM00 if SWEEP==7

label var DNOCM "DV Number of CM in household"

replace  DNOCM=-1 if SWEEP==7 & DNOCM==0 // 229 cases with value 0 (Number of CM in HH) that are boost cases for whom there was no HHgrid. - 

label def dk_re_na_lb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           ,  replace
		   
label val DNOCM dk_re_na_lb

tab  DNOCM SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DNOCM
compress
save "${temp_data_fdv}DNOCM.dta" ,replace



