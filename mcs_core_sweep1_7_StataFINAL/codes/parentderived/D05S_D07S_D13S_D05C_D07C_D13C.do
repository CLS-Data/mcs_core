*D05S:	DV Respondent NS-SEC 5 classes (current job) (Main Interviewee)
*D07S:	DV Respondent NS-SEC 7 classes  (current job) (Main Interviewee)
*D13S:	DV Respondent NS-SEC major categories (current job) (Main Interviewee)
*D05C:	DV Respondent NS-SEC 5 classes (last known job) (Main Interviewee)
*D07C:	DV Respondent NS-SEC 7 classes (last known job) (Main Interviewee)
*D13C:	DV Respondent NS-SEC major categories (last known job) (Main Interviewee)
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


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen ELIG00=. 
replace  ELIG00=AELIG00   if SWEEP==1
replace  ELIG00=BELIG00   if SWEEP==2
replace  ELIG00=CELIG00   if SWEEP==3
replace  ELIG00=DELIG00   if SWEEP==4
replace  ELIG00=EELIG00   if SWEEP==5
replace  ELIG00=FELIG00  if SWEEP==6


keep if ELIG00==1							 // keep data only from Main interview

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


* current job 
* D05S	Respondent NS-SEC 5 classes (current job) 
gen D05S=. 
replace  D05S=ADD05S00  if SWEEP==1
replace  D05S=BDD05S00  if SWEEP==2
*replace  D05S=. /*CDD05S00*/  if SWEEP==3 // error in derived variable
replace  D05S=DDD05S00  if SWEEP==4
replace  D05S=ED05S00   if SWEEP==5
replace  D05S=FD05S00   if SWEEP==6

label def D05Slb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Manag and profl" ///
           2 "Intermediate" ///
           3 "Sm emp and s-emp" ///
           4 "Lo sup and tech" ///
           5 "Semi-rou and routine", replace 
label val D05S D05Slb
label var D05S "DV Respondent NS-SEC 5 classes (current job) (Main Interviewee)"

*D07S	Respondent NS-SEC 7 classes (current job)
gen D07S=. 
replace  D07S=ADD07S00   if SWEEP==1
replace  D07S=BDD07S00   if SWEEP==2
*replace  D07S=CDD07S00   if SWEEP==3
replace  D07S=DDD07S00   if SWEEP==4
replace  D07S=ED07S00    if SWEEP==5
replace  D07S=FD07S00   if SWEEP==6

label def D07Slb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Hi manag/prof" ///
           2 "Lo manag/prof" ///
           3 "Intermediate" ///
           4 "Small emp and s-emp" ///
           5 "Low sup and tech" ///
           6 "Semi routine" ///
           7 "Routine", replace 

label val D07S D07Slb
label var D07S "DV Respondent NS-SEC 7 classes (current job) (Main Interviewee)"

*D13S	Respondent NS-SEC major categories (current job)
* 
gen D13S=. 
replace  D13S=ADD13S00    if SWEEP==1
replace  D13S=BDD13S00    if SWEEP==2
*replace  D13S=CDD13S00    if SWEEP==3
replace  D13S=DDD13S00    if SWEEP==4
replace  D13S=ED13S00     if SWEEP==5
replace  D13S=FD13S00   if SWEEP==6

label def  D13Slb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Large emp" ///
           2 "Hi manag" ///
           3 "Higher prof" ///
           4 "Lo prof/hi tech" ///
           5 "Lower managers" ///
           6 "Hi supervisory" ///
           7 "Intermediate" ///
           8 "Small employers" ///
           9 "Self-emp non profl" ///
          10 "Lower supervisors" ///
          11 "Lower technical" ///
          12 "Semi-routine" ///
          13 "Routine", replace
label val D13S D13Slb
label var D13S "DV Respondent NS-SEC major categories (current job) (Main Interviewee)"

*D05C	"DV Respondent NS-SEC 5 classes (last known job)"
gen D05C=. 
replace  D05C=ADD05C00   if SWEEP==1
replace  D05C=BDD05C00   if SWEEP==2
replace  D05C=CDD05C00  if SWEEP==3 
replace  D05C=DDD05C00  if SWEEP==4
label val D05C D05Slb
label var D05C	"DV Respondent NS-SEC 5 classes (last known job) (Main Interviewee)"
tab D05C SWEEP

*D07C	"DV Respondent NS-SEC 7 classes (last known job)"
gen D07C=. 
replace  D07C=ADD07C00    if SWEEP==1
replace  D07C=BDD07C00    if SWEEP==2
replace  D07C=CDD07C00   if SWEEP==3 
replace  D07C=DDD07C00  if SWEEP==4
label val D07C D07Slb
label var D07C	"DV Respondent NS-SEC 7 classes (last known job) (Main Interviewee)"
tab D07C SWEEP

*D13C	"DV Respondent NS-SEC major categories (last known job)"
gen D13C=. 
replace  D13C=ADD13C00   if SWEEP==1
replace  D13C=BDD13C00     if SWEEP==2
replace  D13C=CDD13C00      if SWEEP==3 
replace  D13C=DDD13C00  if SWEEP==4
label val D13C D13Slb
label var D13C	"DV Respondent NS-SEC major categories (last known job) (Main Interviewee)"
tab D07C SWEEP


		  
*-------------------------------------------------------------------------------
* 4) save temporal data 
* note that we don't need ELIG00 PNUM00 because it is restricted only to the derived response for the main interview ELIG00==1 
keep MCSID SWEEP D05S D07S D13S D05C D07C D13C
duplicates report MCSID SWEEP
compress
save "${temp_data_pdv}D05S_D07S_D13S_D05C_D07C_D13C.dta" ,replace



