# mcs_core Longitudinal Dataset

[Centre for Longitudinal Studies](https://cls.ucl.ac.uk/)

---

## Overview [high-level summary, e.g. the below]
- This repository provides **R scripts** that harmonise the multiple sweeps of [**Millennium Cohort Study**](https://cls.ucl.ac.uk/cls-studies/millennium-cohort-study//) into a single tidy dataset, so analysts can get straight to research rather than recoding. 
---

## Included variable domains

| Domain         | Examples                               |
| -------------- | -------------------------------------- |
| Demographics   | sex, ethnicity, language               |
| Socio-economic | parental education, household income   |
| Education      | qualifications, institution type       |
| Health         | self-rated health, limiting illness    |
| Relationships  | partnership status, sexual orientation |

*See `mcs_core_sweeps 1_7_user_guide.docx` for full details.*

---

## Syntax and data availability for R
1. Download the following folders as .dta files from the UK Data Service (UKDS):
SN 4683, SN 5350, SN 5795, SN 6411, SN 7464, SN 8156, SN 8682, SN 8172, SN 8550.
2. Open the file "1_MCS_Core.R" within the Codes subfolder.
3. Define the path for core_dir to the folder that this file is contained in.
4. Define the subpaths for each of the 9 folders downloaded from UKDS.
5. Run or source the entire 1_MCS_Core.R.
6. Your completed MCS Core file can be found in the temp_data folder.

## Syntax and data availability for Stata
1. Download the following folders as .dta files from the UK Data Service (UKDS):
SN 4683, SN 5350, SN 5795, SN 6411, SN 7464, SN 8156, SN 8682, SN 8172, SN 8550.
2. Open the file 1_MCS_Core.do within the Codes subfolder.
3. Define the path for core_dir to the folder this file is contained in.
4. Define the subpaths for each of the 9 folders downloaded from UKDS.
5. Run the entire 1_MCS_Core.do.
6. Your completed MCS Core file can be found in the temp_data folder.

---

## User feedback and future plans

We welcome user feedback. Please open an issue on GitHub or email **clsdata@ucl.ac.uk**.

## Authors
- Nicolas Libuy
- Dominic Kelly
- Emla Fitzsimons
 
## Contributors

- Megan Arnot
- Gergo Baranyi
- Uta Bolt
- Ollie Cassaganeau-Francis
- Marta Francesconi
- Tom Metherell
- Larissa Pople
- Georgia Turner

## Licence  
Code: MIT Licence (see `LICENSE`).

---

© 2025 UCL Centre for Longitudinal Studies
