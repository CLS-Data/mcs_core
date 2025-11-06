* MCS Cognitive Variables. Total of 47 variables (12+17+15+3)

* MCS 1 – age 9 months
* 	Developmental Milestones (12 variables)
* MCS 2 - age 3
* 	Bracken School Readiness Assessment-Revised (BSRA-R) with all subcategories (17 variables)
* MCS 2, 3, 4, 5 - (ages 3, 5, 7, 11)
* 	BAS II: 
* 		Naming Vocabulary in MCS 2 and 3 (3 variables)
* 		Pattern Construction in MCS 3 and 4  (3 variables)
* 		Picture Similarities in MCS 3 only (3 variables)
* 		Word Reading in MCS 4 only (3 variables)
* 		Verbal Similarities in MCS 5 only (3 variables)
* MCS 4 - age 7 
* 	NFER Progress in Maths (3 variables)
* MCS 6 - age 14
* 	APU Vocabulary Test of CM (Word activity score out of 20)	

* References: *https://cls.ucl.ac.uk/wp-content/uploads/2017/07/MCS-data-note-20131-Test-Scores-Roxanne-Connelly.pdf
*https://www.closer.ac.uk/wp-content/uploads/250820-Guide-to-cognitive-measures-in-five-British-birth-cohorts.pdf
*https://closer.ac.uk/cross-study-data-guides/cognitive-measures-guide/mcs-cognition/

* Name and label of variables: 
*	SMIL	:	Developmental milestones: smiles
*	SITU	:	Developmental milestones: sits up
*	STAN	:	Developmental milestones: stands up holding on
*	HAND	:	Developmental milestones: hands together
*	GRAB	:	Developmental milestones: grabs objects
*	PICK	:	Developmental milestones: holds small objects
*	PTOY	:	Developmental milestones: passes a toy
*	WALK	:	Developmental milestones: take child to park or playground
*	GIVE	:	Developmental milestones: gives toy
*	WAVE	:	Developmental milestones: waves bye-bye
*	ARMS	:	Developmental milestones: extend arms for being picked up
*	NODS	:	Developmental milestones: nods for yes
*	DCOSC	:	DV Bracken: Colours Raw Score
*	DCMAS	:	DV Bracken: Colours % mastery
*	DLESC	:	DV Bracken: Letters Raw Score
*	DLMAS	:	DV Bracken: Letters % mastery
*	DNOSC	:	DV Bracken: Numbers Raw Score
*	DNMAS	:	DV Bracken: Numbers % mastery
*	DSZSC	:	DV Bracken: Sizes Raw Score
*	DSMAS	:	DV Bracken: Size % mastery
*	DCMSC	:	DV Bracken: Comparisons Raw Score
*	DOMAS	:	DV Bracken: Comparisons % mastery
*	DSHSC	:	DV Bracken: Shapes Raw Score
*	DHMAS	:	DV Bracken: Shapes % mastery
*	DBSRC	:	DV Bracken: School Readiness Composite
*	DSRCM	:	DV Bracken: School Readiness Composite % mastery
*	DSRCS	:	DV Bracken: School Readiness Composit Standard Score
*	DSRCP	:	DV Bracken: School Readiness Composite Percentile
*	DSRCN	:	DV Bracken:School Readiness Comp Normativ Classificatn
*	DNVRS	:	DV BAS Naming Vocabulary - Raw Scores
*	DNVAB	:	DV BAS Naming Vocabulary - Ability Scores
*	DNVTS	:	DV BAS Naming Vocabulary - T-Scores
*	DPCRS	:	DV BAS Pattern Construction - Raw Scores
*	DPCAB	:	DV BAS Pattern Construction - Ability Scores
*	DPCTS	:	DV BAS Pattern Construction - T Scores
*	DPSRS	:	DV BAS Picture Similarities - Raw Scores
*	DPSAB	:	DV BAS Picture Similarities - Ability Scores
*	DPSTS	:	DV BAS Picture Similarities - T Scores
*	DWRRS	:	DV BAS Word Reading - Raw Scores
*	DWRAB	:	DV BAS Word Reading - Ability Scores
*	DWRTS	:	DV BAS Word Reading - T Scores
*	DVSRS	:	DV BAS Verbal Similarities - Raw Scores
*	DVSAB	:	DV BAS Verbal Similarities - Ability Scores
*	DVSTS	:	DV BAS Verbal Similarities - T Scores
*	CMTOTSCOR	:	DV NFER Maths Test  (Total Raw Score)
*	CMATHS7SC	:	DV NFER Maths Test (Raw score scaled to original test out of 28 marks)
*	CMATHS7SA	:	DV NFER Maths Test (Standardised Age Score based on standardisation in 2004)
*	CWRDSC	:	DV APU Vocabulary Test of CM (Word activity score out of 20)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
use "${mcs1}/mcs1_parent_cm_interview.dta", clear
global varlist "ACHAND00 ACGRAB00 ACPICK00 ACPTOY00 ACSITU00 ACSTAN00 ACWALK00 ACSMIL00 ACGIVE00 ACWAVE00 ACARMS00 ACNODS00"

keep if AELIG00==1

keep MCSID ACNUM00 ${varlist} 
gen SWEEP=1
tempfile mcs1
save `mcs1'


use "${mcs2}/mcs2_cm_cognitive_assessment.dta", clear
global varlist "BDBASR00 BDBASA00 BDBAST00 BDBSRC00 BDSRCM00 BDSRCS00 BDSRCP00 BDSRCN00 BDCOSC00 BDCMAS00 BDLESC00 BDLMAS00 BDNOSC00 BDNMAS00 BDSZSC00 BDSMAS00 BDCMSC00 BDOMAS00 BDSHSC00 BDHMAS00"

keep MCSID BCNUM00 ${varlist} 
gen SWEEP=2
tempfile mcs2
save `mcs2'


use "${mcs3}/mcs3_cm_cognitive_assessment.dta", clear

global varlist "CCNSCO00 CCNVABIL CCNVTSCORE CCCSCO00 CCPCABIL CCPCTSCORE CCPSCO00 CCPSABIL CCPSTSCORE"
label var CCPSTSCORE "COG: Picture Similarities T-score"
keep MCSID CCNUM00 ${varlist} 
gen SWEEP=3
tempfile mcs3
save `mcs3'


use "${mcs4}/mcs4_cm_cognitive_assessment.dta", clear
global varlist "DCTOTS00 DCPCAB00 DCPCTS00 DCWRSC00 DCWRAB00 DCWRSD00 DCMTOTSCOR DCMATHS7SC DCMATHS7SA"
keep MCSID DCNUM00 ${varlist} 
gen SWEEP=4
tempfile mcs4
save `mcs4'


use "${mcs5}mcs5_cm_derived.dta",clear	
global varlist "EVSRAW EVSABIL EVSTSCO"
keep MCSID ECNUM00 ${varlist} 
gen SWEEP=5
tempfile mcs5
save `mcs5'


use "${mcs6}/mcs6_cm_derived.dta",clear	
global varlist "FCWRDSC"
keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6
tempfile mcs6
save `mcs6'

use `mcs1' 
forvalues i=2(1)6{
append using 	`mcs`i''
}

tab FCWRDSC

*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

* MCS1 – 9 months – Developmental Milestones
* ACHAND00 ACGRAB00 ACPICK00 ACPTOY00 ACSITU00 ACSTAN00 ACWALK00 ACSMIL00 ACGIVE00 ACWAVE00 ACARMS00 ACNODS00

label var ACHAND00 "Developmental milestones: hands together"
label var ACGRAB00 "Developmental milestones: grabs objects"
label var ACPICK00 "Developmental milestones: holds small objects"
label var ACPTOY00 "Developmental milestones: passes a toy"
label var ACSITU00 "Developmental milestones: sits up"
label var ACSTAN00 "Developmental milestones: stands up holding on"
label var ACWALK00 "Developmental milestones: take child to park or playground"
label var ACSMIL00 "Developmental milestones: smiles"
label var ACGIVE00 "Developmental milestones: gives toy"
label var ACWAVE00 "Developmental milestones: waves bye-bye"
label var ACARMS00 "Developmental milestones: extend arms for being picked up"
label var ACNODS00 "Developmental milestones: nods for yes"

rename	ACHAND00	HAND
rename	ACGRAB00	GRAB
rename	ACPICK00	PICK
rename	ACPTOY00	PTOY
rename	ACSITU00	SITU
rename	ACSTAN00	STAN
rename	ACWALK00	WALK
rename	ACSMIL00	SMIL
rename	ACGIVE00	GIVE
rename	ACWAVE00	WAVE
rename	ACARMS00	ARMS
rename	ACNODS00	NODS

* MCS2 - age 3
*BDBASR00 BDBASA00 BDBAST00 BDBSRC00 BDSRCM00 BDSRCS00 BDSRCP00 BDSRCN00 BDCOSC00 BDCMAS00 BDLESC00 BDLMAS00 BDNOSC00 BDNMAS00 BDSZSC00 BDSMAS00 BDCMSC00 BDOMAS00 BDSHSC00 BDHMAS00

rename	BDCOSC00	DCOSC
rename	BDLESC00	DLESC
rename	BDNOSC00	DNOSC
rename	BDSZSC00	DSZSC
rename	BDCMSC00	DCMSC
rename	BDSHSC00	DSHSC
rename	BDBSRC00	DBSRC
rename	BDCMAS00	DCMAS
rename	BDLMAS00	DLMAS
rename	BDNMAS00	DNMAS
rename	BDSMAS00	DSMAS
rename	BDOMAS00	DOMAS
rename	BDHMAS00	DHMAS
rename	BDSRCM00	DSRCM
rename	BDSRCS00	DSRCS
rename	BDSRCP00	DSRCP
rename	BDSRCN00	DSRCN

* DCOSC DLESC DNOSC DSZSC DCMSC DSHSC DBSRC DCMAS DLMAS DNMAS DSMAS DOMAS DHMAS DSRCM DSRCS DSRCP DSRCN

* BAS II - MCS 2, 3, 4, 5

* BAS II - Naming Vocabulary in MCS 2 and 3
gen DNVRS=. 
replace DNVRS=BDBASR00 if SWEEP ==2
replace DNVRS=CCNSCO00 if SWEEP ==3
label var DNVRS	"DV BAS Naming Vocabulary - Raw Scores"
gen DNVAB=. 
replace DNVAB=BDBASA00  if SWEEP ==2
replace DNVAB=CCNVABIL if SWEEP ==3
label var DNVAB	"DV BAS Naming Vocabulary - Ability Scores"
gen DNVTS=. 
replace DNVTS=BDBAST00    if SWEEP ==2
replace DNVTS=CCNVTSCORE if SWEEP ==3
label var DNVTS	"DV BAS Naming Vocabulary - T-Scores"
 

* BAS II - Pattern Construction in MCS 3 and 4
gen DPCRS=. 
replace DPCRS=CCCSCO00 if SWEEP ==3
replace DPCRS=DCTOTS00 if SWEEP ==4
label var DPCRS	"DV BAS Pattern Construction - Raw Scores"
gen DPCAB=. 
replace DPCAB=CCPCABIL if SWEEP ==3
replace DPCAB=DCPCAB00 if SWEEP ==4
label var DPCAB	"DV BAS Pattern Construction - Ability Scores"
gen DPCTS=. 
replace DPCTS=CCPCTSCORE if SWEEP ==3
replace DPCTS=DCPCTS00   if SWEEP ==4
label var DPCTS	"DV BAS Pattern Construction - T Scores"


* BAS II - Picture Similarities in MCS 3 only
gen DPSRS=. 
replace DPSRS=CCPSCO00 if SWEEP ==3
label var DPSRS	"DV BAS Picture Similarities - Raw Scores"
gen DPSAB=. 
replace DPSAB=CCPSABIL if SWEEP ==3
label var DPSAB	"DV BAS Picture Similarities - Ability Scores"
gen DPSTS=. 
replace DPSTS=CCPSTSCORE if SWEEP ==3
label var DPSTS	"DV BAS Picture Similarities - T Scores"



* BAS II - Word Reading in MCS 4 only
gen DWRRS=. 
replace DWRRS=DCWRSC00 if SWEEP ==4
label var DWRRS	"DV BAS Word Reading - Raw Scores"
gen DWRAB=. 
replace DWRAB=DCWRAB00 if SWEEP ==4
label var DWRAB	"DV BAS Word Reading - Ability Scores"
gen DWRTS=. 
replace DWRTS=DCWRSD00 if SWEEP ==4
label var DWRTS	"DV BAS Word Reading - T Scores"


* BAS II - Verbal Similarities in MCS 5 only
gen DVSRS=. 
replace DVSRS=EVSRAW if SWEEP ==5
label var DVSRS	"DV BAS Verbal Similarities - Raw Scores"
gen DVSAB=. 
replace DVSAB=EVSABIL if SWEEP ==5
label var DVSAB	"DV BAS Verbal Similarities - Ability Scores"
gen DVSTS=. 
replace DVSTS=EVSTSCO if SWEEP ==5
label var DVSTS	"DV BAS Verbal Similarities - T Scores"



* DNVRS DNVAB DNVTS DPCRS DPCAB DPCTS DPSRS DPSAB DPSTS DWRRS DWRAB DWRTS DVSRS DVSAB DVSTS

* NFER Progress in Maths in MCS 4 - AGE 7

rename DCMTOTSCOR CMTOTSCOR 
rename DCMATHS7SC CMATHS7SC 
rename DCMATHS7SA CMATHS7SA
label var CMTOTSCOR "DV NFER Maths Test  (Total Raw Score)"
label var CMATHS7SC "DV NFER Maths Test (Raw score scaled to original test out of 28 marks)"
label var CMATHS7SA "DV NFER Maths Test (Standardised Age Score based on standardisation in 2004)"
* CMTOTSCOR CMATHS7SC  CMATHS7SA


* MCS 6 - Age 14
* APU Vocabulary Test (Word activity score out of 20)	
clonevar CWRDSC=FCWRDSC if SWEEP==6
sum CWRDSC
label var CWRDSC "DV APU Vocabulary Test of CM (Word activity score out of 20)"



*  List of variables for longitudinal file

* MCS1 – 9 months
* Developmental Milestones
* SMIL SITU STAN HAND GRAB PICK PTOY WALK GIVE WAVE ARMS NODS

* MCS2 - age 3
* Bracken  Bracken: School Readiness with al subitems

* Bracken Colours: raw and percentage score
* DCOSC DCMAS 
* Bracken Letters: raw and percentage score
* DLESC DLMAS
* Bracken Numbers: raw and percentage score
* DNOSC DNMAS 
* Bracken Sizes: raw and percentage score
* DSZSC DSMAS 
* Bracken Comparisons: raw and percentage score
* DCMSC DOMAS
* Bracken Shapes: raw and percentage score
* DSHSC DHMAS
* Bracken: School Readiness Composite: raw and percentage score  
* DBSRC DSRCM  
* Bracken: School Readiness Composite: standardised, percentile, normative classification
* DSRCS DSRCP DSRCN

* 
* BAS II - MCS 2, 3, 4, 5
* BAS II - Naming Vocabulary in MCS 2 and 3
* DNVRS DNVAB DNVTS
* BAS II - Pattern Construction in MCS 3 and 4 
* DPCRS DPCAB DPCTS 
* BAS II - Picture Similarities in MCS 3 only
* DPSRS DPSAB DPSTS 
* BAS II - Word Reading in MCS 4 only
* DWRRS DWRAB DWRTS 
* BAS II - Verbal Similarities in MCS 5 only
* DVSRS DVSAB DVSTS

* NFER Progress in Maths in MCS 4 - AGE 7
* CMTOTSCOR CMATHS7SC CMATHS7SA

* APU Vocabulary Test (Word activity score out of 20)
* CWRDSC

* ------------------------------
* Refusal / Don't know / Not applicable
label define common3 -9 "Refusal" -8 "Don't know" -1 "Not applicable", replace
foreach v in SITU STAN HAND PICK PTOY WALK GIVE WAVE ARMS NODS DPCRS {
    label values `v' common3
}

tab1 SITU STAN HAND PICK PTOY WALK GIVE WAVE ARMS NODS DPCRS
* ------------------------------
* DCOSC / DCMAS
label define dco -7 "Not carried out" -1 "Not applicable"
label values DCOSC dco
label values DCMAS dco
tab1 DCOSC DCMAS

* DLESC / DLMAS / DNOSC / DNMAS / DSZSC / DCMSC / DSHSC / DBSRC
label define dl -7 "Not carried out" -4 "Sub-test not completed" -1 "Not applicable", replace
foreach v in DLESC DLMAS DNOSC DNMAS DSZSC DCMSC DSHSC DBSRC {
    label values `v' dl
}

tab1 DLESC DLMAS DNOSC DNMAS DSZSC DCMSC DSHSC DBSRC
* DSMAS / DOMAS / DHMAS / DSRCM / DPCAB / DPCTS / DPSRS / DWRRS / DWRAB / DWRTS / DVSAB / DVSTS / CMTOTSCOR / CMATHS7SC / CMATHS7SA
label define onlyna -1 "Not applicable"
foreach v in DSMAS DOMAS DHMAS DSRCM DPCAB DPCTS DPSRS DWRRS DWRAB DWRTS DVSAB DVSTS CMTOTSCOR CMATHS7SC CMATHS7SA {
    label values `v' onlyna
}

tab1 DSMAS DOMAS DHMAS DSRCM DPCAB DPCTS DPSRS DWRRS DWRAB DWRTS DVSAB DVSTS CMTOTSCOR CMATHS7SC CMATHS7SA
* DSRCS / DSRCP / DSRCN
label define dsr -7 "Not carried out" -4 "Sub-test not completed" -3 "Age unknown" -1 "Not applicable", replace
foreach v in DSRCS DSRCP DSRCN {
    label values `v' dsr
}

tab1 DSRCS DSRCP DSRCN
* DNVRS / DNVAB / DNVTS
label define dnv -8 "Ended early" -7 "Not carried out" -6 "Not administered" -1 "Not applicable", replace
foreach v in DNVRS DNVAB DNVTS {
    label values `v' dnv
}

tab1 DNVRS DNVAB DNVTS 
* DVSRS
label define dvs -2 "Invalid due to routing error" -1 "Not applicable"
label values DVSRS dvs

tab DVSRS
* CWRDSC
label define cwr -3 "Software error/respondent completed wrong activity" -1 "Not applicable", replace
label values CWRDSC cwr
tab CWRDSC
*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
replace  CNUM00=ACNUM00 if SWEEP==1
replace  CNUM00=BCNUM00 if SWEEP==2
replace  CNUM00=CCNUM00 if SWEEP==3
replace  CNUM00=DCNUM00 if SWEEP==4
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6


keep SWEEP MCSID CNUM00 ///
SMIL SITU STAN HAND GRAB PICK PTOY WALK GIVE WAVE ARMS NODS ///
DCOSC DCMAS DLESC DLMAS DNOSC DNMAS DSZSC DSMAS DCMSC DOMAS DSHSC DHMAS ///
DBSRC DSRCM DSRCS DSRCP DSRCN ///
DNVRS DNVAB DNVTS ///
DPCRS DPCAB DPCTS ///
DPSRS DPSAB DPSTS /// 
DWRRS DWRAB DWRTS /// 
DVSRS DVSAB DVSTS ///
CMTOTSCOR CMATHS7SC CMATHS7SA ///
CWRDSC


order SWEEP MCSID CNUM00 ///
SMIL SITU STAN HAND GRAB PICK PTOY WALK GIVE WAVE ARMS NODS ///
DCOSC DCMAS DLESC DLMAS DNOSC DNMAS DSZSC DSMAS DCMSC DOMAS DSHSC DHMAS ///
DBSRC DSRCM DSRCS DSRCP DSRCN ///
DNVRS DNVAB DNVTS ///
DPCRS DPCAB DPCTS ///
DPSRS DPSAB DPSTS /// 
DWRRS DWRAB DWRTS /// 
DVSRS DVSAB DVSTS ///
CMTOTSCOR CMATHS7SC CMATHS7SA ///
CWRDSC

bys SWEEP: sum SMIL SITU STAN HAND GRAB PICK PTOY WALK GIVE WAVE ARMS NODS ///
DCOSC DCMAS DLESC DLMAS DNOSC DNMAS DSZSC DSMAS DCMSC DOMAS DSHSC DHMAS ///
DBSRC DSRCM DSRCS DSRCP DSRCN ///
DNVRS DNVAB DNVTS ///
DPCRS DPCAB DPCTS ///
DPSRS DPSAB DPSTS /// 
DWRRS DWRAB DWRTS /// 
DVSRS DVSAB DVSTS ///
CMTOTSCOR CMATHS7SC CMATHS7SA ///
CWRDSC


compress

save "${temp_data_cdv}COGNITIVE.dta" ,replace



