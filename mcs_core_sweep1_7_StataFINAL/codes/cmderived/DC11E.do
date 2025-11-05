* DC11E: DV Cohort Member Ethnic Group - 11 category Census class

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data
forvalues i=1(1)7{
use "${mcs`i'}mcs`i'_cm_derived.dta",clear	
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
tab1 ADC11E00 BDC11E00 CDC11E00 DDC11E00

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format

gen DC11E=. 
replace  DC11E=ADC11E00 if SWEEP==1
replace  DC11E=BDC11E00 if SWEEP==2
replace  DC11E=CDC11E00 if SWEEP==3
replace  DC11E=DDC11E00 if SWEEP==4
replace  DC11E=. if SWEEP==5
replace  DC11E=. if SWEEP==6
replace  DC11E=. if SWEEP==7

label var DC11E "DV Cohort Member Ethnic Group - 11 category Census class"
label def DC11Elb     -9 "Refusal" ///
          -8 "Don't know" ///
          -1 "Not applicable" ///
           1 "White" ///
           2 "Mixed" ///
           3 "Indian" ///
           4 "Pakistani" ///
           5 "Bangladeshi" ///
           6 "Other Asian" ///
           7 "Black Caribbean" ///
           8 "Black African" ///
           9 "Other Black" ///
          10 "Chinese" ///
          11 "Other Ethnic Group"  ,  replace
		  
label val DC11E DC11Elb
tab  DC11E SWEEP, m




*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key
gen CNUM00=. 
replace  CNUM00=ACNUM00 if SWEEP==1
replace  CNUM00=BCNUM00 if SWEEP==2
replace  CNUM00=CCNUM00 if SWEEP==3
replace  CNUM00=DCNUM00 if SWEEP==4
replace  CNUM00=ECNUM00 if SWEEP==5
replace  CNUM00=FCNUM00 if SWEEP==6
replace  CNUM00=GCNUM00 if SWEEP==7


compress
keep MCSID CNUM00 SWEEP DC11E

reshape wide DC11E, i(MCSID CNUM00) j(SWEEP)

gen DC11E=DC11E1 
replace DC11E=DC11E2 if DC11E==-9 | DC11E==-8 |DC11E==-1|DC11E==.
replace DC11E=DC11E3 if DC11E==-9 | DC11E==-8 |DC11E==-1|DC11E==.
replace DC11E=DC11E4 if DC11E==-9 | DC11E==-8 |DC11E==-1|DC11E==.

label val DC11E DC11Elb
tab1 DC11E 

label var DC11E "DV Cohort Member Ethnic Group - 11 category Census class (first recorded)"

keep MCSID CNUM00 DC11E

save "${temp_data_cdv}DC11E.dta" ,replace



