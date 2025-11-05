

*XAGE_C 	:	Actual age (CLOSER)
*WT_C 		:	Harmonised weight (CLOSER)
*WTSELF_C 	:	Weight, measured or self-report (CLOSER)
*WTIMP_C 	:	Weight, imperial or metric (CLOSER)
*WTPRE_C 	:	Weight (precision) (CLOSER)
*HT_C 		:	Harmonised height (CLOSER)
*HTSELF_C 	:	Height, measured or self-report (CLOSER)
*HTIMP_C 	:	Height, imperial or metric (CLOSER)
*HTPRE_C 	:	Height (precision) (CLOSER)
*BMI_C 		:	Body mass index (kg/m2) (CLOSER)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${closer}/mcs_closer_wp1.dta", clear

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
rename *, upper

gen CNUM00=1 // See Closer documentation.  

gen SWEEP=.
replace SWEEP=1 if VISITAGE==1
replace SWEEP=2 if VISITAGE==3
replace SWEEP=3 if VISITAGE==5
replace SWEEP=4 if VISITAGE==7
replace SWEEP=5 if VISITAGE==11



foreach v of varlist XAGE WT WTSELF WTIMP WTPRE HT HTSELF HTIMP HTPRE BMI { 

	di "label var `v' " `"`: var label `v''"' " (CLOSER)" 

}

label var XAGE "Actual age (CLOSER)"
label var WT "Harmonised weight (kilograms) (CLOSER)"
label var WTSELF "Weight, measured or self-report (CLOSER)"
label var WTIMP "Weight, imperial or metric (CLOSER)"
label var WTPRE "Weight (precision) (CLOSER)"
label var HT "Harmonised height (metres) (CLOSER)"
label var HTSELF "Height, measured or self-report (CLOSER)"
label var HTIMP "Height, imperial or metric (CLOSER)"
label var HTPRE "Height (precision) (CLOSER)"
label var BMI "Body mass index (kg/m2) (CLOSER)"


*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
compress
keep MCSID CNUM00 SWEEP XAGE WT WTSELF WTIMP WTPRE HT HTSELF HTIMP HTPRE BMI 

rename *, upper
order MCSID CNUM00 SWEEP XAGE WT WTSELF WTIMP WTPRE HT HTSELF HTIMP HTPRE BMI 

drop WTSELF WTIMP WTPRE HTSELF HTIMP HTPRE

foreach v of varlist XAGE WT  HT  BMI { 
	rename `v' `v'_C
}

drop if SWEEP==.
save "${temp_data_cdv}CLOSER_BMI_WT_HT_XAGE.dta" ,replace


