* ACTRY: ADMIN Country at interview (E,W,S,NI)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_family_derived.dta",clear
gen SWEEP=`i'
tempfile mcs`i'
save `mcs`i''
}


use "${mcs7}/mcs7_hhgrid.dta"
gen SWEEP=7
drop if GPNUM00==-1
duplicates report MCSID GPNUM00
keep if GPNUM00==1
keep MCSID SWEEP GACTRY00
tempfile mcs7
save `mcs7'

use `mcs1' 
forvalues i=2(1)7{
append using 	`mcs`i''
}



*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen ACTRY=. 
replace  ACTRY=AACTRY00 if SWEEP==1
replace  ACTRY=BACTRY00 if SWEEP==2
replace  ACTRY=CACTRY00 if SWEEP==3
replace  ACTRY=DACTRY00 if SWEEP==4
replace  ACTRY=EACTRY00 if SWEEP==5
replace  ACTRY=FACTRY00 if SWEEP==6
replace  ACTRY=GACTRY00 if SWEEP==7


label var ACTRY "ADMIN Country at interview (E,W,S,NI)"
label def ACTRYlb  -9 "Refusal" /// 
				-8 "Don't know" /// 
				-1 "Not Applicable" ///
				1 "England" ///
           2 "Wales" ///
           3 "Scotland" ///
           4 "Northern Ireland", replace
		  
label val ACTRY ACTRYlb
tab  ACTRY SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP ACTRY
compress
save "${temp_data_fdv}ACTRY.dta" ,replace



