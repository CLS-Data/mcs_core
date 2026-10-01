# Millennium Cohort Study Longitudinal Dataset

[Centre for Longitudinal Studies](https://cls.ucl.ac.uk/)

------------------------------------------------------------------------

## Overview

-   This repository provides **R scripts** that harmonise the multiple sweeps of [**Millennium Cohort Study**](https://cls.ucl.ac.uk/cls-studies/millennium-cohort-study/) into a single tidy dataset, so analysts can get straight to research rather than recoding.
-   The variables are given consistent names which relate to the content (e.g., `alcoev` for ever trying an alcohol drink).

------------------------------------------------------------------------

## Included variable domains

| Domain | Examples |
|-----------------|-------------------------------------------------------|
| Demographics| e.g. sex, gender, ethnicity.|
| Physical and mental health| e.g. self-rated health and wellbeing.|
| Anthropometrics| e.g. height and weight.|
| Socioeconomic circumstances| e.g. social class.|
| Behaviours| e.g. physical activity, alcohol intake.|

*See `millennium_cohort_study_core_dataset_user_guide_version_1.pdf` for full details.*

## Data availability

The source datasets are available to download from the [**UK Data Service**]

## Quick start
1. Download the following folders as .dta files from the UK Data Service (UKDS):
SN 4683, SN 5350, SN 5795, SN 6411, SN 7464, SN 8156, SN 8682, SN 8172, SN 8550, SN 9509.

2. Open the file "1_mcs_core.R" within the Codes subfolder.

3. Define the path for core_dir to the folder that this file is contained in.

4. Define the subpaths for each of the 10 folders downloaded from UKDS.

5. Run or source the entire 1_mcs_core.R.

6. Your completed MCS Core file can be found in the temp_data folder.

## Repository structure

```
.
├── README.text                 # Quick start instructions
├── codes/                      
│   ├── 1_MCS_Core.R            # This is the only script that needs to be opened and changed to match your folder structure
│   ├── 2_MCS_long.R
│   ├── 3_MCS_linkage.R
│   ├── cmderived/              # Contains domain-specific cohort member level scripts sourced by the main scripts
│   ├──     ├── AGEY_SWEEPAGE.R
│   ├──     ├── BWGT.R
│   ├──     ├── CGHE.R
│   ├──     ├── CLOSER_BMI_WT_HT_XAGE.R
│   ├──     ├── CLSI_CLSL.R
│   ├──     ├── COGNITIVE.R
│   ├──     ├── CRIME.R
│   ├──     ├── DC11E.R
│   ├──     ├── DWEMWBS.R
│   ├──     ├── GESTAGE.R
│   ├──     ├── HEALTH.R
│   ├──     ├── ROSENBERG.R
│   ├──     ├── SDQ_SCBQ.R
│   ├──     ├── SEX.R
│   ├──     ├── SUBSTANCE.R
│   └──     └── WEIGHT_HEIGHT.R
│   ├── familyderived/          # Contains domain-specific family level scripts sourced by the main scripts
│   ├──     ├── ACTRY.R
│   ├──     ├── AREGN.R
│   ├──     ├── DASIB.R
│   ├──     ├── DCWRK.R
│   ├──     ├── DFINH.R
│   ├──     ├── DFSIB.R
│   ├──     ├── DGPAR.R
│   ├──     ├── DHLAN.R
│   ├──     ├── DHSIB.R
│   ├──     ├── DHTYP.R
│   ├──     ├── DHTYS.R
│   ├──     ├── DMBMI.R
│   ├──     ├── DMINH.R
│   ├──     ├── DNOCM.R
│   ├──     ├── DNSIB.R
│   ├──     ├── DNUMH.R
│   ├──     ├── DOEDE.R
│   ├──     ├── DOEDP.R
│   ├──     ├── DOEDS.R
│   ├──     ├── DOTHA.R
│   ├──     ├── DOTHS.R
│   ├──     ├── DRELP.R
│   ├──     ├── DROOW.R
│   ├──     ├── DRSPO.R
│   ├──     ├── DSSIB.R
│   ├──     ├── DTOTP.R
│   └──     └── DTOTS.R
│   └── parentderived/          # Contains domain-specific parent level scripts sourced by the main scripts
│   ├──     ├── D05S_D07S_D13S_D05C_D07C_D13C.R
│   ├──     ├── DACAQ_DNVQ.R
│   ├──     ├── DACAQ_DNVQ_P.R
│   └──     └── KESSLER_WALI_GEHE_GENA.R
├── temp_data/
│   ├── cmderived/              # Temporary cohort member level files will be placed here
│   ├── familyderived/          # Temporary family level files will be placed here
│   └── parentderived/          # Temporary parent level files will be placed here
```

------------------------------------------------------------------------

## User feedback and future plans

We welcome user feedback and plan to expand this dataset in future releases. Please email clsdata\@ucl.ac.uk.

## Licence

Code: MIT Licence (see `LICENSE`). Datasets remain subject to the Millennium Cohort Study **End‑User Licence** terms.

------------------------------------------------------------------------

© 2026 UCL Centre for Longitudinal Studies