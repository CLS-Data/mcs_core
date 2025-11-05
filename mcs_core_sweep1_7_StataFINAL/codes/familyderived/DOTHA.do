* DOTHA: DV Other adult in HH 

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
tab1 ADOTHA00 BDOTHA00 CDOTHA00 DDOTHA00 EOTHA00 FDOTHA00 GDOTHA00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DOTHA=. 
replace  DOTHA=ADOTHA00 if SWEEP==1
replace  DOTHA=BDOTHA00 if SWEEP==2
replace  DOTHA=CDOTHA00 if SWEEP==3
replace  DOTHA=DDOTHA00 if SWEEP==4
replace  DOTHA=EOTHA00 if SWEEP==5
replace  DOTHA=FDOTHA00 if SWEEP==6
replace  DOTHA=GDOTHA00 if SWEEP==7
recode DOTHA (-2=-8)
label var DOTHA "DV Other adult in HH"
label def DOTHAlb    -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "At least 1 other adult in HH" ///
           2 "No other adults in HH"     ,  replace
		  
label val DOTHA DOTHAlb
tab  DOTHA SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DOTHA
compress
save "${temp_data_fdv}DOTHA.dta" ,replace



