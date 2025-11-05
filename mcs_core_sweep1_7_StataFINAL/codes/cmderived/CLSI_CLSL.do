* CLSI		: CM has longstanding illness (reported by parent)
* CLSI_SR	: CM has longstanding illness (reported by CM)
* CLSL		: CM has conditions/illnesses limit every day activities (reported by parent)
* CLSL_SR 	: CM has conditions/illnesses limit every day activities (reported by CM)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs2}mcs2_parent_cm_interview.dta",clear	
keep if BELIG00==1

global varlist "BPCLSI00 BPCLSL00"
keep MCSID BCNUM00 ${varlist} 
gen SWEEP=2
tempfile mcs2
save `mcs2'

use "${mcs3}mcs3_parent_cm_interview.dta",clear	
keep if CELIG00==1
global varlist "CPCLSI00 CPCLSMA0 CPCLSMB0 CPCLSMC0 CPCLSL00"
keep MCSID CCNUM00 ${varlist} 
gen SWEEP=3
tempfile mcs3
save `mcs3'

use "${mcs4}mcs4_parent_cm_interview.dta",clear	
keep if DELIG00==1
global varlist "DPCLSI00 DPCLSL00"
keep MCSID DCNUM00 ${varlist} 
gen SWEEP=4
tempfile mcs4
save `mcs4'

use "${mcs5}mcs5_parent_cm_interview.dta",clear	
keep if EELIG00==1
global varlist "EPCLSI00 EPCLSL00 EPCLSP00"
keep MCSID ECNUM00 ${varlist} 
gen SWEEP=5
tempfile mcs5
save `mcs5'

use "${mcs6}mcs6_parent_cm_interview.dta",clear	
keep if FELIG00==1
global varlist "FPCLSI00 FPCLSL00 FPCLSP00"
keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6
tempfile mcs6
save `mcs6'

use "${mcs7}mcs7_cm_interview.dta",clear	
global varlist "GCCLSI00 GCCLSL00 GCCLSP00"
keep MCSID GCNUM00 ${varlist} 
gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs2' 
forvalues i=3(1)7{
append using 	`mcs`i''
}


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

tab1 BPCLSI00 CPCLSI00 DPCLSI00 EPCLSI00 FPCLSI00 GCCLSI00, 

recode GCCLSI00 (3=-8) (4=-9) (5=-1)


tab1 BPCLSL00 CPCLSL00 DPCLSL00 EPCLSL00 FPCLSL00 GCCLSL00

recode EPCLSL00 FPCLSL00 (1/2=1) (3=2)
recode GCCLSL00 (1/2=1) (3=2) (4=-8) (6=-1) 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen CLSI=. 
*replace  CLSI= if SWEEP==1
replace  CLSI=BPCLSI00 if SWEEP==2
replace  CLSI=CPCLSI00 if SWEEP==3
replace  CLSI=DPCLSI00 if SWEEP==4
replace  CLSI=EPCLSI00 if SWEEP==5
replace  CLSI=FPCLSI00 if SWEEP==6

gen CLSI_SR=. 
replace  CLSI_SR=GCCLSI00 if SWEEP==7
  
label var CLSI "CM has longstanding illness (reported by parent)"

label var CLSI_SR "CM has longstanding illness (reported by CM)"

label def CLSIlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Yes" ///
           2 "No"  ,  replace
		  
label val CLSI CLSI_SR CLSIlb
tab  CLSI SWEEP, m
tab  CLSI_SR SWEEP, m

gen CLSL=. 
*replace  CLSL= if SWEEP==1
replace  CLSL=BPCLSL00  if SWEEP==2
replace  CLSL=CPCLSL00  if SWEEP==3
replace  CLSL=DPCLSL00  if SWEEP==4
replace  CLSL=EPCLSL00  if SWEEP==5
replace  CLSL=FPCLSL00  if SWEEP==6

gen CLSL_SR=. 
replace  CLSL_SR=GCCLSL00 if SWEEP==7
  
label var CLSL "CM has conditions/illnesses limit every day activities (reported by parent)"
label var CLSL_SR "CM has conditions/illnesses limit every day activities (reported by CM)"

label def CLSLlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Yes" ///
           2 "No"  ,  replace
		  
label val CLSL CLSL_SR CLSLlb
tab  CLSL SWEEP, m
tab  CLSL_SR SWEEP, m


*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
*replace  CNUM00=ACNUM00 if SWEEP==1
replace  CNUM00=BCNUM00 if SWEEP==2
replace  CNUM00=CCNUM00 if SWEEP==3
replace  CNUM00=DCNUM00 if SWEEP==4
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep MCSID CNUM00 SWEEP CLSI CLSI_SR CLSL CLSL_SR 
order MCSID CNUM00 SWEEP CLSI CLSI_SR CLSL CLSL_SR 
compress
save "${temp_data_cdv}CLSI_CLSL.dta" ,replace




