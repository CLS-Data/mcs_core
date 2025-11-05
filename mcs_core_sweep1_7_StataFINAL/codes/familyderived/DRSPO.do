* DRSPO: DV Parent Interview response summary

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
tab1 *DRSPO* ERSPO00

recode BDRSPO00 (6=9) //  No main interview, partner by proxy, recode 2 cases only in MCS 2

recode ADRSPO00 (5=6) // No main, partner interviewed        
recode BDRSPO00 (5=6) // No main, partner interviewed         
recode CDRSPO00 (5=6) // No main, partner interviewed        
recode DDRSPO00 (5=6) // No main, partner interviewed        

recode BDRSPO00 (7=8) //  No parent interviews         
recode CDRSPO00 (7=8) //  No parent interviews 
recode DDRSPO00 (7=8) //  No parent interviews   

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DRSPO=. 
replace  DRSPO=ADRSPO00 if SWEEP==1
replace  DRSPO=BDRSPO00 if SWEEP==2
replace  DRSPO=CDRSPO00 if SWEEP==3
replace  DRSPO=DDRSPO00 if SWEEP==4
replace  DRSPO=ERSPO00  if SWEEP==5
replace  DRSPO=FDRSPO00 if SWEEP==6
replace  DRSPO=-1 if SWEEP==7

label var DRSPO "DV Parent Interview response summary"
label def DRSPOlb         -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Main resp in person, no eligible partner" ///
           2 "Main and partner respondent in person" ///
           3 "Main in person, partner by proxy" ///
           4 "Main in person, partner elig but not interviewed" ///
           5 "Main in person, partner elig by prox but not interviewed" ///
           6 "No main response, partner interviewed" ///
           7 "No main response, nobody eligible for partner" ///
           8 "No parent interviews" ///
		   9 "No main interview, partner by proxy",  replace
		  
label val DRSPO DRSPOlb
tab  DRSPO SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DRSPO
compress
save "${temp_data_fdv}DRSPO.dta" ,replace



