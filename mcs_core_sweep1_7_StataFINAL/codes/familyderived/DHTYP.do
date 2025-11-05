* DHTYP: DV Parents/Carers in Household  

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
* change categories sweep 1 to match categories in sweeps 2-7
recode ADHTYP00 (.=-1) (6=8) (7=10) (8=11) (9=12) (10=15) (11=16) (12=21) (13=20)  

*-------------------------------------------------------------------------------
* 3) Generate new variable in a longitudinal format
gen DHTYP=. 
replace DHTYP=ADHTYP00 if SWEEP==1
replace DHTYP=BDHTYP00 if SWEEP==2
replace DHTYP=CDHTYP00 if SWEEP==3
replace DHTYP=DDHTYP00 if SWEEP==4
replace DHTYP=EHTYP00 if SWEEP==5
replace DHTYP=FDHTYP00 if SWEEP==6
replace DHTYP=GDHTYP00 if SWEEP==7
 
recode DHTYP (-1=-8) 
label var DHTYP "DV Parents/Carers in Household"
label def DHTYPlb -9 "Refusal" /// 
-8 "Don't know" /// 
-1 "Not Applicable" ///
           1 "Both natural parents" ///
           2 "Natural mother and step-parent" ///
           3 "Natural mother and other parent/carer" ///
           4 "Natural mother and adoptive parent" ///
           5 "Natural father and step-parent" ///
           6 "Natural father and other parent/carer" ///
           7 "Natural father and adoptive parent" ///
           8 "Two adoptive parents" ///
           9 "Adoptive mother and other parent/carer" ///
          10 "Two foster parents" ///
          11 "Two grandparents" ///
          12 "Grandmother and other parent/carer" ///
          13 "Grandfather and other parent/carer" ///
          14 "Two other parents" ///
          15 "Natural mother only" ///
          16 "Natural father only" ///
          17 "Adoptive mother only" ///
          18 "Adoptive father only" ///
          19 "Step mother only" ///
          20 "Grandmother only" ///
          21 "Other parent/carer only (foster/sib/rel)" ///
          22 "Step father only" ///
          23 "Unknown parent types" ///
          24 "Grandfather only" ///
          25 "Adoptive mother and step parent" ///
          26 "Two step-parents", replace
		  
label val DHTYP DHTYPlb
tab  DHTYP SWEEP, m

*-------------------------------------------------------------------------------
* 4) save temporal data 
keep MCSID SWEEP DHTYP
compress
save "${temp_data_fdv}DHTYP.dta" ,replace



