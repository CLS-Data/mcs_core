
* AGEY:	Age at Interview (years)
* SWEEPAGE:	Age at MCS Sweep (years)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data


use "${mcs1}mcs1_hhgrid.dta", clear
drop if ACNUM00==.
keep if ACNUM00!=0
rename  ACNUM00 CNUM00
duplicates report MCSID CNUM00 

keep  MCSID  CNUM00    AHCAGE00
gen SWEEP=1
rename *, upper
tempfile mcs1
save `mcs1'


use "${mcs2}mcs2_hhgrid.dta", clear
drop if BCNUM00==.
keep if BCNUM00!=0
rename  BCNUM00 CNUM00

keep MCSID CNUM00  BHCAGE00
gen SWEEP=2
tempfile mcs2
save `mcs2'


use "${mcs3}mcs3_hhgrid.dta", clear
drop if CCNUM00==.
keep if CCNUM00!=0
rename  CCNUM00 CNUM00

keep MCSID CNUM00  CHCAGE00
gen SWEEP=3
tempfile mcs3
save `mcs3'



use "${mcs4}mcs4_hhgrid.dta", clear
drop if   DCNUM00==.
keep if DCNUM00!=-1 // Not applicable
rename  DCNUM00 CNUM00

keep MCSID CNUM00   DHCAGE00
duplicates report MCSID CNUM00
gen SWEEP=4

tempfile mcs4
save `mcs4'



use "${mcs5}mcs5_cm_interview.dta"	, clear
keep MCSID ECNUM00 EMCS5AGE
tab1 EMCS5AGE
rename  ECNUM00 CNUM00
duplicates report MCSID CNUM00
tempfile mcs5_cm
save `mcs5_cm'

use "${mcs5}mcs5_hhgrid.dta", clear
drop if   ECNUM00==.
keep if ECNUM00!=-1 // Not applicable
rename  ECNUM00 CNUM00

keep MCSID CNUM00  ECAGE0000
duplicates report MCSID CNUM00
gen SWEEP=5

tempfile mcs5
save `mcs5'


use "${mcs6}mcs6_hhgrid.dta", clear
drop if   FCNUM00==.
keep if FCNUM00!=-1 // Not applicable
rename  FCNUM00 CNUM00

keep MCSID CNUM00  FHCAGE00
duplicates report MCSID CNUM00
gen SWEEP=6
tempfile mcs6
save `mcs6'


use "${mcs7}mcs7_hhgrid.dta", clear
drop if   GCNUM00==.
keep if GCNUM00!=-1 // Not applicable
rename  GCNUM00 CNUM00

keep MCSID CNUM00  GHCAGE00
duplicates report MCSID CNUM00
gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs1' 
forvalues i=2(1)7{
append using 	`mcs`i''
}

merge m:1 MCSID CNUM00 using `mcs5_cm'
drop _merge

tab SWEEP 

*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

sum AHCAGE00 BHCAGE00 CHCAGE00 DHCAGE00 ECAGE0000 FHCAGE00 GHCAGE00
*age 
tab1 AHCAGE00 BHCAGE00 CHCAGE00 DHCAGE00 ECAGE0000 FHCAGE00 GHCAGE00
tab1 EMCS5AGE

replace AHCAGE00=AHCAGE00 / 365.25
replace BHCAGE00=BHCAGE00 / 365.25
recode CHCAGE00 (-1=.)
replace CHCAGE00=CHCAGE00 / 365.25
replace DHCAGE00=DHCAGE00 / 365.25

recode EMCS5AGE (18=.)
replace EMCS5AGE = ECAGE0000 if EMCS5AGE==. & ECAGE0000!=. &  SWEEP==5
sum ECAGE0000  EMCS5AGE if SWEEP==5
recode GHCAGE00 (-1=.)


tab1 AHCAGE00 BHCAGE00 CHCAGE00 DHCAGE00 EMCS5AGE FHCAGE00 GHCAGE00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

gen AGEY=. 
replace  AGEY=AHCAGE00  if SWEEP==1
replace  AGEY=BHCAGE00  if SWEEP==2
replace  AGEY=CHCAGE00  if SWEEP==3
replace  AGEY=DHCAGE00  if SWEEP==4
replace  AGEY=EMCS5AGE if SWEEP==5
replace  AGEY=FHCAGE00  if SWEEP==6
replace  AGEY=GHCAGE00  if SWEEP==7

bys SWEEP: sum AGEY

label var AGEY "Age at interview to nearest 10th of year"
label def AGEYlb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" , replace
label val AGEY AGEYlb

clonevar SWEEPAGE=SWEEP
recode SWEEPAGE (1=1) (2=3) (3=5) (4=7) (5=11) (6=14) (7=17)
label var SWEEPAGE "Age at Sweep (years)"
label def SWEEPAGElb 1 "9 months" ///
				  3 "3 years" ///
				  5 "5 years" ///
				  7 "7 years" ///
				  11 "11 years" ///
				  14 "14 years" ///
				  17 "17 years" , replace

label val 	SWEEPAGE SWEEPAGElb	
*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key

keep MCSID CNUM00 SWEEP  AGEY SWEEPAGE
duplicates report MCSID CNUM00 SWEEP

save "${temp_data_cdv}AGEY_SWEEPAGE.dta" ,replace



