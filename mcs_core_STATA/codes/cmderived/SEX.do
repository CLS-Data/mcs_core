
*SEX: CM Sex at birth

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs1}mcs1_hhgrid.dta", clear
drop if ACNUM00==.
keep if ACNUM00!=0
rename  ACNUM00 CNUM00
duplicates report MCSID CNUM00 

keep  MCSID  CNUM00   AHCSEX00
gen SWEEP=1
rename *, upper
tempfile mcs1
save `mcs1'


use "${mcs2}mcs2_hhgrid.dta", clear
drop if BCNUM00==.
keep if BCNUM00!=0
rename  BCNUM00 CNUM00

keep MCSID CNUM00 BHCSEX00
gen SWEEP=2
tempfile mcs2
save `mcs2'


use "${mcs3}mcs3_hhgrid.dta", clear
drop if CCNUM00==.
keep if CCNUM00!=0
rename  CCNUM00 CNUM00

keep MCSID CNUM00 CHCSEX00
gen SWEEP=3
tempfile mcs3
save `mcs3'

use "${mcs3}mcs3_cm_interview.dta", clear
rename  CCNUM00 CNUM00

keep MCSID CNUM00 CHCSEX00
rename CHCSEX00 CHCSEX00_cm_int
gen SWEEP=3
tempfile mcs3_cm_int
save `mcs3_cm_int'



use "${mcs4}mcs4_hhgrid.dta", clear
drop if   DCNUM00==.
keep if DCNUM00!=-1 // Not applicable
rename  DCNUM00 CNUM00

keep MCSID CNUM00 DHCSEX00 
duplicates report MCSID CNUM00
gen SWEEP=4

tempfile mcs4
save `mcs4'

use "${mcs5}mcs5_hhgrid.dta", clear
drop if   ECNUM00==.
keep if ECNUM00!=-1 // Not applicable
rename  ECNUM00 CNUM00

keep MCSID CNUM00 ECSEX0000 
duplicates report MCSID CNUM00
gen SWEEP=5

tempfile mcs5
save `mcs5'


use "${mcs6}mcs6_hhgrid.dta", clear
drop if   FCNUM00==.
keep if FCNUM00!=-1 // Not applicable
rename  FCNUM00 CNUM00

keep MCSID CNUM00 FHCSEX00 
duplicates report MCSID CNUM00
gen SWEEP=6
tempfile mcs6
save `mcs6'


use `mcs1'
merge 1:1 MCSID CNUM00 using `mcs2'
drop _merge

merge 1:1 MCSID CNUM00 using `mcs3'
drop _merge

merge 1:1 MCSID CNUM00 using `mcs3_cm_int'
drop _merge

merge 1:1 MCSID CNUM00 using `mcs4'
drop _merge

merge 1:1 MCSID CNUM00 using `mcs5'
drop _merge

merge 1:1 MCSID CNUM00 using `mcs6'
drop _merge


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

tab1 *SEX*
clonevar SEX=AHCSEX00 
replace SEX=BHCSEX00 if SEX==.
replace SEX=CHCSEX00 if SEX==.
replace SEX=DHCSEX00 if SEX==.
replace SEX=ECSEX0000 if SEX==.
replace SEX=FHCSEX00 if SEX==.

replace SEX=CHCSEX00_cm_int if SEX==.

tab SEX
*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key

keep MCSID CNUM00 SWEEP  SEX
duplicates report MCSID CNUM00 SWEEP
label var SEX "CM Sex at birth"
label def SEXLB 1 "Male" 2 "Female", replace
label val SEX SEXLB


save "${temp_data_cdv}SEX.dta" ,replace






