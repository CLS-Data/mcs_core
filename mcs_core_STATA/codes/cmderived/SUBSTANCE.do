* Substance Use 
* ALCOEV: Ever had an alcoholic drink
* ALCOFR: Frequency of alcohol drinks in the past four weeks
* ALCOBI: Ever had five or more drinks at a time
* SMOKCI: Ever tried smoking
* SMOKVA: Ever tried e-cigarettes or vapes
* DRUGCA: Ever tried cannabis
* DRUGHA: Ever tried hard drugs

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs5}mcs5_cm_interview.dta",clear	
global varlist "ECQ61X00  ECQ64X00  ECQ67X00  ECQ59X00"
keep MCSID ECNUM00 ${varlist} 
gen SWEEP=5
tempfile mcs5
save `mcs5'

use "${mcs6}mcs6_cm_interview.dta",clear	
global varlist "FCALCD00 FCALNF00 FCALFV00 FCSMOK00 FCECIG00 FCCANB00 FCOTDR00"
keep MCSID FCNUM00 ${varlist} 
gen SWEEP=6
tempfile mcs6
save `mcs6'

use "${mcs7}mcs7_cm_interview.dta",clear	
global varlist "GCALCD00 GCALNF00 GCALFV00 GCSMOK00 GCVAPE00 GCDRUA00 GCDRUB00 GCDRUC00 GCDRUD00 GCDRUL00 GCDRUI00 GCDRUJ00 GCDRUK00"
keep MCSID GCNUM00 ${varlist} 

foreach v in GCDRUB00 GCDRUC00 GCDRUD00 GCDRUL00 GCDRUI00 GCDRUJ00 GCDRUK00 {
gen `v'_aux=1 if inlist(`v',3,4,5)
gen `v'_one=1 if `v'==1
}

egen all_345 = rowtotal(GCDRUB00_aux GCDRUC00_aux GCDRUD00_aux GCDRUL00_aux GCDRUI00_aux GCDRUJ00_aux GCDRUK00_aux)
tab all_345

egen any_eq1 = rowtotal(GCDRUB00_one GCDRUC00_one GCDRUD00_one GCDRUL00_one GCDRUI00_one GCDRUJ00_one GCDRUK00_one)
tab any_eq1
* GHARDDRUG: 
gen GHARDDRUG = 2
replace GHARDDRUG = -1 if all_345 == 7
replace GHARDDRUG =  1 if any_eq1  > 0

keep MCSID GCNUM00 GCALCD00 GCALNF00 GCALFV00 GCSMOK00 GCVAPE00 GCDRUA00 GHARDDRUG

gen SWEEP=7
tempfile mcs7
save `mcs7'

use `mcs5' 
forvalues i=6(1)7{
append using 	`mcs`i''
}


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

recode ECQ61X00  ECQ64X00  ECQ67X00  ECQ59X00  (8=-1)
recode FCSMOK00 (1=2) (2/6=1)
recode FCECIG00 (1=2) (2/4=1)
recode GCALCD00 GCALFV00 (3=-8) (4=-9) (5=-1)
recode GCSMOK00 (1=2) (2/6=1) (7=-8) (8=-9) (9=-1)
recode GCDRUA00 (3=-8) (4=-9) (5=-1)
recode GCALNF00 (8=-8) (9=-9) (10=-1)
recode GCVAPE00 (1=2) (2/6=1) (7=-8) (8=-9) (9=-1)

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format


* ALCOEV
gen ALCOEV = .
replace ALCOEV = ECQ61X00 if SWEEP==5
replace ALCOEV = FCALCD00 if SWEEP==6
replace ALCOEV = GCALCD00 if SWEEP==7
recode ALCOEV (2=0)

* ALCOFR
gen ALCOFR = .
replace ALCOFR = ECQ64X00 if SWEEP==5
replace ALCOFR = FCALNF00 if SWEEP==6
replace ALCOFR = GCALNF00 if SWEEP==7
* (no se aplica recode en R)

* ALCOBI
gen ALCOBI = .
replace ALCOBI = ECQ67X00 if SWEEP==5
replace ALCOBI = FCALFV00 if SWEEP==6
replace ALCOBI = GCALFV00 if SWEEP==7
recode ALCOBI (2=0)

* SMOKCI
gen SMOKCI = .
replace SMOKCI = ECQ59X00 if SWEEP==5
replace SMOKCI = FCSMOK00 if SWEEP==6
replace SMOKCI = GCSMOK00 if SWEEP==7
recode SMOKCI (2=0)

* SMOKVA
gen SMOKVA = .
replace SMOKVA = FCECIG00 if SWEEP==6
replace SMOKVA = GCVAPE00 if SWEEP==7
recode SMOKVA (2=0)

* DRUGCA
gen DRUGCA = .
replace DRUGCA = FCCANB00 if SWEEP==6
replace DRUGCA = GCDRUA00 if SWEEP==7
recode DRUGCA (2=0)

* DRUGHA
gen DRUGHA = .
replace DRUGHA = FCOTDR00 if SWEEP==6
replace DRUGHA = GHARDDRUG if SWEEP==7
recode DRUGHA (2=0)

*------------------------------------------------------------

label var ALCOEV  "Ever had an alcoholic drink"
label var ALCOFR  "Alcoholic drink frequency in the last 4 weeks"
label var ALCOBI  "Ever had five or more alcoholic drinks at a time"
label var SMOKCI  "Ever smoked a cigarette"
label var SMOKVA  "Ever smoked an e-cigarette or used a vape"
label var DRUGCA  "Ever taken cannabis/marijuana/weed"
label var DRUGHA  "Ever taken hard drugs (cocaine, acid/LSD, ecstasy, speed, ketamine, mephedrone, psychoactive substances)"

*------------------------------------------------------------
* ALCOEV
label define ALCOEV_lb ///
    -9 "Don't want to answer" ///
    -8 "No answer/Don't know" ///
    -1 "Not Applicable" ///
     0 "No" ///
     1 "Yes"
label values ALCOEV ALCOEV_lb

* ALCOFR
label define ALCOFR_lb ///
    -9 "Don't want to answer" ///
    -8 "No answer/Don't know" ///
    -1 "Not Applicable" ///
     1 "Never" ///
     2 "1-2 times" ///
     3 "3-5 times" ///
     4 "6-9 times" ///
     5 "10-19 times" ///
     6 "20-39 times" ///
     7 "40+ times"
label values ALCOFR ALCOFR_lb

* ALCOBI
label define ALCOBI_lb ///
    -9 "Don't want to answer" ///
    -8 "Don't know" ///
    -1 "Not Applicable" ///
     0 "No" ///
     1 "Yes"
label values ALCOBI ALCOBI_lb

* SMOKCI
label define SMOKCI_lb ///
    -9 "Don't want to answer" ///
    -8 "Don't know" ///
    -1 "Not Applicable" ///
     0 "No" ///
     1 "Yes"
label values SMOKCI SMOKCI_lb

* SMOKVA
label define SMOKVA_lb ///
    -9 "Don't want to answer" ///
    -8 "Don't know" ///
    -1 "Not Applicable" ///
     0 "No" ///
     1 "Yes"
label values SMOKVA SMOKVA_lb

* DRUGCA
label define DRUGCA_lb ///
    -9 "Don't want to answer" ///
    -8 "Don't know" ///
    -1 "Not Applicable" ///
     0 "No" ///
     1 "Yes"
label values DRUGCA DRUGCA_lb

* DRUGHA
label define DRUGHA_lb ///
    -9 "Don't want to answer" ///
    -8 "Don't know" ///
    -1 "Not Applicable" ///
     0 "No" ///
     1 "Yes"
label values DRUGHA DRUGHA_lb

foreach v in ALCOEV  ALCOFR  ALCOBI  SMOKCI  SMOKVA  DRUGCA  DRUGHA {
	tab SWEEP `v'
	
}

*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7

keep MCSID CNUM00 SWEEP ALCOEV  ALCOFR  ALCOBI  SMOKCI  SMOKVA  DRUGCA  DRUGHA
compress
save "${temp_data_cdv}SUBSTANCE.dta" ,replace

