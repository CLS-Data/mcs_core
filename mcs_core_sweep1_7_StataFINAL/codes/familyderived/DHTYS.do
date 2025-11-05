* DHTYS: DV Summary of Parents/Carers in Household

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
tab1 ADHTYS00 BDHTYS00 CDHTYS00 DDHTYS00 EHTYS00 FDHTYS00 GDHTYS00
      
*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DHTYS=. 
replace  DHTYS=ADHTYS00 if SWEEP==1
replace  DHTYS=BDHTYS00 if SWEEP==2
replace  DHTYS=CDHTYS00 if SWEEP==3
replace  DHTYS=DDHTYS00 if SWEEP==4
replace  DHTYS=EHTYS00  if SWEEP==5
replace  DHTYS=FDHTYS00 if SWEEP==6
replace  DHTYS=GDHTYS00 if SWEEP==7

label var DHTYS "DV Summary of Parents/Carers in Household"
label def DHTYSlb        -9 "Refusal" /// 
-8 "Don't know" /// 
 -1 "Not applicable" ///
           1 "Two parents/carers" ///
           2 "One parent/carer",  replace
		  
label val DHTYS DHTYSlb
tab  DHTYS SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DHTYS
compress
save "${temp_data_fdv}DHTYS.dta" ,replace



