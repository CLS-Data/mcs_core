* AREGN: Interview Government Office Region

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_family_derived.dta",clear
gen SWEEP=`i'
*cap keep SWEEP MCSID *DRSPO*
tempfile mcs`i'
save `mcs`i''
}

use "${mcs7}/mcs7_hhgrid.dta"
gen SWEEP=7
drop if GPNUM00==-1
duplicates report MCSID GPNUM00
keep if GPNUM00==1
keep MCSID SWEEP GAREGN00
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
gen AREGN=. 
replace  AREGN=AAREGN00 if SWEEP==1
replace  AREGN=BAREGN00 if SWEEP==2
replace  AREGN=CAREGN00 if SWEEP==3
replace  AREGN=DAREGN00 if SWEEP==4
replace  AREGN=EAREGN00 if SWEEP==5
replace  AREGN=FAREGN00 if SWEEP==6
replace  AREGN=GAREGN00 if SWEEP==7


label var AREGN "Interview Government Office Region"
label def AREGNlb       -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
1 "North East" ///
           2 "North West" ///
           3 "Yorkshire and the Humber" ///
           4 "East Midlands" ///
           5 "West Midlands" ///
           6 "East of England" ///
           7 "London" ///
           8 "South East" ///
           9 "South West" ///
          10 "Wales" ///
          11 "Scotland" ///
          12 "Northern Ireland" ///
          13 "Not app in IoM Ch Is",  replace
		  
label val AREGN AREGNlb
tab  AREGN SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP AREGN
compress
save "${temp_data_fdv}AREGN.dta" ,replace



