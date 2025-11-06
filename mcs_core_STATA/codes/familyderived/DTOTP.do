* DTOTP: DV Number of people in HH including CMs  

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
tab1 ADTOTP00 BDTOTP00 CDTOTP00 DDTOTP00 ETOTP00 FDTOTP00 GDTOTP00
 
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DTOTP=. 
replace  DTOTP=ADTOTP00 if SWEEP==1
replace  DTOTP=BDTOTP00 if SWEEP==2
replace  DTOTP=CDTOTP00 if SWEEP==3
replace  DTOTP=DDTOTP00 if SWEEP==4
replace  DTOTP=ETOTP00  if SWEEP==5
replace  DTOTP=FDTOTP00 if SWEEP==6
replace  DTOTP=GDTOTP00 if SWEEP==7

label var DTOTP "DV Number of people in HH including CMs  "

replace  DTOTP=-1 if SWEEP==7 & DTOTP==0 // 221 cases with value 0 (Number of CM in HH) that are boost cases for whom there was no HHgrid. - 

label def dk_re_na_lb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           ,  replace
		   
label val DTOTP dk_re_na_lb


*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DTOTP
compress
save "${temp_data_fdv}DTOTP.dta" ,replace



