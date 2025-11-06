# CGHE		CM General level of health (Parental report)
# CGHE_SR	CM General level of health (CM self-rated)

#1, Extract variables from raw MCS data
cghe_mcs3 <- read_dta(file.path(mcs3, "mcs3_parent_cm_interview.dta")) %>%
  filter(CELIG00 == 1) %>%
  rename(CNUM = CCNUM00) %>%
  mutate(SWEEP = 3) %>%
  select(MCSID, CNUM, SWEEP, CPCGHE00)

cghe_mcs4 <- read_dta(file.path(mcs4, "mcs4_parent_cm_interview.dta")) %>%
  filter(DELIG00 == 1) %>%
  rename(CNUM = DCNUM00) %>%
  mutate(SWEEP = 4) %>%
  select(MCSID, CNUM, SWEEP, DPCGHE00)

cghe_mcs5 <- read_dta(file.path(mcs5, "mcs5_parent_cm_interview.dta")) %>%
  filter(EELIG00 == 1) %>%
  rename(CNUM = ECNUM00) %>%
  mutate(SWEEP = 5) %>%
  select(MCSID, CNUM, SWEEP, EPCGHE00)

cghe_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  mutate(SWEEP = 6) %>%
  rename(CNUM = FCNUM00) %>%
  select(MCSID, CNUM, SWEEP, FCCGHE00)

cghe_mcs7 <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  mutate(SWEEP = 7) %>%
  rename(CNUM = GCNUM00) %>%
  select(MCSID, CNUM, SWEEP, GCCGHE00)

datasets <- list(cghe_mcs3, cghe_mcs4,
                 cghe_mcs5, cghe_mcs6, cghe_mcs7)
cghe_all <- bind_rows(datasets)

table(cghe_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
cghe_all <- cghe_all %>%
  mutate(GCCGHE00 = case_when(
    GCCGHE00 == 6 ~ -8,
    GCCGHE00 == 7 ~ -9,
    GCCGHE00 == 8 ~ -1,
    TRUE ~ GCCGHE00))

#3, Generate new variable in a longitudinal format
cghe_all <- cghe_all %>%
  zap_labels(cghe_all) %>%
  mutate(CGHE = case_when(
    SWEEP == 3 ~ CPCGHE00,
    SWEEP == 4 ~ DPCGHE00,
    SWEEP == 5 ~ EPCGHE00,
    .default = NA_real_))

cghe_all <- cghe_all %>%
  zap_labels(cghe_all) %>%
  mutate(CGHE_SR = case_when(
    SWEEP == 6 ~ FCCGHE00,
    SWEEP == 7 ~ GCCGHE00,
    .default = NA_real_))

cghe_all <- cghe_all %>%
  mutate(CGHE = labelled(
    CGHE,
    labels = c(
      "Refusal" = -9,
      "Don't know" = -8,
      "Not Applicable" = -1,
      "Excellent" = 1,
      "Very good" = 2,
      "Good" = 3,
      "Fair" = 4,
      "Poor" = 5
    )
  ))
attr(cghe_all$CGHE, "label") <- "CM General level of health (Parental report)"
table(cghe_all$CGHE, cghe_all$SWEEP, useNA = "ifany")

cghe_all <- cghe_all %>%
  mutate(CGHE_SR = labelled(
    CGHE_SR,
    labels = c(
      "Refusal"       = -9,
      "Don't know"    = -8,
      "Not Applicable"= -1,
      "Excellent"     = 1,
      "Very good"     = 2,
      "Good"          = 3,
      "Fair"          = 4,
      "Poor"          = 5
    )
  ))
attr(cghe_all$CGHE_SR, "label") <- "CM General level of health (CM self-rated)"
table(cghe_all$CGHE_SR, cghe_all$SWEEP, useNA = "ifany")

#4, save temporal data 
cghe_all <- cghe_all %>% select(MCSID, CNUM, SWEEP, CGHE, CGHE_SR)
cghe_all <- cghe_all %>%
  mutate(SWEEP = labelled(
    SWEEP,
    labels = c(
      "MCS3" = 3,
      "MCS4" = 4,
      "MCS5" = 5,
      "MCS6" = 6,
      "MCS7" = 7
    )
  ))

cghe_all <- cghe_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                       labels = c("1st Cohort Member of the family",
                                  "2nd Cohort Member of the family",
                                  "3rd Cohort Member of the family")))
attr(cghe_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(cghe_all, file = file.path(temp_data_cdv, "CGHE.Rds"))

#5, save working memory
rm(cghe_all, cghe_mcs3, cghe_mcs4, cghe_mcs5, cghe_mcs6, cghe_mcs7, datasets)