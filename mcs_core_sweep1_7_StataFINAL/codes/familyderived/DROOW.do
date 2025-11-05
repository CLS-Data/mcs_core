* DROOW: DV Housing Tenure   

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
tab1 ADROOW00 BDROOW00 CDROOW00 DDROOW00 EROOW00 FDROOW00
 
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DROOW=. 
replace  DROOW=ADROOW00 if SWEEP==1
replace  DROOW=BDROOW00 if SWEEP==2
replace  DROOW=CDROOW00 if SWEEP==3
replace  DROOW=DDROOW00 if SWEEP==4
replace  DROOW=EROOW00 if SWEEP==5
replace  DROOW=FDROOW00 if SWEEP==6
replace  DROOW=. if SWEEP==7

label var DROOW "DV Housing Tenure"
label def DROOWlb     -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Own outright" ///
           2 "Own - mortgage/loan" ///
           3 "Part rent/part mortgage (shared equity)" ///
           4 "Rent from local authority" ///
           5 "Rent from Housing Association" ///
           6 "Rent privately" ///
           7 "Living with parents" ///
           8 "Live rent free" ///
           9 "Squatting" ///
          10 "Other"     ,  replace
		  
label val DROOW DROOWlb
tab  DROOW SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DROOW
compress
save "${temp_data_fdv}DROOW.dta" ,replace



