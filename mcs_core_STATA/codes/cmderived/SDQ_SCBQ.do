
* SDQ
*EMOTION	:	DV SDQ Emotional Symptoms (parent-reported)
*CONDUCT	:	DV SDQ Conduct Problems (parent-reported)
*HYPER	:	DV SDQ Hyperactivity/Inattention (parent-reported)
*PEER	:	DV SDQ Peer Problems (parent-reported)
*PROSOC	:	DV SDQ Prosocial (parent-reported)
*EBDTOT	:	DV SDQ Total Difficulties (parent-reported)

* Child Social Behaviour Questionnaire
*DCSBI	:	DV Child Social Behaviour Questionnaire (Independence-Self Regulation)
*DCSBE	:	DV Child Social Behaviour Questionnaire (Emotional-Dysregulation)
*DCSBC	:	DV Child Social Behaviour Questionnaire (Cooperation)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_cm_derived.dta",clear	

gen SWEEP=`i'
tempfile mcs`i'
save `mcs`i''
}

use `mcs1' 
forvalues i=2(1)7{
append using 	`mcs`i''
}

*-------------------------------------------------------------------------------
* SDQ
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

 rename DDEMOTION DEMOTION
 rename DDCONDUCT DCONDUCT
 rename DDHYPER DHYPER
 rename DDPEER DPEER
 rename DDPROSOC DPROSOC
 rename DDDEBDTOT DEBDTOT
global names  "EMOTION  CONDUCT HYPER PEER PROSOC EBDTOT"

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

foreach newvar of global names {
	cap drop `newvar'
gen `newvar'=. 
*replace  `newvar'= if SWEEP==1
replace  `newvar'=B`newvar' if SWEEP==2
replace  `newvar'=C`newvar' if SWEEP==3
replace  `newvar'=D`newvar' if SWEEP==4
replace  `newvar'=E`newvar' if SWEEP==5
replace  `newvar'=F`newvar' if SWEEP==6
replace  `newvar'=G`newvar' if SWEEP==7

}
tab1  EMOTION  CONDUCT HYPER PEER PROSOC EBDTOT

label var EBDTOT "DV SDQ Total Difficulties (parent-reported)"
label var EMOTION  "DV SDQ Emotional Symptoms (parent-reported)"
label var CONDUCT "DV SDQ Conduct Problems (parent-reported)"
label var HYPER "DV SDQ Hyperactivity/Inattention (parent-reported)"
label var PEER "DV SDQ Peer Problems (parent-reported)"
label var PROSOC "DV SDQ Prosocial (parent-reported)"

label def sdqlb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable"        ,  replace
		  
label val EMOTION  CONDUCT HYPER PEER PROSOC EBDTOT sdqlb


*-------------------------------------------------------------------------------
* Child Social Behaviour Questionnaire 
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

global names  "DCSBI00 DCSBE00"

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

foreach newvar of global names {
	cap drop `newvar'
gen `newvar'=. 
*replace  `newvar'= if SWEEP==1
replace  `newvar'=B`newvar' if SWEEP==2
replace  `newvar'=C`newvar' if SWEEP==3
replace  `newvar'=D`newvar' if SWEEP==4
*replace  `newvar'=E`newvar' if SWEEP==5
*replace  `newvar'=F`newvar' if SWEEP==6
*replace  `newvar'=G`newvar' if SWEEP==7

}

gen DCSBC00=DDCSBC00 if SWEEP==4

tab1 DCSBI00 DCSBE00 DCSBC00

label var DCSBI00 "DV Child Social Behaviour Questionnaire (Independence-Self Regulation)"
label var DCSBE00 "DV Child Social Behaviour Questionnaire (Emotional-Dysregulation)"
label var DCSBC00 "DV Child Social Behaviour Questionnaire (Cooperation)"
 
label def nalb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable"   ,  replace
		  
label val DCSBI00 DCSBE00 DCSBC00 nalb



tab  DCSBI00 SWEEP, m
tab  DCSBE00  SWEEP, m
tab  DCSBC00 SWEEP, m

rename DCSBI00 DCSBI
rename DCSBE00 DCSBE
rename DCSBC00 DCSBC

*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
replace  CNUM00=ACNUM00 if SWEEP==1
replace  CNUM00=BCNUM00 if SWEEP==2
replace  CNUM00=CCNUM00 if SWEEP==3
replace  CNUM00=DCNUM00 if SWEEP==4
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep MCSID CNUM00 SWEEP EMOTION CONDUCT HYPER PEER PROSOC EBDTOT DCSBI DCSBE DCSBC 

compress

save "${temp_data_cdv}SDQ_SCBQ.dta" ,replace



