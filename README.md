# Title [e.g., Next Steps Longitudinal Derived Variable dataset - note also repository names should ideally be short and descriptive, e.g., mcs_x (where x is the type of variables covered in a single word)]

[Centre for Longitudinal Studies](https://cls.ucl.ac.uk/)

---

## Overview [high-level summary, e.g. the below]
- This repository provides **R scripts** that harmonise the multiple sweeps of [**Next Steps**](https://cls.ucl.ac.uk/cls-studies/next-steps/) into a single tidy dataset, so analysts can get straight to research rather than recoding. 
- The variables are given consistent names that reflect the content and age of participants (e.g., `Educ25` for **educational** attainment at age 25).

---

## Included variable domains [give an illustrative overview – no need to duplicate what already exists e.g., in UKDS documentation]

| Domain         | Examples                               |
| -------------- | -------------------------------------- |
| Demographics   | sex, ethnicity, language               |
| Socio-economic | parental education, household income   |
| Education      | qualifications, institution type       |
| Health         | self-rated health, limiting illness    |
| Relationships  | partnership status, sexual orientation |

*See `xxx.docx` for full details.*

---

## Syntax and data availability [tell the user where the syntax is + how source data should be **set up** to run it]

- *Source data:* Download raw Next Steps files from the **UK Data Service** and place them in `data/raw/`.
- *Syntax:* `01_build_dataset.R` reads those files and produces `data/derived/next_steps.parquet` *(note: keep the code well-commented and use **relative** file paths—e.g., `here::here("data", "raw", ...)` in R, or `$raw` / `$derived` globals in Stata).*
- *Derived dataset:* Available to download from the [**UK Data Service**](https://beta.ukdataservice.ac.uk).

---

## User feedback and future plans

We welcome user feedback. Please open an issue on GitHub or email **clsdata@ucl.ac.uk**.

## Authors
- X author
 
## Contributors [optional e.g., for code checkers]

- X contributor

## Licence  
Code: MIT Licence (see `LICENSE`).

---

© 2025 UCL Centre for Longitudinal Studies
