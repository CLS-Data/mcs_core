* DRELP: DV Relationship between Parents/Carers in Household

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
tab1 ADRELP00 BDRELP00 CDRELP00 DDRELP00 ERELP00 FDRELP00 GDRELP00
 
fre ADRELP00 BDRELP00 CDRELP00 DDRELP00 ERELP00 FDRELP00 GDRELP00
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DRELP=. 
replace  DRELP=ADRELP00 if SWEEP==1
replace  DRELP=BDRELP00 if SWEEP==2
replace  DRELP=CDRELP00 if SWEEP==3
replace  DRELP=DDRELP00 if SWEEP==4
replace  DRELP=ERELP00  if SWEEP==5
replace  DRELP=FDRELP00 if SWEEP==6
replace  DRELP=GDRELP00 if SWEEP==7
recode DRELP (-2=-8)  // MCS2 has 11 cases with value -2 
label var DRELP "DV Relationship between Parents/Carers in Household"
label def DRELPlb     -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Married" ///
           2 "Cohabiting" ///
           3 "Neither"    ,  replace
		  
label val DRELP DRELPlb
tab  DRELP SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DRELP
compress
save "${temp_data_fdv}DRELP.dta" ,replace



