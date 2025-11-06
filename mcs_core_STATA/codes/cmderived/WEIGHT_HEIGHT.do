
* WEIGHT	:	Weight (kilograms), measured or self-report
* HEIGHT	:	Height (centimetres), measured or self-report
* BMI_CLS	:	DV Cohort Member BMI according to present weight (calculated by CLS)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

*mcs2
use "${mcs2}mcs2_cm_interview.dta", clear
rename *, lower

tab1  bcwtkc00 bchcmc00
gen bmi =bcwtkc00/(( bchcmc00/100)^2) if bcwtkc00>0& bchcmc00>0
* -2 No Measurement taken   |        771       4.89       4.89       4.89
* -1 Not answered / missing |        164       1.04       1.04       5.93
recode bcwtkc00 bchcmc00 (-2=-1) (-1=-8)

clonevar bmi_cls=bcbmin00
clonevar weight=bcwtkc00
clonevar height=bchcmc00

gen sweep=2
clonevar cnum=bcnum00
keep mcsid cnum sweep bmi bmi_cls weight height
tempfile mcs2
save `mcs2'



use "${mcs3}mcs3_cm_interview.dta", clear

rename *, lower
tab1  ccwtcm00 cchtcm00
* -1    Not applicable
clonevar bmi_cls=bmin3
gen bmi= ccwtcm00/((cchtcm00/100)^2) if cchtcm00>=0& ccwtcm00>=0
sum bmi
clonevar weight=ccwtcm00
clonevar height=cchtcm00
sum bmi weight height
gen sweep=3
clonevar cnum=ccnum00
keep mcsid cnum sweep bmi bmi_cls weight height
tempfile mcs3
save `mcs3'



use "${mcs4}mcs4_cm_interview.dta", clear
rename *, lower
* -8   Don''t know    |          6       0.04       0.04       0.04
* -1   Not applicable

tab1 dcwtdv00 dchtdv00
*rename dcbmin4 bmi
clonevar weight=dcwtdv00
clonevar height=dchtdv00
gen bmi= dcwtdv00/((dchtdv00/100)^2) if dchtdv00>=0& dcwtdv00>=0

clonevar bmi_cls=dcbmin4

sum bmi weight height
gen sweep=4
clonevar cnum=dcnum00
keep mcsid cnum sweep bmi bmi_cls weight height
tempfile mcs4
save `mcs4'

use "${mcs5}mcs5_cm_interview.dta", clear
rename *, lower
* -7    No answer      |         59       0.44       0.44       0.44
* -1    Not applicable
recode ecwtcmb0 echtcmb0 (-7=-8)
tab1 ecwtcmb0 echtcmb0
*rename ebmin5 bmi


clonevar weight=ecwtcmb0
clonevar height=echtcmb0
gen bmi= ecwtcmb0/((echtcmb0/100)^2) if echtcmb0>=0& ecwtcmb0>=0
replace bmi=. if bmi<0
clonevar bmi_cls=ebmin5

sum bmi weight height
gen sweep=5
clonevar cnum=ecnum00
keep mcsid cnum sweep bmi bmi_cls weight height
tempfile mcs5
save `mcs5'

use "${mcs6}mcs6_cm_interview.dta", clear
rename *, lower
tab1 fcwtcm00 
*-1    Not applicable
tab1 fchtcm00
* -5    UNABLE TO OBTAIN HEIGHT MEASUREMENT|          1       0.01       0.01       0.01                                           
* -1    Not applicable
recode fcwtcm00 fchtcm00 (-5=-8)

gen bmi= fcwtcm00 /((fchtcm00/100)^2) if fcwtcm00>=0 & fchtcm00>=0 
clonevar weight=fcwtcm00
clonevar height=fchtcm00

sum bmi weight height
gen sweep=6
clonevar cnum=fcnum00
keep mcsid cnum sweep bmi  weight height
tempfile mcs6
save `mcs6'

use "${mcs6}mcs6_cm_derived.dta", clear
rename *, lower
clonevar cnum=fcnum00
clonevar bmi_cls=fcbmin6
keep mcsid cnum bmi_cls
tempfile mcs6_2
save `mcs6_2'

use `mcs6'
merge 1:1 mcsid cnum using `mcs6_2' 
drop _merge
tempfile mcs6
save `mcs6'



use "${mcs7}mcs7_cm_interview.dta", clear
rename *, lower
tab1 gcwtcm00 gchtcm00
*-5    Unable to obtain height measurement |          2       0.02       0.02       0.02                     |               
 *       -1    Not applicable
recode gcwtcm00 gchtcm00 (-5=-8)

gen bmi= gcwtcm00 /((gchtcm00/100)^2) if gcwtcm00>=0 & gchtcm00>=0 

clonevar weight=gcwtcm00
clonevar height=gchtcm00
sum bmi weight height
gen sweep=7
clonevar cnum=gcnum00
keep mcsid cnum sweep bmi  weight height
tempfile mcs7
save `mcs7'

use "${mcs7}mcs7_cm_derived.dta", clear
rename *, lower
clonevar cnum=gcnum00
clonevar bmi_cls=gcbmin7
keep mcsid cnum bmi_cls
tempfile mcs7_2
save `mcs7_2'

use `mcs7'
merge 1:1 mcsid cnum using `mcs7_2' 
drop _merge
replace sweep=7 if sweep==.
tempfile mcs7
save `mcs7'


use `mcs2'
forvalues i=3(1)7{
append  using `mcs`i''	
}

rename *, upper

rename CNUM CNUM00


drop BMI
*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed
sum BMI WEIGHT HEIGHT BMI_CLS

label define nsnrlb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ,replace
label val WEIGHT HEIGHT nsnrlb
tab1 WEIGHT HEIGHT

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

label var WEIGHT "Weight (kilograms), measured or self-report"
label var HEIGHT "Height (centimetres), measured or self-report"
label var BMI_CLS "DV Cohort Member BMI according to present weight (calculated by CLS)"

sum WEIGHT HEIGHT BMI_CLS
*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key

compress
save "${temp_data_cdv}WEIGHT_HEIGHT.dta" ,replace



