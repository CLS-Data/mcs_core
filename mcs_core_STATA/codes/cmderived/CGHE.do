
* CGHE		CM General level of health (Parental report)
* CGHE_SR	CM General level of health (CM self-rated)
*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data


use "${mcs3}mcs3_parent_cm_interview.dta",clear	
keep if CELIG00==1
global varlist "CPCGHE00"
keep MCSID CCNUM00 ${varlist} 
gen SWEEP=3
tempfile mcs3
save `mcs3'

use "${mcs4}mcs4_parent_cm_interview.dta",clear	
keep if DELIG00==1
global varlist "DPCGHE00"
keep MCSID DCNUM00 ${varlist} 
gen SWEEP=4
tempfile mcs4
save `mcs4'

use "${mcs5}mcs5_parent_cm_interview.dta",clear	
keep if EELIG00==1
global varlist "EPCGHE00"
keep MCSID ECNUM00 ${varlist} 
gen SWEEP=5
tempfile mcs5
save `mcs5'

use "${mcs6}mcs6_cm_interview.dta",clear	
global varlist "FCCGHE00"
keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6
tempfile mcs6
save `mcs6'

use "${mcs7}mcs7_cm_interview.dta",clear	
global varlist "GCCGHE00"
keep MCSID GCNUM00 ${varlist} 
gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs3' 
forvalues i=4(1)7{
append using 	`mcs`i''
}


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

tab1 CPCGHE00 DPCGHE00 EPCGHE00 FCCGHE00 GCCGHE00 

recode GCCGHE00 (6=-8) (7=-9) (8=-1)

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen CGHE=. 
replace  CGHE=CPCGHE00  if SWEEP==3
replace  CGHE=DPCGHE00  if SWEEP==4
replace  CGHE=EPCGHE00  if SWEEP==5

gen CGHE_SR=. 
replace  CGHE_SR=FCCGHE00  if SWEEP==6
replace  CGHE_SR=GCCGHE00  if SWEEP==7
  
label var CGHE "CM General level of health (Parental report)"
label var CGHE_SR "CM General level of health (CM self-rated)"


label def CGHElb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Excellent" ///
           2 "Very good" ///
           3 "Good" ///
           4 "Fair" ///
           5 "Poor"   ,  replace
label val CGHE CGHE_SR CGHElb		   


*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
*replace  CNUM00=ACNUM00 if SWEEP==1
*replace  CNUM00=BCNUM00 if SWEEP==2
replace  CNUM00=CCNUM00 if SWEEP==3
replace  CNUM00=DCNUM00 if SWEEP==4
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep MCSID CNUM00 SWEEP CGHE CGHE_SR
compress
save "${temp_data_cdv}CGHE.dta" ,replace

