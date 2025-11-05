* DHLAN: DV Language Spoken in household  

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
tab1 ADHLAN00 BDHLAN00 CDHLAN00 DDHLAN00 EHLAN00 FDHLAN00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DHLAN=. 
replace  DHLAN=ADHLAN00 if SWEEP==1
replace  DHLAN=BDHLAN00 if SWEEP==2
replace  DHLAN=CDHLAN00 if SWEEP==3
replace  DHLAN=DDHLAN00 if SWEEP==4
replace  DHLAN=EHLAN00 if SWEEP==5
replace  DHLAN=FDHLAN00 if SWEEP==6
replace  DHLAN=. if SWEEP==7

label var DHLAN "DV Language Spoken in household"
label def DHLANlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Yes - English only" ///
           2 "Yes - mostly English, sometimes other" ///
           3 "Yes - about half English and half other" ///
           4 "No - mostly other, sometimes English" ///
           5 "No - other language(s) only"   ,  replace
		  
label val DHLAN DHLANlb
tab  DHLAN SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DHLAN
compress
save "${temp_data_fdv}DHLAN.dta" ,replace



