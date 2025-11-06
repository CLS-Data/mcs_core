# CLSI		: CM has longstanding illness (reported by parent)
# CLSI_SR	: CM has longstanding illness (reported by CM)
# CLSL		: CM has conditions/illnesses limit every day activities (reported by parent)
# CLSL_SR 	: CM has conditions/illnesses limit every day activities (reported by CM)

#1, Extract variables from raw MCS data
clsi_mcs2 <- read_dta(file.path(mcs2, "mcs2_parent_cm_interview.dta")) %>%
  filter(BELIG00 == 1) %>%
  rename(CNUM = BCNUM00) %>%
  mutate(SWEEP = 2) %>%
  select(MCSID, CNUM, SWEEP, BPCLSI00, BPCLSL00)

clsi_mcs3 <- read_dta(file.path(mcs3, "mcs3_parent_cm_interview.dta")) %>%
  filter(CELIG00 == 1) %>%
  rename(CNUM = CCNUM00) %>%
  mutate(SWEEP = 3) %>%
  select(MCSID, CNUM, SWEEP, CPCLSI00, CPCLSMA0, CPCLSMB0, CPCLSMC0, CPCLSL00)

clsi_mcs4 <- read_dta(file.path(mcs4, "mcs4_parent_cm_interview.dta")) %>%
  filter(DELIG00 == 1) %>%
  rename(CNUM = DCNUM00) %>%
  mutate(SWEEP = 4) %>%
  select(MCSID, CNUM, SWEEP, DPCLSI00, DPCLSL00)

clsi_mcs5 <- read_dta(file.path(mcs5, "mcs5_parent_cm_interview.dta")) %>%
  filter(EELIG00 == 1) %>%
  rename(CNUM = ECNUM00) %>%
  mutate(SWEEP = 5) %>%
  select(MCSID, CNUM, SWEEP, EPCLSI00, EPCLSL00, EPCLSP00)

clsi_mcs6 <- read_dta(file.path(mcs6, "mcs6_parent_cm_interview.dta")) %>%
  filter(FELIG00 == 1) %>%
  rename(CNUM = FCNUM00) %>%
  mutate(SWEEP = 6) %>%
  select(MCSID, CNUM, SWEEP, FPCLSI00, FPCLSL00, FPCLSP00)

clsi_mcs7 <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  rename(CNUM = GCNUM00) %>%
  mutate(SWEEP = 7) %>%
  select(MCSID, CNUM, SWEEP, GCCLSI00, GCCLSL00, GCCLSP00)

datasets <- list(clsi_mcs2, clsi_mcs3, clsi_mcs4, clsi_mcs5, clsi_mcs6, clsi_mcs7)
clsi_clsl_all <- bind_rows(datasets)
table(clsi_clsl_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
clsi_clsl_all <- clsi_clsl_all %>%
  mutate(GCCLSI00 = case_when(
    GCCLSI00 == 3 ~ -8,
    GCCLSI00 == 4 ~ -9,
    GCCLSI00 == 5 ~ -1,
    TRUE ~ GCCLSI00)) %>%
  mutate(EPCLSL00 = case_when(
    EPCLSL00 == 1 ~ 1,
    EPCLSL00 == 2 ~ 1,
    EPCLSL00 == 3 ~ 2,
    TRUE ~ EPCLSL00)) %>%
  mutate(FPCLSL00 = case_when(
    FPCLSL00 == 1 ~ 1,
    FPCLSL00 == 2 ~ 1,
    FPCLSL00 == 3 ~ 2,
    TRUE ~ FPCLSL00)) %>%
  mutate(GCCLSL00 = case_when(
    GCCLSL00 == 1 ~ 1,
    GCCLSL00 == 2 ~ 1,
    GCCLSL00 == 3 ~ 2,
    GCCLSL00 == 4 ~ -8,
    GCCLSL00 == 6 ~ -1,
    TRUE ~ GCCLSL00))

#3, Generate new variable in a longitudinal format
clsi_clsl_all <- clsi_clsl_all %>%
  zap_labels(clsi_clsl_all) %>%
  mutate(CLSI = case_when(
    SWEEP == 2 ~ BPCLSI00,
    SWEEP == 3 ~ CPCLSI00,
    SWEEP == 4 ~ DPCLSI00,
    SWEEP == 5 ~ EPCLSI00,
    SWEEP == 6 ~ FPCLSI00,
    .default = NA_real_))

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(CLSI_SR = NA_real_) %>%
  mutate(CLSI_SR = case_when(
    SWEEP == 7 ~ GCCLSI00,
    TRUE ~ CLSI_SR))

clsi_clsl_all <- clsi_clsl_all %>%
  zap_labels(clsi_clsl_all) %>%
  mutate(CLSL = case_when(
    SWEEP == 2 ~ BPCLSL00,
    SWEEP == 3 ~ CPCLSL00,
    SWEEP == 4 ~ DPCLSL00,
    SWEEP == 5 ~ EPCLSL00,
    SWEEP == 6 ~ FPCLSL00,
    .default = NA_real_))

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(CLSL_SR = NA_real_) %>%
  mutate(CLSL_SR = case_when(
    SWEEP == 7 ~ GCCLSL00,
    TRUE ~ CLSL_SR))

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(CLSI = labelled(
    CLSI,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1,
      "Yes"            = 1,
      "No"             = 2
    )
  ))
attr(clsi_clsl_all$CLSI, "label") <- "CM has longstanding illness (reported by parent)"
table(clsi_clsl_all$CLSI, clsi_clsl_all$SWEEP, useNA = "ifany")

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(CLSI_SR = labelled(
    CLSI_SR,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1,
      "Yes"            = 1,
      "No"             = 2
    )
  ))
attr(clsi_clsl_all$CLSI_SR, "label") <- "CM has longstanding illness (reported by CM)"
table(clsi_clsl_all$CLSI_SR, clsi_clsl_all$SWEEP, useNA = "ifany")

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(CLSL = labelled(
    CLSL,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1,
      "Yes"            = 1,
      "No"             = 2
    )
  ))

attr(clsi_clsl_all$CLSL, "label") <- "CM has conditions/illnesses limit every day activities (reported by parent)"
table(clsi_clsl_all$CLSL, clsi_clsl_all$SWEEP, useNA = "ifany")

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(CLSL_SR = labelled(
    CLSL_SR,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1,
      "Yes"            = 1,
      "No"             = 2
    )
  ))
attr(clsi_clsl_all$CLSL_SR, "label") <- "CM has conditions/illnesses limit every day activities (reported by CM)"
table(clsi_clsl_all$CLSL_SR, clsi_clsl_all$SWEEP, useNA = "ifany")

#4, save temporal data 
clsi_clsl_all <- clsi_clsl_all %>% select(MCSID, CNUM, SWEEP, CLSI, CLSI_SR, CLSL, CLSL_SR)

clsi_clsl_all <- clsi_clsl_all %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7))) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(clsi_clsl_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(clsi_clsl_all, file = file.path(temp_data_cdv, "CLSI_CLSL.Rds"))

#5, save working memory
rm(clsi_clsl_all, clsi_mcs2, clsi_mcs3, clsi_mcs4, clsi_mcs5, clsi_mcs6, clsi_mcs7, datasets)