* DGPAR: DV Grandparents of CM in HH

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
tab1 ADGPAR00 BDGPAR00 CDGPAR00 DDGPAR00 EGPAR00 FDGPAR00 GDGPAR00
 
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DGPAR=. 
replace  DGPAR=ADGPAR00 if SWEEP==1
replace  DGPAR=BDGPAR00 if SWEEP==2
replace  DGPAR=CDGPAR00 if SWEEP==3
replace  DGPAR=DDGPAR00 if SWEEP==4
replace  DGPAR=EGPAR00  if SWEEP==5
replace  DGPAR=FDGPAR00 if SWEEP==6
replace  DGPAR=GDGPAR00 if SWEEP==7

label var DGPAR "DV Grandparents of CM in HH"
recode DGPAR (-2=-8)
label def DGPARlb     -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "At least 1 grandparent in HH" ///
           2 "No grandparents in HH"     ,  replace
		  
label val DGPAR DGPARlb
tab  DGPAR SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DGPAR
compress
save "${temp_data_fdv}DGPAR.dta" ,replace



