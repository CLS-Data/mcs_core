* DOEDP: DV OECD Below 60% median indicator   

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
tab1 ADOEDP00 BDOEDP00 CDOEDP00 DDOEDP00 EOEDP000 FOEDP000
 
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DOEDP=. 
replace  DOEDP=ADOEDP00 if SWEEP==1
replace  DOEDP=BDOEDP00 if SWEEP==2
replace  DOEDP=CDOEDP00 if SWEEP==3
replace  DOEDP=DDOEDP00 if SWEEP==4
replace  DOEDP=EOEDP000 if SWEEP==5
replace  DOEDP=FOEDP000 if SWEEP==6
replace  DOEDP=-1 if SWEEP==7

label var DOEDP "DV OECD Below 60% median indicator"
label def DOEDPlb       -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           0 "Above 60% median" ///
           1 "Below 60% median"  ,  replace
		  
label val DOEDP DOEDPlb
tab  DOEDP SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DOEDP
compress
save "${temp_data_fdv}DOEDP.dta" ,replace



