*---------------------------------------------------------------------------*
* Do-file to generate: mcs_core_sweeps1_7 dataset
*---------------------------------------------------------------------------*
* Steps to generate mcs_core_sweeps1_7.dta
* Using as data input mcs_longitudinal_family_file_long:

* 1) Merge Family derived variables (MCSID SWEEP) 
* 2) Merge cohort member derived variables (MCSID NUM SWEEP)
* 3) Merge Parent ((Main Interviewee) derived variables (MCSID SWEEP - but note that information is at the Main/Partner Interviewee level)
* 4) Change/edit variable names/labels/order and others
* 5) Save dataset as mcs_core_sweeps1_7

use "${temp_data}mcs_longitudinal_family_file_long.dta" ,clear


*---------------------------------------------------------------------------*
* 1) Merge Family derived variables (MCSID SWEEP) 

global familyvar "ACTRY AREGN DRSPO DHTYP DHTYS DRELP DMINH DFINH DOTHS DNOCM DTOTS DNSIB DHSIB DSSIB DASIB DFSIB DGPAR DOTHA DNUMH DTOTP DCWRK DROOW DMBMI DHLAN DOEDS DOEDE DOEDP" 

foreach var of global familyvar {
merge m:1 MCSID SWEEP using "${temp_data_fdv}`var'.dta"
keep if _merge==1 | _merge==3
cap drop _merge
}

*---------------------------------------------------------------------------*
* 2) Merge cohort member derived variables (MCSID CNUM SWEEP)

* Time-variant variables

global cmvartv "AGEY_SWEEPAGE SDQ_SCBQ  CGHE CLSI_CLSL CLOSER_BMI_WT_HT_XAGE WEIGHT_HEIGHT ROSENBERG_SATI_GDQL_DOWL_VALU_GDSF DWEMWBS HEALTH COGNITIVE SUBSTANCE CRIME" 
foreach var of global cmvartv {
merge 1:1 MCSID CNUM00 SWEEP using "${temp_data_cdv}`var'.dta"
keep if _merge==1 | _merge==3
cap drop _merge
}

* Time-invariant variables
global cmvarin "SEX DC11E BWGT GESTAGE"
foreach var of global cmvarin {
merge m:1 MCSID CNUM00 using "${temp_data_cdv}`var'.dta"
keep if _merge==1 | _merge==3
cap drop _merge
}

*---------------------------------------------------------------------------*
* 3) Merge Parent derived variables 
* The dataset is at the Sweep-Family level: MCSID SWEEP - but variables include responses of Main Interviewee (ELIG=1). 
* The variables with suffix "_P" include responses of Partner Interviewee (ELIG=2). These variables are:  DACAQ_P and DNVQ_P
global parentvar "D05S_D07S_D13S_D05C_D07C_D13C DACAQ_DNVQ DACAQ_DNVQ_P KESSLER_WALI_GEHE_GENA"

foreach var of global parentvar {
merge m:1 MCSID SWEEP using "${temp_data_pdv}`var'.dta"
keep if _merge==1 | _merge==3
cap drop _merge
}


*---------------------------------------------------------------------------*
* 4) Change/edit variable names/labels/order and other 

order MCSID CNUM00 SWEEP SWEEPAGE AGEY SEX


* change to lower case all variables. 
rename *, lower

* rename CM ID
rename cnum00 cnum


* generate sweepage
replace sweepage=1 if sweep==1 & sweepage==.
replace sweepage=3 if sweep==2 & sweepage==.
replace sweepage=5 if sweep==3 & sweepage==.
replace sweepage=7 if sweep==4 & sweepage==.
replace sweepage=11 if sweep==5 & sweepage==.
replace sweepage=14 if sweep==6 & sweepage==.
replace sweepage=17 if sweep==7 & sweepage==.

* change labels of variables
label var ovwt1 "MCS sample design weights by stratum and country - to use on single country analyses"
label var ovwt2 "MCS sample design weights by stratum - to use on whole UK analyses"
label var ovwtgb "MCS sample design weights by stratum - to use on GB analyses"

* replace to missing those cohort members in unproductive surveys (aoutc!=1)
replace agey=.  if aoutc!=1
replace agey=sweepage if agey==. & aoutc==1

* order variables in dataset 
order mcsid cnum sweep nocmhh sentry country ptty pttype2 sptn nh2 weight1 weight2 weightgb ///
issued aoutc ovwt1 ovwt2 nrespwt ovwtgb
order d05s d07s dacaq, before(d13s)
order dacaq, after(d13c)

* replace with variables with missing for unproductive surveys
global listvar "actry aregn drspo dhtyp dhtys drelp dminh dfinh doths dnocm dtots dnsib dhsib dssib dasib dfsib dgpar dotha dnumh dtotp dcwrk droow dmbmi dhlan doeds doede doedp emotion conduct hyper peer prosoc ebdtot dcsbi dcsbe dcsbc cghe cghe_sr clsi clsi_sr clsl clsl_sr dc11e bwgt bwgtc lowbw gestage preterm d05s d07s d13s d05c d07c d13c dacaq dacaq_p dnvq dnvq_p  phde phho phrf phee phwo phne kessler wali gehe gena"

foreach v of global  listvar {
replace `v'=. if 	 aoutc!=1 & `v'==.	// no valid values in unproductive surveys
}


tab1 agey actry aregn drspo dhtyp dhtys 
tab1 drelp dminh dfinh doths dnocm dtots 
tab1 dnsib dhsib dssib dasib dfsib dgpar 
tab1  dotha dnumh dtotp dcwrk droow dmbmi 
tab1 dhlan doeds 
sum doede 
tab1 doedp 
tab1 emotion conduct hyper peer prosoc ebdtot 
tab1 dcsbi dcsbe dcsbc
tab1 cghe cghe_sr clsi clsi_sr clsl clsl_sr 
tab1 dc11e 
tab1 bwgt bwgtc lowbw gestage preterm 
tab1 d05s d07s d13s d05c d07c d13c 
tab1 dacaq dacaq_p dnvq dnvq_p
tab1 phde phho phrf phee phwo phne kessler 
tab1 wali gehe gena

global listvar "actry aregn drspo dhtyp dhtys drelp dminh dfinh doths dnocm dtots dnsib dhsib dssib dasib dfsib dgpar dotha dnumh dtotp dcwrk  doede doedp"
foreach v of global listvar {
replace `v'=-8 if 	 aoutc==1 & `v'==.	// Don't know in missing values for productive surveys

}

global listvar "droow  dhlan"
foreach v of global listvar {
replace `v'=-8 if 	 aoutc==1 & `v'==.	& sweep!=7 // Don't know in missing values for productive surveys
}

bys sweep: sum dmbmi // don't recode missing to -8 because it's BMI of the Natural Mothers at Interview. 

*---------------------------------------------------------------------------*
* 5) Save dataset 

sort mcsid cnum sweep
compress
save "${temp_data}mcs_core_sweeps1_7.dta", replace



