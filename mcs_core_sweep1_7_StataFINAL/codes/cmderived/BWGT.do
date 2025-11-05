
*BWGT	:	Birth weight (Kilograms)
*BWGTC	:	DV Birth weight categories (Low, Normal, High)
*LOWBW	:	DV Low birth weight (<2.5 kg)

*-------------------------------------------------------------------------------
* 1) Extract variables from raw MCS data

use "${mcs1}/mcs1_cm_derived.dta", clear
rename  ACNUM00 CNUM00
keep MCSID CNUM00  ADBWGT00 
rename *, upper
tempfile mcs1
save `mcs1'

use "${mcs2}/mcs2_parent_cm_interview.dta", clear
keep if BELIG00==1 // main interview - 
duplicates report MCSID BCNUM00
rename  BCNUM00 CNUM00

tab1 BPBIWT00 BPWTKG00 BPWTLB00 BPWTOU00

gen BWGT00=BPWTKG00 if BPBIWT00==1 // kilos
* remove implausible values 
replace BWGT00=. if BWGT00==0 // 2 obs
replace BWGT00=. if BWGT00>6.5 & BWGT00<=200 // 8 obs
sum BPWTKG00 BPWTLB00 BPBIWT00

* Use doubles (no integer rounding to grams)
gen double lb_to_grms = BPWTLB00*453.592 if BPBIWT00==2
gen double oun_to_grms = BPWTOU00*28.3495 if BPBIWT00==2
replace BWGT00 = round((lb_to_grms + oun_to_grms)/1000, .01) if BPBIWT00==2

recast double BWGT00, force
replace BWGT00 = round(BWGT00, .01) if BWGT00 < . & BWGT00 >= 0

replace BWGT00 = . if BWGT00 > 6.5 & BWGT00 <= 200
replace BWGT00 = -8 if BWGT00==. & inlist(BPBIWT00,1,2)

keep MCSID CNUM00  BWGT00

tempfile mcs2
save `mcs2'

use `mcs1'
merge 1:1 MCSID CNUM00  using `mcs2'
drop _merge

*-------------------------------------------------------------------------------
* 3) Generate new variable 

clonevar BWGT=ADBWGT00 
tab1 BWGT

replace BWGT=BWGT00 if BWGT==. & BWGT00!=.
replace BWGT=-8 if BWGT==.
label var BWGT "Birth weight (Kilograms)"

recast double BWGT, force
replace BWGT = round(BWGT, .01) if BWGT < . & BWGT >= 0

tab BWGT if ADBWGT00==-1
gen BWGTC=.
replace BWGTC=1 if BWGT>0 & BWGT<2.5
replace BWGTC=2 if BWGT>=2.5 & BWGT<4
replace BWGTC=3 if BWGT>=4 & BWGT<10
replace BWGTC=-8 if BWGT==-8
replace BWGTC=-1 if BWGT==-1	
label var BWGTC "DV Birth weight categories (Low, Normal, High)"
label def BWGTClb 	-9 "Refusal" /// 
					-8 "Don't know" /// 
					-1 "Not Applicable" ///
					1 "Low (<2.5 kg)" ///
					2 "Normal (>=2.5 - <4 kg)" ///
					3 "High (>4 kg)" , replace
label val BWGTC BWGTClb


gen LOWBW=1 if BWGTC==1
replace LOWBW=2 if BWGTC==2 | BWGTC==3
replace LOWBW=-8 if BWGTC==-8
replace LOWBW=-1 if BWGTC==-1
label var LOWBW "DV Low birth weight (<2.5 kg)"
label def yesnolb 1 "Yes" 2 "No" -9 "Refusal" /// 
					-8 "Don't know" /// 
					-1 "Not Applicable" , replace
label val LOWBW yesnolb

tab1 BWGT BWGTC LOWBW

*-------------------------------------------------------------------------------
* 4) save temporal data &  gen CNUM key

compress
keep MCSID CNUM00 BWGT BWGTC LOWBW
rename *, upper

save "${temp_data_cdv}BWGT.dta" ,replace

