# Substance Use 
#ALCOEV: Ever had an alcoholic drink
#ALCOFR: Frequency of alcohol drinks in the past four weeks
#ALCOBI: Ever had five or more drinks at a time
#SMOKCI: Ever tried smoking
#SMOKVA: Ever tried e-cigarettes or vapes
#DRUGCA: Ever tried cannabis
#DRUGHA: Ever tried hard drugs

#1, Extract variables from raw MCS data
substance_mcs5 <- read_dta(file.path(mcs5, "mcs5_cm_interview.dta")) %>%
  mutate(SWEEP = 5) %>%
  rename(CNUM = ECNUM00) %>%
  select(MCSID, SWEEP, CNUM, ECQ61X00, ECQ64X00, ECQ67X00, ECQ59X00)

substance_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  mutate(SWEEP = 6) %>%
  rename(CNUM = FCNUM00) %>%
  select(MCSID, SWEEP, CNUM, FCALCD00, FCALNF00, FCALFV00, FCSMOK00, FCECIG00, FCCANB00, FCOTDR00)

substance_mcs7 <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  mutate(SWEEP = 7) %>%
  rename(CNUM = GCNUM00) %>%
  mutate(
    GHARDDRUG = case_when(
      rowSums(across(c(GCDRUB00, GCDRUC00, GCDRUD00, GCDRUL00, GCDRUI00, GCDRUJ00, GCDRUK00), ~ .x %in% c(3, 4, 5))) == 7 ~ -1,
      rowSums(across(c(GCDRUB00, GCDRUC00, GCDRUD00, GCDRUL00, GCDRUI00, GCDRUJ00, GCDRUK00), ~ .x == 1)) > 0 ~ 1,
      TRUE ~ 2)) %>%
  select(MCSID, SWEEP, CNUM, GCALCD00, GCALNF00, GCALFV00, GCSMOK00, GCVAPE00, GCDRUA00, GHARDDRUG)

datasets <- list(substance_mcs5, substance_mcs6, substance_mcs7)
substance_all <- bind_rows(datasets)
table(substance_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
substance_all <- substance_all %>%
  mutate(ECQ61X00 = case_when(
    TRUE ~ ECQ61X00)) %>%
  mutate(ECQ64X00 = case_when(
    TRUE ~ ECQ64X00)) %>%
  mutate(ECQ67X00 = case_when(
    TRUE ~ ECQ67X00)) %>%
  mutate(ECQ59X00 = case_when(
    TRUE ~ ECQ59X00)) %>%
  mutate(FCSMOK00 = case_when(
    FCSMOK00 == 1 ~ 2,
    FCSMOK00 == 2 ~ 1,
    FCSMOK00 == 3 ~ 1,
    FCSMOK00 == 4 ~ 1,
    FCSMOK00 == 5 ~ 1,
    FCSMOK00 == 6 ~ 1,
    TRUE ~ FCSMOK00)) %>%
  mutate(FCECIG00 = case_when(
    FCECIG00 == 1 ~ 2,
    FCECIG00 == 2 ~ 1,
    FCECIG00 == 3 ~ 1,
    FCECIG00 == 4 ~ 1,
    TRUE ~ FCECIG00)) %>%
  mutate(GCALCD00 = case_when(
    GCALCD00 == 3 ~ -8,
    GCALCD00 == 4 ~ -9,
    GCALCD00 == 5 ~ -1,
    TRUE ~ GCALCD00)) %>%
  mutate(GCALFV00 = case_when(
    GCALFV00 == 3 ~ -8,
    GCALFV00 == 4 ~ -9,
    GCALFV00 == 5 ~ -1,
    TRUE ~ GCALFV00)) %>%
  mutate(GCSMOK00 = case_when(
    GCSMOK00 == 1 ~ 2,
    GCSMOK00 == 2 ~ 1,
    GCSMOK00 == 3 ~ 1,
    GCSMOK00 == 4 ~ 1,
    GCSMOK00 == 5 ~ 1,
    GCSMOK00 == 6 ~ 1,
    GCSMOK00 == 7 ~ -8,
    GCSMOK00 == 8 ~ -9,
    GCSMOK00 == 9 ~ -1,
    TRUE ~ GCSMOK00)) %>%
  mutate(GCDRUA00 = case_when(
    GCDRUA00 == 3 ~ -8,
    GCDRUA00 == 4 ~ -9,
    GCDRUA00 == 5 ~ -1,
    TRUE ~ GCDRUA00)) %>%
  mutate(GCALNF00 = case_when(
    GCALNF00 == 8 ~ -8,
    GCALNF00 == 9 ~ -9,
    GCALNF00 == 10 ~ -1,
    TRUE ~ GCALNF00)) %>%
  mutate(GCVAPE00 = case_when(
    GCVAPE00 == 1 ~ 2,
    GCVAPE00 == 2 ~ 1,
    GCVAPE00 == 3 ~ 1,
    GCVAPE00 == 4 ~ 1,
    GCVAPE00 == 5 ~ 1,
    GCVAPE00 == 6 ~ 1,
    GCVAPE00 == 7 ~ -8,
    GCVAPE00 == 8 ~ -9,
    GCVAPE00 == 9 ~ -1,
    TRUE ~ GCVAPE00))
 
#3, Generate new variable in a longitudinal format
substance_all <- substance_all %>%
  zap_labels(substance_all) %>%
  mutate(ALCOEV = case_when(
    SWEEP == 5 ~ ECQ61X00,
    SWEEP == 6 ~ FCALCD00,
    SWEEP == 7 ~ GCALCD00,
    .default = NA_real_)) %>%
  mutate(ALCOEV = case_when(
    ALCOEV == 2 ~ 0,
    TRUE ~ ALCOEV)) %>%
  mutate(ALCOFR = case_when(
    SWEEP == 5 ~ ECQ64X00,
    SWEEP == 6 ~ FCALNF00,
    SWEEP == 7 ~ GCALNF00,
    .default = NA_real_)) %>%
  mutate(ALCOBI = case_when(
    SWEEP == 5 ~ ECQ67X00,
    SWEEP == 6 ~ FCALFV00,
    SWEEP == 7 ~ GCALFV00,
    .default = NA_real_)) %>%
  mutate(ALCOBI = case_when(
    ALCOBI == 2 ~ 0,
    TRUE ~ ALCOBI)) %>%
  mutate(SMOKCI = case_when(
    SWEEP == 5 ~ ECQ59X00,
    SWEEP == 6 ~ FCSMOK00,
    SWEEP == 7 ~ GCSMOK00,
    .default = NA_real_)) %>%
  mutate(SMOKCI = case_when(
    SMOKCI == 2 ~ 0,
    TRUE ~ SMOKCI)) %>%
  mutate(SMOKVA = case_when(
    SWEEP == 6 ~ FCECIG00,
    SWEEP == 7 ~ GCVAPE00,
    .default = NA_real_)) %>%
  mutate(SMOKVA = case_when(
    SMOKVA == 2 ~ 0,
    TRUE ~ SMOKVA)) %>%
  mutate(DRUGCA = case_when(
    SWEEP == 6 ~ FCCANB00,
    SWEEP == 7 ~ GCDRUA00,
    .default = NA_real_)) %>%
  mutate(DRUGCA = case_when(
    DRUGCA == 2 ~ 0,
    TRUE ~ DRUGCA)) %>%
  mutate(DRUGHA = case_when(
    SWEEP == 6 ~ FCOTDR00,
    SWEEP == 7 ~ GHARDDRUG,
    .default = NA_real_)) %>%
  mutate(DRUGHA = case_when(
    DRUGHA == 2 ~ 0,
    TRUE ~ DRUGHA))

substance_all <- substance_all %>%
  mutate(ALCOEV = labelled(ALCOEV,
                           labels = c("Don't want to answer" = -9, "No answer/Don't know" = -8, "Not Applicable" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(ALCOFR = labelled(ALCOFR,
                           labels = c("Don't want to answer" = -9, "No answer/Don't know" = -8, "Not Applicable" = -1,
                                      "Never" = 1, "1-2 times" = 2, "3-5 times" = 3, "6-9 times" = 4,
                                      "10-19 times" = 5, "20-39 times" = 6, "40+ times" = 7))) %>%
  mutate(ALCOBI = labelled(ALCOBI,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(SMOKCI = labelled(SMOKCI,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(SMOKVA = labelled(SMOKVA,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(DRUGCA = labelled(DRUGCA,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(DRUGHA = labelled(DRUGHA,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable" = -1, 
                                      "No" = 0, "Yes" = 1)))

attr(substance_all$ALCOEV, "label") <- "Ever had an alcoholic drink"
attr(substance_all$ALCOFR, "label") <- "Alcoholic drink frequency in the last 4 weeks"
attr(substance_all$ALCOBI, "label") <- "Ever had five or more alcoholic drinks at a time"
attr(substance_all$SMOKCI, "label") <- "Ever smoked a cigarette"
attr(substance_all$SMOKVA, "label") <- "Ever smoked an e-cigarette or used a vape"
attr(substance_all$DRUGCA, "label") <- "Ever taken cannabis/marijuana/weed"
attr(substance_all$DRUGHA, "label") <- "Ever taken hard drugs (cocaine, acid/LSD, ecstasy, speed, ketamine, mephedrone, psychoactive substances)"

table(substance_all$ALCOEV, substance_all$SWEEP, useNA = "ifany")
table(substance_all$ALCOFR, substance_all$SWEEP, useNA = "ifany")
table(substance_all$ALCOBI, substance_all$SWEEP, useNA = "ifany")
table(substance_all$SMOKCI, substance_all$SWEEP, useNA = "ifany")
table(substance_all$SMOKVA, substance_all$SWEEP, useNA = "ifany")
table(substance_all$DRUGCA, substance_all$SWEEP, useNA = "ifany")
table(substance_all$DRUGHA, substance_all$SWEEP, useNA = "ifany")

#4, save temporal data 
substance_all <- substance_all %>% select(SWEEP, MCSID, CNUM, ALCOEV, ALCOFR, ALCOBI, SMOKCI, SMOKVA, DRUGCA, DRUGHA)
substance_all <- substance_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c("MCS5" = 5, "MCS6" = 6, "MCS7" = 7)))

substance_all <- substance_all %>%  
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(substance_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(substance_all, file = file.path(temp_data_cdv, "SUBSTANCE.Rds"))

#5, save working memory
rm(substance_all, substance_mcs5, substance_mcs6, substance_mcs7, datasets)