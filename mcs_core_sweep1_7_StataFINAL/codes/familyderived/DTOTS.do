* DTOTS:  DV Number of sibs in hhold plus CMs

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_family_derived.dta",clear
gen SWEEP=`i'
tempfile mcs`i'
save `mcs`i''
}

use `mcs1' 
forvalues i=2(1)7{
append using 	`mcs`i''
}


*-------------------------------------------------------------------------------
* 2) Change/recode/edit variables if needed
tab1 ADTOTS00 BDTOTS00 CDTOTS00 DDTOTS00 ETOTS00 FDTOTS00 GDTOTS00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DTOTS=. 
replace  DTOTS=ADTOTS00 if SWEEP==1
replace  DTOTS=BDTOTS00 if SWEEP==2
replace  DTOTS=CDTOTS00 if SWEEP==3
replace  DTOTS=DDTOTS00 if SWEEP==4
replace  DTOTS=ETOTS00  if SWEEP==5
replace  DTOTS=FDTOTS00 if SWEEP==6
replace  DTOTS=GDTOTS00 if SWEEP==7

label var DTOTS "DV Number of sibs in hhold plus CMs"


replace  DTOTS=-8 if SWEEP==4 & DTOTS==-2 
replace  DTOTS=-1 if SWEEP==7 & DTOTS==0 // 221 cases with value 0 (Number of CM in HH) that are boost cases for whom there was no HHgrid. - 
label def dk_re_na_lb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           ,  replace
		   
label val DTOTS dk_re_na_lb

tab  DTOTS SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DTOTS
compress
save "${temp_data_fdv}DTOTS.dta" ,replace



