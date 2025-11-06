* DOTHS: DV Number of siblings of CM in HH

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
tab1 ADOTHS00 BDOTHS00 CDOTHS00 DDOTHS00 EOTHS00 FDOTHS00 GDOTHS00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DOTHS=. 
replace  DOTHS=ADOTHS00 if SWEEP==1
replace  DOTHS=BDOTHS00 if SWEEP==2
replace  DOTHS=CDOTHS00 if SWEEP==3
replace  DOTHS=DDOTHS00 if SWEEP==4
replace  DOTHS=EOTHS00  if SWEEP==5
replace  DOTHS=FDOTHS00 if SWEEP==6
replace  DOTHS=GDOTHS00 if SWEEP==7

label var DOTHS "DV Number of siblings of CM in HH"



label def dk_re_na_lb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           ,  replace
		   
label val DOTHS dk_re_na_lb

tab  DOTHS SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DOTHS
compress
save "${temp_data_fdv}DOTHS.dta" ,replace



