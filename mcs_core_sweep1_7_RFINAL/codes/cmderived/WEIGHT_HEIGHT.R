# WEIGHT	:	Weight (kilograms), measured or self-report
# HEIGHT	:	Height (centimetres), measured or self-report
# BMI_CLS	:	DV Cohort Member BMI according to present weight (calculated by CLS)

#1, Extract variables from raw MCS data
weight_height_mcs2 <- read_dta(file.path(mcs2, "mcs2_cm_interview.dta")) %>%
  zap_labels(weight_height_mcs2) %>%
  mutate(SWEEP = 2) %>%
  mutate(BMI = if_else(BCWTKC00 >= 0 & BCHCMC00 >= 0, BCWTKC00/((BCHCMC00/100)^2), NA_real_)) %>%
  mutate(BCWTKC00 = case_when(
    BCWTKC00 == -2 ~ -1,
    BCWTKC00 == -1 ~ -8,
    TRUE ~ BCWTKC00)) %>%
  mutate(BCHCMC00 = case_when(
    BCHCMC00 == -2 ~ -1,
    BCHCMC00 == -1 ~ -8,
    TRUE ~ BCHCMC00)) %>%
  mutate(BMI_CLS = BCBMIN00,
         WEIGHT = BCWTKC00,
         HEIGHT = BCHCMC00,
         CNUM = BCNUM00) %>%
  select(MCSID, CNUM, SWEEP, BMI, BMI_CLS, WEIGHT, HEIGHT)

weight_height_mcs3 <- read_dta(file.path(mcs3, "mcs3_cm_interview.dta")) %>%
  zap_labels(weight_height_mcs3) %>%
  mutate(SWEEP = 3) %>%
  mutate(BMI_CLS = BMIN3) %>%
  mutate(BMI = if_else(CCWTCM00 >= 0 & CCHTCM00 >= 0, CCWTCM00/((CCHTCM00/100)^2), NA_real_)) %>%
  mutate(WEIGHT = CCWTCM00,
         HEIGHT = CCHTCM00,
         CNUM = CCNUM00) %>%
  select(MCSID, CNUM, SWEEP, BMI, BMI_CLS, WEIGHT, HEIGHT)

weight_height_mcs4 <- read_dta(file.path(mcs4, "mcs4_cm_interview.dta")) %>%
  zap_labels(weight_height_mcs4) %>%
  mutate(WEIGHT = DCWTDV00,
         HEIGHT = DCHTDV00,
         CNUM = DCNUM00) %>%
  mutate(SWEEP = 4) %>%
  mutate(BMI = if_else(DCWTDV00 >= 0 & DCHTDV00 >= 0, DCWTDV00/((DCHTDV00/100)^2), NA_real_)) %>%
  mutate(BMI_CLS = DCBMIN4) %>%
  select(MCSID, CNUM, SWEEP, BMI, BMI_CLS, WEIGHT, HEIGHT)

weight_height_mcs5 <- read_dta(file.path(mcs5, "mcs5_cm_interview.dta")) %>%
  zap_labels(weight_height_mcs5) %>%
  mutate(ECWTCMB0 = case_when(
    ECWTCMB0 == -7 ~ -8,
    TRUE ~ ECWTCMB0)) %>%
  mutate(ECHTCMB0 = case_when(
    ECHTCMB0 == -7 ~ -8,
    TRUE ~ ECHTCMB0)) %>%
  mutate(WEIGHT = ECWTCMB0,
         HEIGHT = ECHTCMB0,
         CNUM = ECNUM00) %>%
  mutate(SWEEP = 5) %>%
  mutate(BMI = if_else(ECWTCMB0 >= 0 & ECHTCMB0 >= 0, ECWTCMB0/((ECHTCMB0/100)^2), NA_real_)) %>%
  mutate(BMI = case_when(
    BMI < 0 ~ NA,
    TRUE ~ BMI)) %>%
  mutate(BMI_CLS = EBMIN5) %>%
  select(MCSID, CNUM, SWEEP, BMI, BMI_CLS, WEIGHT, HEIGHT)

weight_height_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  zap_labels(weight_height_mcs6) %>%
  mutate(FCWTCM00 = case_when(
    FCWTCM00 == -5 ~ -8,
    TRUE ~ FCWTCM00)) %>%
  mutate(FCHTCM00 = case_when(
    FCHTCM00 == -5 ~ -8,
    TRUE ~ FCHTCM00)) %>%
  mutate(WEIGHT = FCWTCM00,
         HEIGHT = FCHTCM00,
         CNUM = FCNUM00) %>%
  mutate(BMI = if_else(FCWTCM00 >= 0 & FCHTCM00 >= 0, FCWTCM00/((FCHTCM00/100)^2), NA_real_)) %>%
  mutate(BMI = case_when(
    BMI < 0 ~ NA,
    TRUE ~ BMI)) %>%
  mutate(SWEEP = 6) %>%
  select(MCSID, CNUM, SWEEP, BMI, WEIGHT, HEIGHT)

weight_height_mcs6_2 <- read_dta(file.path(mcs6, "mcs6_cm_derived.dta")) %>%
  zap_labels(weight_height_mcs6_2) %>%
  mutate(CNUM = FCNUM00) %>%
  mutate(BMI_CLS = FCBMIN6) %>%
  select(MCSID, CNUM, BMI_CLS)

weight_height_mcs6 <- left_join(weight_height_mcs6, weight_height_mcs6_2, by = c("MCSID", "CNUM"))

weight_height_mcs7 <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  zap_labels(weight_height_mcs7) %>%
  mutate(GCWTCM00 = case_when(
    GCWTCM00 == -5 ~ -8,
    TRUE ~ GCWTCM00)) %>%
  mutate(GCHTCM00 = case_when(
    GCHTCM00 == -5 ~ -8,
    TRUE ~ GCHTCM00)) %>%
  mutate(WEIGHT = GCWTCM00,
         HEIGHT = GCHTCM00,
         CNUM = GCNUM00) %>%
  mutate(BMI = if_else(GCWTCM00 >= 0 & GCHTCM00 >= 0, GCWTCM00/((GCHTCM00/100)^2), NA_real_)) %>%
  mutate(BMI = case_when(
    BMI < 0 ~ NA,
    TRUE ~ BMI)) %>%
  mutate(SWEEP = 7) %>%
  select(MCSID, CNUM, SWEEP, BMI, WEIGHT, HEIGHT)

weight_height_mcs7_2 <- read_dta(file.path(mcs7, "mcs7_cm_derived.dta")) %>%
  zap_labels(weight_height_mcs7_2) %>%
  mutate(CNUM = GCNUM00) %>%
  mutate(BMI_CLS = GCBMIN7) %>%
  select(MCSID, CNUM, BMI_CLS)

weight_height_mcs7 <- left_join(weight_height_mcs7, weight_height_mcs7_2, by = c("MCSID", "CNUM")) %>%
  mutate(SWEEP = case_when(
    SWEEP == NA ~ 7,
    TRUE ~ SWEEP))

datasets <- list(weight_height_mcs2, weight_height_mcs3, weight_height_mcs4,
                 weight_height_mcs5, weight_height_mcs6, weight_height_mcs7)
weight_height_all <- bind_rows(datasets) %>% select(-BMI)
table(weight_height_all$SWEEP, useNA = "ifany")

#3, Generate new variable in a longitudinal format
weight_height_all <- weight_height_all %>%
  mutate(BMI_CLS = labelled(
    BMI_CLS,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1
    )
  ))

attr(weight_height_all$BMI_CLS, "label") <- "DV Cohort Member BMI according to present weight (calculated by CLS)"
table(weight_height_all$BMI_CLS, weight_height_all$SWEEP, useNA = "ifany")

weight_height_all <- weight_height_all %>%
  mutate(HEIGHT = labelled(
    HEIGHT,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1
    )
  ))

attr(weight_height_all$HEIGHT, "label") <- "Height (centimetres), measured or self-report"
table(weight_height_all$HEIGHT, weight_height_all$SWEEP, useNA = "ifany")

weight_height_all <- weight_height_all %>%
  mutate(WEIGHT = labelled(
    WEIGHT,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1
    )
  ))

attr(weight_height_all$WEIGHT, "label") <- "Weight (kilograms), measured or self-report"
table(weight_height_all$WEIGHT, weight_height_all$SWEEP, useNA = "ifany")

#4, save temporal data 
weight_height_all <- weight_height_all %>%
  mutate(SWEEP = labelled(
    SWEEP,labels = c( "MCS2" = 2, "MCS3" = 3,"MCS4" = 4, "MCS5" = 5,"MCS6" = 6, "MCS7" = 7)))

weight_height_all <- weight_height_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(weight_height_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(weight_height_all, file = file.path(temp_data_cdv, "WEIGHT_HEIGHT.Rds"))

#5, save working memory
rm(weight_height_all, weight_height_mcs2, weight_height_mcs3, weight_height_mcs4, weight_height_mcs5, weight_height_mcs6,
   weight_height_mcs6_2, weight_height_mcs7, weight_height_mcs7_2, datasets)