* DNUMH: Number of people present in HH excluding CMs  

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
tab1 ADNMHD00 BDNUMH00 CDNUMH00 DDNUMH00 ENUMH00 FDNUMH00 GDNUMH00 
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DNUMH=. 
replace  DNUMH=ADNMHD00 if SWEEP==1
replace  DNUMH=BDNUMH00 if SWEEP==2
replace  DNUMH=CDNUMH00 if SWEEP==3
replace  DNUMH=DDNUMH00 if SWEEP==4
replace  DNUMH=ENUMH00 if SWEEP==5
replace  DNUMH=FDNUMH00 if SWEEP==6
replace  DNUMH=GDNUMH00 if SWEEP==7

replace  DNUMH=-1 if SWEEP==7 & DNUMH==0 // cases with value 0 that are boost cases for whom there was no HHgrid in MCS7

label var DNUMH "DV Number of people present in HH excluding CMs"
label def dk_re_na_lb      -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           ,  replace
		   
label val DNUMH dk_re_na_lb
		  

tab  DNUMH SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DNUMH
compress
save "${temp_data_fdv}DNUMH.dta" ,replace



