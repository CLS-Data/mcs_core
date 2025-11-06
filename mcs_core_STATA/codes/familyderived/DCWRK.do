* DCWRK: DV Combined labour market status of Main and Partner

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
* Note that CDCWRK00 deposited in UKDS is wrong 
 tab1 ADCWRK00 BDCWRK00 DDCWRK00 ECWRK00 FDCWRK00


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DCWRK=. 
replace  DCWRK=ADCWRK00 if SWEEP==1
replace  DCWRK=BDCWRK00 if SWEEP==2
replace  DCWRK=. if SWEEP==3
replace  DCWRK=DDCWRK00 if SWEEP==4
replace  DCWRK=ECWRK00 if SWEEP==5
replace  DCWRK=FDCWRK00 if SWEEP==6
replace  DCWRK=-1 if SWEEP==7

label var DCWRK "DV Combined labour market status of Main and Partner"
label def DCWRKlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Both in work" ///
           2 "Main in work, partner not" ///
           3 "Partner in work, main not" ///
           4 "Both not in work" ///
           5 "Main in work or on leave, no partner" ///
           6 "Main not in work nor on leave, no partner" ///
           7 "Main work status unknown, partner in work" ///
           8 "Main work status unknown, partner not in work" ///
           9 "Main in work, partner work status unknown" ///
          10 "Main not in work, partner work status unknown" ///
          11 "Main working status unknown, no partner"   ,  replace
		  
label val DCWRK DCWRKlb
tab  DCWRK SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DCWRK
compress
save "${temp_data_fdv}DCWRK.dta" ,replace



