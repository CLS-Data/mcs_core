*WALI:	Respondent's Life Satisfaction (Main Interviewee)
*GEHE:	Respondent's general health (4 categories, Main Interviewee)
*GENA:	Respondent's general health (5 categories, Main Interviewee)
*KESSLER:	DV Kessler (Main Interviewee)
*PHDE:	Kessler item: How often respondent felt depressed in last 30 days (Main Interviewee)
*PHHO:	Kessler item: How often felt hopeless in last 30 days (Main Interviewee)
*PHRF:	Kessler item: How often felt restless/fidgety in last 30 days (Main Interviewee)
*PHEE:	Kessler item: How often felt everything an effort in last 30 days (Main Interviewee)
*PHWO:	Kessler item: How often felt worthless in last 30 days (Main Interviewee)
*PHNE:	Kessler item: How often felt nervous in last 30 days (Main Interviewee) 

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs1}mcs1_hhgrid.dta", clear
drop if AELIG00==-1
tempfile mcs1_hhgrid
save `mcs1_hhgrid'

use "${mcs1}mcs1_parent_interview.dta", clear
merge 1:1 MCSID APNUM00 using `mcs1_hhgrid'
keep if _merge==1 | _merge==3
drop _merge
keep if AELIG00==1 | AELIG00==2
keep MCSID APNUM00 AELIG00 ARESP00  APFCIN00 ///
AHPSEX00 AHPAGE00 ///
AHCREL00 ///
AHPJOB00 ///
APSMUS0A ///
APWALI00 ///
APGEHE00

gen SWEEP=1

tempfile mcs1
save `mcs1'


* MCS 2.
use "${mcs2}mcs2_hhgrid.dta", clear
drop if BELIG00==-1
tempfile mcs2_hhgrid
save `mcs2_hhgrid'

use "${mcs2}mcs2_parent_interview.dta", clear
merge 1:1 MCSID BPNUM00 using `mcs2_hhgrid'
keep if _merge==1 | _merge==3
drop _merge
tab BELIG00
keep if BELIG00==1 | BELIG00==2

keep MCSID BPNUM00 BELIG00 BRESP00 BPFCIN00  ///
BHPSEX00 BHPAGE00 ///
BHCREL00 ///
BHPJOB00 ///
BPSMUS0A ///
BPPHDE00 BPPHHO00 BPPHRF00 BPPHEE00 BPPHWO00 BPPHNE00 ///
BPWALI00 ///
BPGEHE00

gen SWEEP=2

tempfile mcs2
save `mcs2'

* MCS 3.
use "${mcs3}mcs3_hhgrid.dta", clear
drop if CELIG00==-1
tempfile mcs3_hhgrid
save `mcs3_hhgrid'
 
use "${mcs3}mcs3_parent_interview.dta", clear
merge 1:1 MCSID CPNUM00 using `mcs3_hhgrid'
keep if _merge==1 | _merge==3
drop _merge
tab CELIG00
keep if CELIG00==1 | CELIG00==2
keep MCSID CPNUM00 CELIG00 CRESP00 CPFCIN00  ///
CHPSEX00 CHPAGE00 ///
CHCREL00 ///
CHPJOB00 ///
CPSMUS0A ///
CPPHDE00 CPPHHO00 CPPHRF00 CPPHEE00 CPPHWO00 CPPHNE00 ///
CPGENA00 ///
CPWALI00


gen SWEEP=3


tempfile mcs3
save `mcs3'

* MCS 4
use "${mcs4}mcs4_hhgrid.dta"  , clear
drop if DELIG00==-1
tempfile mcs4_hhgrid
save `mcs4_hhgrid'

 
use "${mcs4}mcs4_parent_interview.dta" , clear
merge 1:1 MCSID DPNUM00 using `mcs4_hhgrid'
keep if _merge==1 | _merge==3
drop _merge
tab DELIG00
keep if DELIG00==1 | DELIG00==2

keep MCSID DPNUM00 DELIG00 DRESP00 DPFCIN00  ///
DHPSEX00 DHPAGE00 ///
DHCREL00 ///
DHPJOB00 ///
DPSMUS0A ///
DPPHDE00 DPPHHO00 DPPHRF00 DPPHEE00 DPPHWO00 DPPHNE00 ///
DPGENA00 ///
DPWALI00



gen SWEEP=4

tempfile mcs4
save `mcs4'

* MCS 5	
use "${mcs5}mcs5_hhgrid.dta"  , clear
tempfile mcs5_hhgrid
save `mcs5_hhgrid'
 
use "${mcs5}mcs5_parent_interview.dta" , clear
merge 1:1 MCSID EPNUM00 using `mcs5_hhgrid'
keep if _merge==1 | _merge==3
drop _merge
keep if EELIG00==1 | EELIG00==2

keep MCSID EPNUM00 EELIG00 ERESP00 EPFCIN00 ///
EPSEX0000 EPAGE0000 ///
ECREL0000 ///
EPJOB0000 ///
EPSMUS0A ///
EPPHAC00 ///
EPPHDE00 EPPHHO00 EPPHRF00 EPPHEE00 EPPHWO00 EPPHNE00 ///
EPGENA00 ///
EPWALI00

gen SWEEP=5

tempfile mcs5
save `mcs5'
 
* MCS 6
use "${mcs6}mcs6_parent_interview.dta" , clear
keep if FELIG00==1 |  FELIG00==2

keep MCSID FPNUM00 FELIG00 FRESP00 FPFCIN00 ///
FPPAGE00 FPPSEX00 ///
FPCREL00 ///
FPPJOB00 ///
FPSMUS0A ///
FPPHAC00 ///
FPPHDE00 FPPHHO00 FPPHRF00 FPPHEE00 FPPHWO00 FPPHNE00 ///
FPGENA00


gen SWEEP=6

tempfile mcs6
save `mcs6'
 
* MCS 7
use "${mcs7}mcs7_hhgrid.dta" , clear
drop if GPNUM00==-1
tempfile mcs7_hhgrid
save `mcs7_hhgrid'

use "${mcs7}mcs7_parent_interview.dta" , clear
merge 1:1 MCSID GPNUM00 using `mcs7_hhgrid'
keep if _merge==1 | _merge==3
keep if GELIG00==1 |  GELIG00==2

keep MCSID GELIG00 GPNUM00 GPVERSION1_B  GPFCIN00 ///
GHPAGE00 GHPSEX00 ///
GHCREL00 ///
GHPJOB00 ///
GPPDHE00 GPPHHO00 GPPHRF00 GPPHEE00 GPPHWO00 GPPHNE00 ///
GPGENA00


gen SWEEP=7

tempfile mcs7
save `mcs7'
 

use `mcs1' 
forvalues i=2(1)7{
append using 	`mcs`i''
}
 

 
*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed

* 
tab1 AELIG00 BELIG00 CELIG00 DELIG00 EELIG00 FELIG00 GELIG00, 

tab1 ARESP00 BRESP00 CRESP00 DRESP00 ERESP00 FRESP00

tab1 AHCREL00 BHCREL00 CHCREL00 DHCREL00 ECREL0000 FPCREL00 GHCREL00

label list BHCREL00 CHCREL00 DHCREL00 ECREL0000 FPCREL00 GHCREL00


tab1 BHPSEX00 CHPSEX00 DHPSEX00 EPSEX0000 FPPSEX00 GHPSEX00

tab1 BHPAGE00 CHPAGE00 DHPAGE00 EPAGE0000 FPPAGE00 GHPAGE00

tab1 BHPJOB00 CHPJOB00 DHPJOB00 EPJOB0000 FPPJOB00 GHPJOB00

tab1 BPSMUS0A CPSMUS0A DPSMUS0A EPSMUS0A FPSMUS0A

tab1 EPPHAC00 FPPHAC00

tab1 BPPHDE00 CPPHDE00 DPPHDE00 EPPHDE00 FPPHDE00 GPPDHE00
tab1 BPPHHO00 CPPHHO00 DPPHHO00 EPPHHO00 FPPHHO00 GPPHHO00 
tab1 BPPHRF00 CPPHRF00 DPPHRF00 EPPHRF00 FPPHRF00 GPPHRF00 
tab1 BPPHEE00 CPPHEE00 DPPHEE00 EPPHEE00 FPPHEE00 GPPHEE00
tab1 BPPHWO00 CPPHWO00 DPPHWO00 EPPHWO00 FPPHWO00 GPPHWO00 
tab1 BPPHNE00 CPPHNE00 DPPHNE00 EPPHNE00 FPPHNE00 GPPHNE00

recode GPPDHE00 GPPHHO00 GPPHRF00 GPPHEE00 GPPHWO00 GPPHNE00 (7=-9) (8=-1)

tab1 APWALI00 BPWALI00 CPWALI00 DPWALI00 EPWALI00

recode BPWALI00 (-2=-8) 
recode EPWALI00 (11=10) // MCS5 we group 11 and 10 because the survey is different from previous years. 
recode APWALI00 BPWALI00  CPWALI00 DPWALI00  (11=-8) // don't know = can't say


tab1 CPGENA00 DPGENA00 EPGENA00 FPGENA00 GPGENA00
recode GPGENA00 (6=-8) (7=-9) (8=-1)

tab1 APGEHE0


*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

gen PHDE=. 
replace  PHDE=BPPHDE00 if SWEEP==2
replace  PHDE=CPPHDE00 if SWEEP==3
replace  PHDE=DPPHDE00 if SWEEP==4
replace  PHDE=EPPHDE00 if SWEEP==5
replace  PHDE=FPPHDE00 if SWEEP==6
replace  PHDE=GPPDHE00 if SWEEP==7

gen PHHO=. 
replace  PHHO=BPPHHO00  if SWEEP==2
replace  PHHO=CPPHHO00  if SWEEP==3
replace  PHHO=DPPHHO00  if SWEEP==4
replace  PHHO=EPPHHO00  if SWEEP==5
replace  PHHO=FPPHHO00  if SWEEP==6
replace  PHHO=GPPHHO00  if SWEEP==7

gen PHRF=. 
replace  PHRF=BPPHRF00  if SWEEP==2
replace  PHRF=CPPHRF00  if SWEEP==3
replace  PHRF=DPPHRF00  if SWEEP==4
replace  PHRF=EPPHRF00  if SWEEP==5
replace  PHRF=FPPHRF00  if SWEEP==6
replace  PHRF=GPPHRF00  if SWEEP==7

gen PHEE=. 
replace  PHEE=BPPHEE00  if SWEEP==2
replace  PHEE=CPPHEE00  if SWEEP==3
replace  PHEE=DPPHEE00  if SWEEP==4
replace  PHEE=EPPHEE00  if SWEEP==5
replace  PHEE=FPPHEE00  if SWEEP==6
replace  PHEE=GPPHEE00  if SWEEP==7

gen PHWO=. 
replace  PHWO=BPPHWO00  if SWEEP==2
replace  PHWO=CPPHWO00  if SWEEP==3
replace  PHWO=DPPHWO00  if SWEEP==4
replace  PHWO=EPPHWO00  if SWEEP==5
replace  PHWO=FPPHWO00  if SWEEP==6
replace  PHWO=GPPHWO00  if SWEEP==7

gen PHNE=. 
replace  PHNE=BPPHNE00  if SWEEP==2
replace  PHNE=CPPHNE00  if SWEEP==3
replace  PHNE=DPPHNE00  if SWEEP==4
replace  PHNE=EPPHNE00  if SWEEP==5
replace  PHNE=FPPHNE00  if SWEEP==6
replace  PHNE=GPPHNE00  if SWEEP==7


tab1 PHDE PHHO PHRF PHEE PHWO PHNE
foreach var in PHDE PHHO PHRF PHEE PHWO PHNE{
gen `var'_AUX=`var' 
recode `var'_AUX (-9/-1=.) (1=4) (2=3) (3=2) (4=1) (5=0) (6/8=.) 
}

gen KESSLER=PHDE_AUX +PHHO_AUX +PHRF_AUX +PHEE_AUX +PHWO_AUX +PHNE_AUX // do no accept missing items
drop *_AUX

 foreach var in PHDE PHHO PHRF PHEE PHWO PHNE {	
replace KESSLER=-1	if `var'==-8  |`var'==-9 |`var'==-1
}

label def KESSLERlb  -1 "Not applicable" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" 16 "16" 17 "17" 18 "18" 19 "19" 20 "20" 21 "21" 22 "22" 23 "23" 24 "24", replace



label def ITEMlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "All of the time"  ///
           2 "Most of the time" ///
           3 "Some of the time" ///
           4 "A little of the time" ///
           5 "None of the time" ///
           6 "Can't say"   ,  replace
  
label val PHDE PHHO PHRF PHEE PHWO PHNE ITEMlb

label var PHDE "Kessler item: How often respondent felt depressed in last 30 days (Main Interviewee)"
label var PHHO "Kessler item: How often felt hopeless in last 30 days (Main Interviewee)"
label var PHRF "Kessler item: How often felt restless/fidgety in last 30 days (Main Interviewee)"
label var PHEE "Kessler item: How often felt everything an effort in last 30 days (Main Interviewee)"
label var PHWO "Kessler item: How often felt worthless in last 30 days (Main Interviewee)"
label var PHNE "Kessler item: How often felt nervous in last 30 days (Main Interviewee)"

label var KESSLER "DV Kessler (Main Interviewee)"
label val KESSLER KESSLERlb
tab KESSLER

* CREL
recode ECREL0000 FPCREL00 (-1=-8)
recode  BHCREL00 (-2=-8)

label def CRELlb -9 "Refusal" ///
-8 "Don't know" ///
-1 "Not applicable" ///
1 "Husband/Wife" ///
2 "Partner/Cohabitee" ///
3 "Natural son/daughter" ///
4 "Adopted son/daughter" ///
5 "Foster son/daughter" ///
6 "Step-son/ step-daughter" ///
7 "Natural parent" ///
8 "Adoptive parent" ///
9 "Foster parent" ///
10 "Step-parent/partner of parent" ///
11 "Natural brother/Natural sister" ///
12 "Half-brother/Half-sister" ///
13 "Step-brother/Step-sister" ///
14 "Adopted brother/Adopted sister" ///
15 "Foster brother/Foster sister" ///
16 "Grandchild" ///
17 "Grandparent" ///
18 "Nanny/au pair" ///
19 "Other relative" ///
20 "Other non-relative" ///
96 "Self" ,replace 


gen CREL=. 
replace  CREL=AHCREL00  if SWEEP==1
replace  CREL=BHCREL00  if SWEEP==2
replace  CREL=CHCREL00  if SWEEP==3
replace  CREL=DHCREL00  if SWEEP==4
replace  CREL=ECREL0000 if SWEEP==5
replace  CREL=FPCREL00  if SWEEP==6
replace  CREL=GHCREL00  if SWEEP==7

label var CREL "Relationship to Cohort Member"
label val CREL CRELlb
tab CREL


gen PSEX=. 
replace  PSEX=AHPSEX00   if SWEEP==1
replace  PSEX=BHPSEX00   if SWEEP==2
replace  PSEX=CHPSEX00   if SWEEP==3
replace  PSEX=DHPSEX00   if SWEEP==4
replace  PSEX=EPSEX0000  if SWEEP==5
replace  PSEX=FPPSEX00   if SWEEP==6
replace  PSEX=GHPSEX00   if SWEEP==7

recode PSEX (0=-8) (.=-8)
label var PSEX "Person Sex"
label def PSEXlb   -9 "Refusal" ///
          -8 "Don't know"       ///  
          -1 "Not applicable" ///
           1 "Male" ///
           2 "Female" , replace 
label val PSEX PSEXlb
tab PSEX,m 

*WALI
label def  WALIlb  -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Completely dissatisfied" ///
          10 "Completely satisfied" ,replace 

gen WALI=. 
replace  WALI=APWALI00  if SWEEP==1
replace  WALI=BPWALI00  if SWEEP==2
replace  WALI=CPWALI00  if SWEEP==3
replace  WALI=DPWALI00  if SWEEP==4
replace  WALI=EPWALI00  if SWEEP==5

label var WALI "Respondent's Life Satisfaction (Main Interviewee)"
label val WALI WALIlb
tab  WALI SWEEP, m

tab1 APWALI00 BPWALI00 CPWALI00 DPWALI00 EPWALI00

label def WALILB -9 "Refusal" ///
          -8 "Don't Know" ///
          -1 "Not applicable" ///
           1 "1 Completely dissatisfied" ///
		   2 "2"  ///
		   3 "3" ///
		   4 "4" ///
		   5 "5"  ///
		   6 "6"  ///
		   7 "7" ///
		   8 "8"  ///
		   9 "9" /// 
          10 "10 Completely satisfied", replace

label val 	 WALI	  WALILB
		  
*GEHE
gen GEHE=. 
replace  GEHE=APGEHE00  if SWEEP==1
replace  GEHE=BPGEHE00  if SWEEP==2

label var GEHE "Respondent's general health (4 categories, Main Interviewee)"
label def  GEHElb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Excellent" ///
           2 "Good" ///
           3 "Fair" ///
           4 "Poor", replace 
label val  GEHE GEHElb

*GENA
gen GENA=. 
replace  GENA=CPGENA00  if SWEEP==3
replace  GENA=DPGENA00  if SWEEP==4
replace  GENA=EPGENA00  if SWEEP==5
replace  GENA=FPGENA00  if SWEEP==6
replace  GENA=GPGENA00 if SWEEP==7

label var GENA "Respondent's general health (5 categories, Main Interviewee)"
label def GENAlb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "Excellent" ///
           2 "Very good" ///
           3 "Good" ///
           4 "Fair" ///
           5 "Poor"   ,  replace
		  
label val GENA GENAlb
tab  GENA SWEEP, m
*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key

gen ELIG00=. 
replace  ELIG00=AELIG00  if SWEEP==1
replace  ELIG00=BELIG00  if SWEEP==2
replace  ELIG00=CELIG00  if SWEEP==3
replace  ELIG00=DELIG00  if SWEEP==4
replace  ELIG00=EELIG00  if SWEEP==5
replace  ELIG00=FELIG00  if SWEEP==6
replace  ELIG00=GELIG00 if SWEEP==7

label var ELIG00 "Eligibility for survey: Whether resp eligible for role of Main /(Proxy)Partner"
label def ELIG00lb  -1 "Not applicable" ///
           1 "Main Interview" ///
           2 "Partner Interview" ///
           3 "Proxy Partner Interview" ///
           4 "Not eligible for interview", replace
label val ELIG00 ELIG00lb


gen PNUM00=. 
replace  PNUM00=APNUM00   if SWEEP==1
replace  PNUM00=BPNUM00   if SWEEP==2
replace  PNUM00=CPNUM00   if SWEEP==3
replace  PNUM00=DPNUM00   if SWEEP==4
replace  PNUM00=EPNUM00   if SWEEP==5
replace  PNUM00=FPNUM00   if SWEEP==6
replace  PNUM00=GPNUM00 if SWEEP==7
label var PNUM00 "Person number within an MCS family data (excl Cohort Members, see CNUM)"

keep MCSID PNUM00 ELIG00 SWEEP CREL PSEX PHDE PHHO PHRF PHEE PHWO PHNE KESSLER WALI GEHE GENA
duplicates report MCSID PNUM00 SWEEP



keep if ELIG00==1 // keep only Main Interviewee
tab SWEEP 
keep MCSID SWEEP PHDE PHHO PHRF PHEE PHWO PHNE KESSLER WALI GEHE GENA
duplicates report MCSID  SWEEP

compress
save "${temp_data_pdv}KESSLER_WALI_GEHE_GENA.dta" ,replace
