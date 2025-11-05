
*GESTAGE: Gestational age (days)
*PRETERM: DV Pre term Gestational age (days < 259)
*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs1}/mcs1_cm_derived.dta", clear

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
rename  ACNUM00 CNUM00
keep MCSID CNUM00  ADGEST00 
clonevar GESTAGE=ADGEST00

gen PRETERM= 1 if (GESTAGE>0 & GESTAGE<259)
replace PRETERM= 2 if (GESTAGE>=259 & GESTAGE<400) // max is  301
replace PRETERM=-8 if  GESTAGE==-8

label var GESTAGE "Gestational age (days)"
label def GESTAGElb -9 "Refusal" -8 "Don't know" -1 "Not applicable", replace 
label val  GESTAGE GESTAGElb

label var PRETERM "DV Pre term Gestational age (days< 259)"
label def PRETERMlb 1 "Yes" 2 "No" -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable"  , replace 
label val PRETERM PRETERMlb

tab GESTAGE PRETERM, m

*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key

compress
keep MCSID CNUM00 GESTAGE PRETERM

rename *, upper

save "${temp_data_cdv}GESTAGE.dta" ,replace
