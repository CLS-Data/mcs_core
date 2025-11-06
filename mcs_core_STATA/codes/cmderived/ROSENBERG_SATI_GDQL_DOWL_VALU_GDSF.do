
* Rosenberg Self-esteem 
*ROSENBERG	:	DV Rosenberg Self-esteem Score (0-15)
*SATI	:	RosenbergGrid: On the whole, I am satisfied with myself
*GDQL	:	RosenbergGrid: I feel I have a number of good qualities
*DOWL	:	RosenbergGrid: I am able to do things as well as most other people
*VALU	:	RosenbergGrid: I am a person of value
*GDSF	:	RosenbergGrid: I feel good about myself
*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs5}mcs5_cm_interview.dta",clear	
global varlist "ECQ11A00 ECQ11B00 ECQ11C00 ECQ11D00 ECQ11E00"
keep MCSID ECNUM00 ${varlist} 
gen SWEEP=5
tempfile mcs5
save `mcs5'


use "${mcs6}mcs6_cm_interview.dta",clear	
global varlist "FCSATI00 FCGDQL00 FCDOWL00 FCVALU00 FCGDSF00"
keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6
tempfile mcs6
save `mcs6'

use "${mcs7}mcs7_cm_interview.dta",clear	
global varlist "GCSATI00 GCGDQL00 GCDOWL00 GCVALU00 GCGDSF00"
keep MCSID GCNUM00 ${varlist} 
gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs5' 
forvalues i=6(1)7{
append using 	`mcs`i''
}


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

tab1 ECQ11A00 ECQ11B00 ECQ11C00 ECQ11D00 ECQ11E00


recode ECQ11A00 ECQ11B00 ECQ11C00 ECQ11D00 ECQ11E00 (-8=-9) // recode  -8 "No answer" to -9 "Don't want to answer"
 
tab1 FCSATI00 FCGDQL00 FCDOWL00 FCVALU00 FCGDSF00

tab1 GCSATI00 GCGDQL00 GCDOWL00 GCVALU00 GCGDSF00

recode GCSATI00 GCGDQL00 GCDOWL00 GCVALU00 GCGDSF00 (5=-8) (6=-9) (7=-9) // 



*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format


gen SATI=.
gen GDQL=.
gen DOWL=.
gen VALU=.
gen GDSF=.

replace SATI=ECQ11A00  if SWEEP==5
replace GDQL=ECQ11B00  if SWEEP==5
replace DOWL=ECQ11C00  if SWEEP==5
replace VALU=ECQ11D00  if SWEEP==5
replace GDSF=ECQ11E00  if SWEEP==5


replace SATI=FCSATI00 if SWEEP==6
replace GDQL=FCGDQL00 if SWEEP==6
replace DOWL=FCDOWL00 if SWEEP==6
replace VALU=FCVALU00 if SWEEP==6
replace GDSF=FCGDSF00 if SWEEP==6

replace SATI=GCSATI00  if SWEEP==7
replace GDQL=GCGDQL00  if SWEEP==7
replace DOWL=GCDOWL00  if SWEEP==7
replace VALU=GCVALU00  if SWEEP==7
replace GDSF=GCGDSF00  if SWEEP==7

tab SATI SWEEP

tab SATI GDQL

tab VALU SWEEP

clonevar SATI_AUX=SATI
clonevar GDQL_AUX=GDQL
clonevar DOWL_AUX=DOWL
clonevar VALU_AUX=VALU
clonevar GDSF_AUX=GDSF


recode SATI_AUX GDQL_AUX DOWL_AUX VALU_AUX GDSF_AUX (-9/-1=.)
recode SATI_AUX GDQL_AUX DOWL_AUX VALU_AUX GDSF_AUX (4=0) (3=1) (2=2) (1=3)


label var SATI "RosenbergGrid: On the whole, I am satisfied with myself"
label var GDQL "RosenbergGrid: I feel I have a number of good qualities"
label var DOWL "RosenbergGrid: I am able to do things as well as most other people"  
label var VALU "RosenbergGrid: I am a person of value"   
label var GDSF "RosenbergGrid: I feel good about myself" 

label def RosenbergGridlb -9 "Don't want to answer" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Strongly agree" ///
           2 "Agree" ///
           3 "Disagree" ///
           4 "Strongly disagree", replace 
label val SATI GDQL DOWL VALU GDSF RosenbergGridlb
		   
tab SATI SWEEP, m



gen DROSENBERG=SATI_AUX +GDQL_AUX +DOWL_AUX +VALU_AUX +GDSF_AUX

foreach var in SATI GDQL DOWL VALU GDSF {	
replace DROSENBERG=-1	if `var'==-8  |`var'==-9 |`var'==-1
}
label def DROSENBERGlb  -1 "Not applicable" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" , replace

label var DROSENBERG "DV Rosenberg Self-esteem Score (0-15)"
label val DROSENBERG DROSENBERGlb
tab DROSENBERG SWEEP, m


drop *_AUX 
*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
*replace  CNUM00=ACNUM00 if SWEEP==1
*replace  CNUM00=BCNUM00 if SWEEP==2
*replace  CNUM00=CCNUM00 if SWEEP==3
*replace  CNUM00=DCNUM00 if SWEEP==4
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep SWEEP MCSID CNUM00 DROSENBERG SATI GDQL DOWL VALU GDSF

compress
save "${temp_data_cdv}ROSENBERG_SATI_GDQL_DOWL_VALU_GDSF.dta" ,replace

