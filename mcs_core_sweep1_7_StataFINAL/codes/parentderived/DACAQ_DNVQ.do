*DACAQ:	DV NVQ equivalent of highest Academic qualification across previos sweeps (Main Interviewee)
*DNVQ:	DV Respondent NVQ Highest Level (all sweeps- Main Interviewee)


*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_parent_derived.dta",clear
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
tab1  AELIG00 BELIG00 CELIG00 DELIG00 EELIG00 FELIG00

* DNVQ - Respondent NVQ equivalent Highest Level (across all sweeps)
*Looks at academic and vocational qualifications gained by the MAIN respondent since last interview (ACQU, VCQU) and compares them with the derived NVQ highest level from previous sweeps to ascertain the overall highest level attained across all sweeps.

* DACAQ - NVQ equivalent of highest academic level across sweeps
* Derived as DNVQ, showing highest NVQ equivalent qualification but looking at only academic qualifications obtained since the previous interview. This is then compared to all previous sweeps to obtain the highest NVQ equivalent qualification across all sweeps.


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen ELIG00=. 
replace  ELIG00=AELIG00   if SWEEP==1
replace  ELIG00=BELIG00   if SWEEP==2
replace  ELIG00=CELIG00   if SWEEP==3
replace  ELIG00=DELIG00   if SWEEP==4
replace  ELIG00=EELIG00   if SWEEP==5
replace  ELIG00=FELIG00  if SWEEP==6


keep if ELIG00==1							 // data only from Main interview

duplicates report MCSID SWEEP

label var ELIG00 "Eligibility for survey: Whether resp eligible for role of Main /(Proxy)Partner"
label def ELIG00lb  -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Main Interview" ///
           2 "Partner Interview" ///
           3 "Proxy Partner Interview" ///
           4 "Not eligible for interview", replace
label val ELIG00 ELIG00lb


gen PNUM00=. 
replace  PNUM00=APNUM00   if SWEEP==1
replace  PNUM00=BPNUM00   if SWEEP==2
replace  PNUM00=CPNUM00   if SWEEP==3
replace  PNUM00=DPNUM00   if SWEEP==4
replace  PNUM00=EPNUM00   if SWEEP==5
replace  PNUM00=FPNUM00   if SWEEP==6

label var PNUM00 "Person number within an MCS family data (excl Cohort Members, see CNUM)"


*DNVQ : Respondent NVQ equivalent Highest Level (across all sweeps)
fre ADDNVQ00 BDDNVQ00 CDDNVQ00 DDDNVQ00 EDNVQ00 FDNVQ00
gen DNVQ=.  
replace  DNVQ=ADDNVQ00   if SWEEP==1
replace  DNVQ=BDDNVQ00   if SWEEP==2
replace  DNVQ=CDDNVQ00   if SWEEP==3
replace  DNVQ=DDDNVQ00   if SWEEP==4
replace  DNVQ=EDNVQ00   if SWEEP==5
replace  DNVQ=FDNVQ00  if SWEEP==6


*DACAQ : Parental education NVQ equivalent of highest Academic qualification 
fre ADACAQ00 BDACAQ00 CDACAQ00 DDACAQ00 EACAQ00 FDACAQ00

gen DACAQ=. 
replace  DACAQ=ADACAQ00    if SWEEP==1
replace  DACAQ=BDACAQ00    if SWEEP==2
replace  DACAQ=CDACAQ00    if SWEEP==3
replace  DACAQ=DDACAQ00    if SWEEP==4
replace  DACAQ=EACAQ00    if SWEEP==5
replace  DACAQ=FDACAQ00   if SWEEP==6

label def DACAQlb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "NVQ level 1" ///
           2 "NVQ level 2" ///
           3 "NVQ level 3" ///
           4 "NVQ level 4" ///
           5 "NVQ level 5" ///
          95 "Overseas qual only" ///
          96 "None of these", replace 

label val DNVQ DACAQlb 
label var DNVQ "DV Respondent NVQ Highest Level (all sweeps - Main Interviewee)"		  
		  
label val DACAQ DACAQlb 
label var DACAQ "DV NVQ equivalent of highest Academic qualification across previos sweeps (Main Interviewee)"
		  
fre 	DNVQ	 DACAQ  

tab DNVQ SWEEP 
tab DACAQ SWEEP   
*-------------------------------------------------------------------------------
* 4) save temporal data 
* note that we don't need ELIG00 PNUM00 because it is restricted only to the derived response for the main interview ELIG00==1
keep MCSID SWEEP DACAQ DNVQ
duplicates report MCSID SWEEP
compress
save "${temp_data_pdv}DACAQ_DNVQ.dta" ,replace



