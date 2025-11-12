*---------------------------------------------------------------------------*
* Do-file to generate: MCS Core

*---------------------------------------------------------------------------*
* Steps to generate mcs_core.dta

*Step 1)	From UKDS or MCS GitHub repository, download and open the file `mcs_core.zip'. This file contains a folder named `mcs_core' with the following sub-folder structure:  

* temp_data
* 	 cmderived
* 	 familyderived
* 	 parentderived
* codes
* 	 cmderived
* 	 familyderived
* 	 parentderived

* Step 2) Download MCS datasets from UKDS.

* Step 3) Manually change the lines that contains:
* a.	the path which points to the folder `mcs_core' in your computer
* Add to the global named "path" (see below) the corresponding path in your computer where the folder mcs_core was stored. 

global path "" // <- add the path here



* b.	the paths which point to the folders of each MCS datasets and move them into the corresponding folder:
* Use/change globals accordingly: mcslf, mcs1-7 and closer

global mcslf "" // <- add path to the MCS Longitudinal File - UKDS SN 8172
global mcs1 "" // <- add path to the MCS 1 data sets - UKDS SN 4683
global mcs2 "" // <- add path to the MCS 2 data sets- UKDS SN 5350
global mcs3 "" // <- add path to the MCS 3 data sets- UKDS SN 5795/
global mcs4 "" // <- add path to the MCS 4 data sets- UKDS SN 6411
global mcs5 "" // <- add path to the MCS 5 data sets- UKDS SN 7464
global mcs6 "" // <- add path to the MCS 6 data sets - UKDS SN 8156
global mcs7 "" // <- add path to the MCS 7 data sets - UKDS SN 8682
global closer "" // <- add path to the 'Harmonised Height, Weight and BMI in Five Longitudinal Cohort Studies: Millennium Cohort Study' dataset - UKDS SN 8550


* Step 4) Run the code 1_MCS_Core (this do-file), which will create the mcs_core data set and save it in the folder `temp_data'.


*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Globals with paths to temp_data and codes 


* Folder with created datasets
global temp_data "${path}/temp_data/"
global temp_data_fdv "${path}/temp_data/familyderived/"
global temp_data_cdv "${path}/temp_data/cmderived/"
global temp_data_pdv "${path}/temp_data/parentderived/"

* Folder with codes 
global codes "${path}/codes/"
global codes_fdv "${codes}/familyderived/"
global codes_cdv "${codes}/cmderived/"
global codes_pdv "${codes}/parentderived/"


*---------------------------------------------------------------------------*
* This section run codes that generate individual variables.
* Each name in globals "dfamilyvar" "dcmvartv" and "dparentvar" are specific do-files that use as input MCS datasets across one or multiple sweeps to create a derived variable. 

* For example, the do-file "AREGN" uses the MCS datasets mcs[1-6]_family_derived and mcs7_hhgrid to create the variable with the same name "AREGN". This variable is created using the following  original variables, which are across different MCS sweeps: AAREGN00, BAREGN00, CAREGN00, DAREGN00, EAREGN00, FAREGN00, GAREGN00.


* 1) Family derived variables (MCSID SWEEP) 
global dfamilyvar "ACTRY AREGN DRSPO DHTYP DHTYS DRELP DMINH DFINH DOTHS DNOCM DTOTS DNSIB DHSIB DSSIB DASIB DFSIB DGPAR DOTHA DNUMH DTOTP DCWRK DROOW DMBMI DHLAN DOEDS DOEDE DOEDP" 

foreach var of global dfamilyvar {
do "${codes_fdv}`var'.do"
}
    
* 2) Cohort member derived variables (MCSID NUM SWEEP)
global dcmvartv "AGEY_SWEEPAGE BWGT CGHE CLOSER_BMI_WT_HT_XAGE CLSI_CLSL DC11E GESTAGE SDQ_SCBQ SEX WEIGHT_HEIGHT ROSENBERG_SATI_GDQL_DOWL_VALU_GDSF DWEMWBS HEALTH COGNITIVE SUBSTANCE CRIME" 

foreach var of global dcmvartv {
do "${codes_cdv}`var'.do"
}

* 3) Parent ((Main Interviewee or Parent Interviewee) derived variables (MCSID SWEEP - but information is at the person level)
global dparentvar "D05S_D07S_D13S_D05C_D07C_D13C DACAQ_DNVQ DACAQ_DNVQ_P KESSLER_WALI_GEHE_GENA"
foreach var of global dparentvar {
do "${codes_pdv}`var'.do"
}

*---------------------------------------------------------------------------*
* This section run codes that merge variables and create final longitudinal database. 

* Do-file that generate the mcs_longitudinal_family_file_long dataset
do "${codes}2_MCS_long.do" 
* Do-file that generate the mcs_core dataset
do "${codes}3_MCS_linkage.do"







 
