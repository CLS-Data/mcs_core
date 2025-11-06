*---------------------------------------------------------------------------*
* Do-file to generate: mcs_longitudinal_family_file_long dataset
*---------------------------------------------------------------------------*
* Steps to generate mcs_core.dta
* 1) Extract variables from raw MCS data
* 2) Change/recode/edit variables if needed
* 3) Generate new variable in a longitudinal format
* 4) Save dataset as mcs_longitudinal_family_file_long

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
use "${mcslf}mcs_longitudinal_family_file.dta", clear 
cap drop DUALBABYFAMILY
cap drop DATA_LICENCE


* Globals
global sweeps 7

*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed
* Remove unavailable people
drop if DATA_AVAILABILITY== 0
drop DATA_AVAILABILITY

* Remove triplets
*NOTE TO USER: the main MCS datasets on UKDS do not include triplets. for that reason,
*they are excluded here. if you are using other forms of the data, you may want to retain
*the triplets. If so, do not run this section of code.
keep if NOCMHH!=3 

* Create CNUM
expand NOCMHH // create one per cohort member in the intial sample
bys MCSID: gen CNUM=_n // correlative within MCSID 
 
* Rename variables
rename SPTN00 SPTN
rename PTTY00 PTTY

* Recode specific variables
recode AAOUTC00 (2=1) 
recode BAOUTC00 (1=1) (2=4) (3=5) (4=2) (5=6) (6=3)  
replace BAOUTC00=0 if BISSUED==0 // not issued marked in BISSUED
replace CAOUTC00=0 if CISSUED==0 // not issued marked in CISSUED
replace FAOUTC00=0 if FISSUED==0 // not issued marked in CISSUED
recode FAOUTC00 (-1=0) // recode not issued 
recode GAOUTC00 (-1=0) // recode not issued 
		   
* Remove Sweep-Letter Prefix		   
forval sweep = 1/$sweeps {
	local letter: word `sweep' of `c(ALPHA)'
	
	rename `letter'ISSUED ISSUED`sweep' 
	rename `letter'AOUTC00 AOUTC`sweep'
	rename `letter'OVWT1 OVWT1`sweep'
	rename `letter'OVWT2 OVWT2`sweep'

	if inlist(`sweep', 2, 5, 6, 7){
		rename `letter'NRESPWT NRESPWT`sweep'
	}
	
	if inrange(`sweep', 2, 4){
		rename `letter'OVWTGB OVWTGB`sweep'
	}
}


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

*From wide to long
reshape long ISSUED AOUTC OVWT1 OVWT2 NRESPWT OVWTGB , i(MCSID CNUM) j(SWEEP) 

label var CNUM "Cohort Member number within an MCS family" 
label var OVWT1 "Overall Weight (inc NR adjustment) single country analysis"
label var OVWT2 "Overall Weight (inc NR adjustment) whole uk analyses" 
label var AOUTC "Survey Outcome Code"
label var NRESPWT "Non-Reponse Weight"
label var OVWTGB "Overall weight for use on GB analysis"
label def AOUTClb 0 "0. Not Issued" ///
           1 "1. Productive"  ///
           2 "2. Refusal"  ///
           3 "3. Other unproductive"  ///
           4 "4. Ineligible"  ///
           5 "5. Untraced"  ///
           6 "6. No contact"  , replace
label val AOUTC AOUTClb

label var ISSUED "Family Issued at MCS survey"
label def ISSUEDlb 0 "No" 1 "Yes", replace
label val ISSUED ISSUEDlb

label var SWEEP "MCS sweep"
label def SWEEPlb 1 "Sweep 1" ///
				  2 "Sweep 2" ///
				  3 "Sweep 3" ///
				  4 "Sweep 4" ///
				  5 "Sweep 5" ///
				  6 "Sweep 6" ///
				  7 "Sweep 7" , replace
				  
label val 	SWEEP SWEEPlb			 


label def NOCMHHlb 1 "1. Singletons" 2 "2. Twins" 3 "3. Triplets", replace
label val  NOCMHH NOCMHHlb
tab NOCMHH, m

order MCSID CNUM SWEEP NOCMHH SENTRY COUNTRY PTTY PTTYPE2 SPTN NH2 ISSUED AOUTC NRESPWT OVWT1 OVWT2 OVWTGB 

 
*MCSID: MCS Research ID - Anonymised Family/Household Identifier
*SWEEP: MCS Sweep 1-7
*CNUM : Cohort Member number within an MCS family  
*NOCMHH: Number of cohort children in household at entry to survey  


*-------------------------------------------------------------------------------
* 4) Save dataset
rename CNUM CNUM00 
compress


save "${temp_data}mcs_longitudinal_family_file_long.dta" ,replace


