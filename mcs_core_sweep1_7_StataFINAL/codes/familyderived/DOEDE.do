* DOEDE: DV OECD equivalised income

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
sum  ADOEDE00 BDOEDE00 CDOEDE00 DDOEDE00 EOEDE000 FOEDE000


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DOEDE=. 
replace  DOEDE=ADOEDE00 if SWEEP==1
replace  DOEDE=BDOEDE00 if SWEEP==2
replace  DOEDE=CDOEDE00 if SWEEP==3
replace  DOEDE=DDOEDE00 if SWEEP==4
replace  DOEDE=EOEDE000 if SWEEP==5
replace  DOEDE=FOEDE000 if SWEEP==6
replace  DOEDE=-1 if SWEEP==7

label var DOEDE "DV OECD equivalised income"
label def DOEDElb   -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable"  ,  replace
		  
label val DOEDE DOEDElb
bys SWEEP: sum   DOEDE , d

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DOEDE
compress
save "${temp_data_fdv}DOEDE.dta" ,replace



