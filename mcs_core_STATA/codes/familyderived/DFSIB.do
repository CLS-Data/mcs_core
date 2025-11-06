* DFSIB: DV Foster siblings of CM in household

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
tab1 ADFSIB00 BDFSIB00 CDFSIB00 DDFSIB00 EFSIB00 FDFSIB00 GDFSIB00
 
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DFSIB=. 
replace  DFSIB=ADFSIB00 if SWEEP==1
replace  DFSIB=BDFSIB00 if SWEEP==2
replace  DFSIB=CDFSIB00 if SWEEP==3
replace  DFSIB=DDFSIB00 if SWEEP==4
replace  DFSIB=EFSIB00 if SWEEP==5
replace  DFSIB=FDFSIB00 if SWEEP==6
replace  DFSIB=GDFSIB00 if SWEEP==7

label var DFSIB "DV Foster siblings of CM in household"
recode DFSIB (-2=-8)
label def DFSIBlb   -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "At least 1 foster sib in HH" ///
           2 "No foster sibs in HH"    ,  replace
		  
label val DFSIB DFSIBlb
tab  DFSIB SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DFSIB
compress
save "${temp_data_fdv}DFSIB.dta" ,replace



