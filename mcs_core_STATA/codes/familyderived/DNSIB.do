* DNSIB: Natural siblings of CM in household

*-------------------------------------------------------------------------------
*    BDNSIB00 BDHSIB00 BDSSIB00 BDASIB00 BDFSIB00 BDGPAR00 BDOTHA00 BDNUMH00 BDTOTP00 BDCWRK00 BDOEDS00 BDOEDE00 BDOEDP00 BDMCSC00 BDMCEQ00 BDMCPO00 BDSTRA00 BDSENT00 BDCNTR00 BDPTTY00

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
tab1 ADNSIB00 BDNSIB00 CDNSIB00 DDNSIB00 ENSIB00 FDNSIB00 GDNSIB00
 

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DNSIB=. 
replace  DNSIB=ADNSIB00 if SWEEP==1
replace  DNSIB=BDNSIB00 if SWEEP==2
replace  DNSIB=CDNSIB00 if SWEEP==3
replace  DNSIB=DDNSIB00 if SWEEP==4
replace  DNSIB=ENSIB00  if SWEEP==5
replace  DNSIB=FDNSIB00 if SWEEP==6
replace  DNSIB=GDNSIB00 if SWEEP==7

label var DNSIB "DV Natural siblings of CM in household"
recode DNSIB (-2=-8)
label def DNSIBlb  -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "At least 1 natural sib in HH" ///
           2 "No natural sibs in HH"  ,  replace
		  
		   
label val DNSIB DNSIBlb
tab  DNSIB SWEEP, m

 
tab  DNSIB SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DNSIB
compress
save "${temp_data_fdv}DNSIB.dta" ,replace



