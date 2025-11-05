*HEALTH - COHORT MEMBER REPORTED MENTAL HEALTH
*EMOTION_C	:	DV SDQ Emotional Symptoms (CM-reported)
*CONDUCT_C	:	DV SDQ Conduct Problems (CM-reported)
*HYPER_C	:	DV SDQ Hyperactivity/Inattention (CM-reported)
*PEER_C	:	DV SDQ Peer Problems (CM-reported)
*PROSOC_C	:	DV SDQ Prosocial (CM-reported)
*EBDTOT_C	:	DV SDQ Total Difficulties (CM-reported)

*KESSLER_C: DV K6 Kessler (CM-reported)
*SELFHA: Self-harmed in the last 12 months
*SMFQ: Short Mood and Feelings Questionnaire total score

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs6}mcs6_cm_interview.dta",clear	
global varlist "FCHARM00 FCMDSA00 FCMDSB00 FCMDSC00 FCMDSD00 FCMDSE00 FCMDSF00 FCMDSG00  FCMDSH00 FCMDSI00 FCMDSJ00 FCMDSK00 FCMDSL00 FCMDSM00"
keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6

tempfile mcs6
save `mcs6'

use "${mcs7}mcs7_cm_derived.dta",clear	
global varlist "GEMOTION_C GCONDUCT_C GHYPER_C GPEER_C GPROSOC_C GEBDTOT_C GDCKESSL"
keep MCSID GCNUM00 ${varlist} 
gen SWEEP=7
tempfile mcs7derived
save `mcs7derived'


use "${mcs7}mcs7_cm_interview.dta",clear
	
foreach v in GCSHCU00 GCSHBU00 GCSHBR00 GCSHOD00 GCSHPU00 GCSHRM00 {
gen `v'_aux=1 if inlist(`v',3,4,5)
gen `v'_one=1 if `v'==1
}

egen all_345 = rowtotal(GCSHCU00_aux GCSHBU00_aux GCSHBR00_aux GCSHOD00_aux GCSHPU00_aux GCSHRM00_aux)
tab all_345

egen any_eq1 = rowtotal(GCSHCU00_one GCSHBU00_one GCSHBR00_one GCSHOD00_one GCSHPU00_one GCSHRM00_one)
tab any_eq1

* GSELFHA: 
gen GSELFHA = 2
replace GSELFHA = -1 if all_345 == 6
replace GSELFHA =  1 if any_eq1  > 0

global varlist "GSELFHA"
keep MCSID GCNUM00 ${varlist} 

gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs7derived' 
merge 1:1 MCSID GCNUM00 using `mcs7'
drop _merge
tempfile mcs7
save `mcs7'

use `mcs6' 
append using 	`mcs7'

*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed


rename GEMOTION_C EMOTION_C
rename GCONDUCT_C CONDUCT_C
rename GHYPER_C   HYPER_C
rename GPEER_C    PEER_C
rename GPROSOC_C  PROSOC_C
rename GEBDTOT_C  EBDTOT_C
rename GDCKESSL   KESSLER_C

global SMFQ_varlist "FCMDSA00 FCMDSB00 FCMDSC00 FCMDSD00 FCMDSE00 FCMDSF00  FCMDSG00 FCMDSH00 FCMDSI00 FCMDSJ00 FCMDSK00 FCMDSL00 FCMDSM00" 
recode $SMFQ_varlist (1=0) (2=1) (3=2) (-9/-1=.)

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

*------------------------------------------------------------
* SELFHA
gen SELFHA = .
replace SELFHA = FCHARM00 if SWEEP==6
replace SELFHA = GSELFHA if SWEEP==7
recode SELFHA (2=0)

* SMFQ
egen SMFQ = rowtotal(FCMDSA00 FCMDSB00 FCMDSC00 FCMDSD00 FCMDSE00 ///
                     FCMDSF00 FCMDSG00 FCMDSH00 FCMDSI00 FCMDSJ00 ///
                     FCMDSK00 FCMDSL00 FCMDSM00)
egen SMFQmiss = rowmiss(FCMDSA00 FCMDSB00 FCMDSC00 FCMDSD00 FCMDSE00 ///
                     FCMDSF00 FCMDSG00 FCMDSH00 FCMDSI00 FCMDSJ00 ///
                     FCMDSK00 FCMDSL00 FCMDSM00)
replace SMFQ = . if SMFQmiss > 0
drop SMFQmiss


*------------------------------------------------------------

label var EMOTION_C  "DV SDQ Emotional Symptoms (cohort member-reported)"
label var CONDUCT_C  "DV SDQ Conduct Problems (cohort member-reported)"
label var HYPER_C    "DV SDQ Hyperactivity/Inattention (cohort member-reported)"
label var PEER_C     "DV SDQ Peer Problems (cohort member-reported)"
label var PROSOC_C   "DV SDQ Prosocial (cohort member-reported)"
label var EBDTOT_C   "DV SDQ Total (cohort member-reported)"
label var KESSLER_C  "DV K6 Kessler score (cohort member-reported)"
label var SELFHA     "Hurt yourself on purpose during the last year"
label var SMFQ       "Short Mood and Feelings Questionnaire total score"

*------------------------------------------------------------

label def SDQlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ,  replace
label val EMOTION_C CONDUCT_C HYPER_C PEER_C PROSOC_C EBDTOT_C KESSLER_C  SDQlb	

label def SELFHAlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" 0 "No" 1 "Yes",  replace
label val SELFHA SELFHAlb	

*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep MCSID CNUM00 SWEEP EMOTION_C CONDUCT_C HYPER_C PEER_C PROSOC_C EBDTOT_C KESSLER_C SELFHA SMFQ
compress
save "${temp_data_cdv}HEALTH.dta" ,replace

