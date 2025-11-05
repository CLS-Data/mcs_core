* Crime
*WEAPON: Carried a weapon in the last 12 months
*POLSTO: Ever stopped by the police
*POLARE: Ever cautioned or arrested by the police
*VICPHY: Physically assaulted in the last 12 months
*VICWEA: Assaulted with a weapon in the last 12 months
*VICSEX: Victim of sexual assault in the last 12 months
*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data


use "${mcs6}mcs6_cm_interview.dta",clear	
global varlist "FCKNIF00 FCPOLS00 FCCAUT00 FCARES00 FCVICA00 FCVICC00 FCVICF0A"

keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6
tempfile mcs6
save `mcs6'

use "${mcs7}mcs7_cm_interview.dta",clear	
global varlist "GCKNIF00 GCPOLS00 GCCAUT00 GCARES00  GCVICA00  GCVICC00  GCVICS00"
keep MCSID GCNUM00 ${varlist} 
gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs6' 
append using 	`mcs7'



*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

recode GCKNIF00 GCPOLS00 GCVICA00 GCVICC00 GCVICS00 (3=-8) (4=-9) (5=-1)

* FPOLCAUARR
gen FPOLCAUARR = .
replace FPOLCAUARR = -1 if inlist(FCCAUT00,-9,-8,-1) & inlist(FCARES00,-9,-8,-1)
replace FPOLCAUARR =  1 if FCCAUT00==1 | FCARES00==1
replace FPOLCAUARR =  0 if FPOLCAUARR==.

*  GPOLCAUARR
gen GPOLCAUARR = .
replace GPOLCAUARR = -1 if inlist(GCCAUT00,3,4,5) & inlist(GCARES00,3,4,5)
replace GPOLCAUARR =  1 if GCCAUT00==1 | GCARES00==1
replace GPOLCAUARR =  0 if GPOLCAUARR==.

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format


* WEAPON
gen WEAPON = .
replace WEAPON = FCKNIF00 if SWEEP==6
replace WEAPON = GCKNIF00 if SWEEP==7
recode WEAPON (2=0)

* POLSTO
gen POLSTO = .
replace POLSTO = FCPOLS00 if SWEEP==6
replace POLSTO = GCPOLS00 if SWEEP==7
recode POLSTO (2=0)

* POLARE 
gen POLARE = .
replace POLARE = FPOLCAUARR if SWEEP==6
replace POLARE = GPOLCAUARR if SWEEP==7

* VICPHY
gen VICPHY = .
replace VICPHY = FCVICA00 if SWEEP==6
replace VICPHY = GCVICA00 if SWEEP==7
recode VICPHY (2=0)

* VICWEA
gen VICWEA = .
replace VICWEA = FCVICC00 if SWEEP==6
replace VICWEA = GCVICC00 if SWEEP==7
recode VICWEA (2=0)

* VICSEX
gen VICSEX = .
replace VICSEX = FCVICF0A if SWEEP==6
replace VICSEX = GCVICS00 if SWEEP==7
recode VICSEX (2=0)

  
label var WEAPON "Ever carried a knife or a weapon"
label var POLSTO "Ever stopped or questioned by police"
label var POLARE "Ever cautioned, received warning or arrested by police"
label var VICPHY "Physically assaulted in the last 12 months"
label var VICWEA "Assaulted with a weapon in the last 12 months"
label var VICSEX "Sexually assaulted in the last 12 months"

label def CRIME_lb    -9 "Don't want to answer" ///
					-8 "Don't know"  ///
					-1 "Not Applicable/No answer"  ///
					0 "No"  ///
					1 "Yes"    ,  replace
label val WEAPON POLSTO POLARE VICPHY VICWEA VICSEX CRIME_lb		   


*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep MCSID CNUM00 SWEEP WEAPON POLSTO POLARE VICPHY VICWEA VICSEX
compress
save "${temp_data_cdv}CRIME.dta" ,replace

