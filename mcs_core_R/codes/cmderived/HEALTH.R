#HEALTH - COHORT MEMBER REPORTED MENTAL HEALTH
#EMOTION_C	:	DV SDQ Emotional Symptoms (CM-reported)
#CONDUCT_C	:	DV SDQ Conduct Problems (CM-reported)
#HYPER_C	:	DV SDQ Hyperactivity/Inattention (CM-reported)
#PEER_C	:	DV SDQ Peer Problems (CM-reported)
#PROSOC_C	:	DV SDQ Prosocial (CM-reported)
#EBDTOT_C	:	DV SDQ Total Difficulties (CM-reported)
#KESSLER_C: DV K6 Kessler (CM-reported)
#SELFHA: Self-harmed in the last 12 months
#SMFQ: Short Mood and Feelings Questionnaire total score
#SLEEPQ: Self-assessed sleep quality (past 4 weeks/month)
#SOCMEDH: Number of weekday hours spent on social media
#SOCMEDA: Feeling addicted to social media
#SOCMEDC: More connected and happier online than in real life
#WGHTP: Perception of weight

#1, Extract variables from raw MCS data
health_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  rename(CNUM = FCNUM00) %>%
  mutate(SWEEP = 6) %>%
  select(MCSID, CNUM, SWEEP, FCHARM00, FCMDSA00, FCMDSB00, FCMDSC00, FCMDSD00, FCMDSE00, FCMDSF00, FCMDSG00, 
         FCMDSH00, FCMDSI00, FCMDSJ00, FCMDSK00, FCMDSL00, FCMDSM00, FCWEGT00)

health_mcs7derived <- read_dta(file.path(mcs7, "mcs7_cm_derived.dta")) %>%
  rename(CNUM = GCNUM00) %>%
  mutate(SWEEP = 7) %>%
  select(MCSID, CNUM, SWEEP, GEMOTION_C, GCONDUCT_C, GHYPER_C, GPEER_C, GPROSOC_C, GEBDTOT_C, GDCKESSL)

health_mcs7interview <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  rename(CNUM = GCNUM00) %>%
  mutate(GSELFHA = case_when(
      rowSums(across(c(GCSHCU00, GCSHBU00, GCSHBR00, GCSHOD00, GCSHPU00, GCSHRM00), ~ .x %in% c(3, 4, 5))) == 6 ~ -1,
      rowSums(across(c(GCSHCU00, GCSHBU00, GCSHBR00, GCSHOD00, GCSHPU00, GCSHRM00), ~ .x == 1)) > 0 ~ 1,
      TRUE ~ 2)) %>%
  select(MCSID, CNUM, GSELFHA, GCSQLT00, GCSOME00, GCSOCM00, GCSOCH00, GCWEGT00)

health_mcs7 <- health_mcs7derived %>%
  full_join(health_mcs7interview, by = c("MCSID", "CNUM"))

health_mcs8derived <- read_dta(file.path(mcs8, "mcs8_23y_cm_derived.dta")) %>%
  rename(CNUM = hcnum00, MCSID = mcsid) %>%
  mutate(SWEEP = 8) %>%
  select(MCSID, CNUM, SWEEP, hdkessler6)

health_mcs8survey <- read_dta(file.path(mcs8, "mcs8_23y_cm_survey.dta")) %>%
  rename(CNUM = hcnum00, MCSID = mcsid) %>%
  mutate(HSELFHA = case_when(
    rowSums(across(c(hsshcu00, hsshbu00, hsshbr00, hsshod00, hsshpu00, hsshrm00), ~ .x %in% c(-9, -8, -3, -1))) == 6 ~ -1,
    rowSums(across(c(hsshcu00, hsshbu00, hsshbr00, hsshod00, hsshpu00, hsshrm00), ~ .x == 1)) > 0 ~ 1,
    TRUE ~ 2)) %>%
  select(MCSID, CNUM, HSELFHA, hssqlt00, hssome00, hssocm00, hssoch00, hswegt00)

health_mcs8 <- health_mcs8derived %>%
  full_join(health_mcs8survey, by = c("MCSID", "CNUM"))

datasets <- list(health_mcs6, health_mcs7, health_mcs8)
health_all <- bind_rows(datasets)
table(health_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
health_all <- health_all %>%
  rename(EMOTION_C = GEMOTION_C,
         CONDUCT_C = GCONDUCT_C,
         HYPER_C = GHYPER_C,
         PEER_C = GPEER_C,
         PROSOC_C = GPROSOC_C,
         EBDTOT_C = GEBDTOT_C)

smfq_items <- c(
  "FCMDSA00","FCMDSB00","FCMDSC00","FCMDSD00","FCMDSE00",
  "FCMDSF00","FCMDSG00","FCMDSH00","FCMDSI00","FCMDSJ00",
  "FCMDSK00","FCMDSL00","FCMDSM00")

health_all <- health_all %>%
  mutate(
    across(all_of(smfq_items),
           ~ case_when(
             .x >= -9 & .x <= -1 ~ NA_real_,
             .x == 1 ~ 0,
             .x == 2 ~ 1,
             .x == 3 ~ 2,
             TRUE    ~ .x)))

health_all <- health_all %>% 
  mutate(GCSQLT00 = case_when(
    GCSQLT00 == 5 ~ -8,
    GCSQLT00 == 6 ~ -9,
    GCSQLT00 == 7 ~ -1,
    TRUE ~ GCSQLT00)) %>%
  mutate(GCSOME00 = case_when(
    GCSOME00 == 10 ~ -8,
    GCSOME00 == 11 ~ -9,
    GCSOME00 == 12 ~ -1,
    TRUE ~ GCSOME00)) %>%
  mutate(GCSOCM00 = case_when(
    GCSOCM00 == 5 ~ -8,
    GCSOCM00 == 6 ~ -9,
    GCSOCM00 == 7 ~ -1,
    TRUE ~ GCSOCM00)) %>%
  mutate(GCSOCH00 = case_when(
    GCSOCH00 == 5 ~ -8,
    GCSOCH00 == 6 ~ -9,
    GCSOCH00 == 7 ~ -1,
    TRUE ~ GCSOCH00)) %>%
  mutate(GCWEGT00 = case_when(
    GCWEGT00 == 5 ~ -8,
    GCWEGT00 == 6 ~ -9,
    GCWEGT00 == 7 ~ -1,
    TRUE ~ GCWEGT00))
  
#3, Generate new variable in a longitudinal format
health_all <- health_all %>%
  mutate(SELFHA = case_when(
    SWEEP == 6 ~ FCHARM00,
    SWEEP == 7 ~ GSELFHA,
    SWEEP == 8 ~ HSELFHA,
    .default = NA_real_)) %>%
  zap_labels(health_all) %>%
  mutate(SELFHA = case_when(
    SELFHA == 2 ~ 0,
    TRUE ~ SELFHA)) %>%
  mutate(KESSLER_C = case_when(
    SWEEP == 7 ~ GDCKESSL,
    SWEEP == 8 ~ hdkessler6,
    .default = NA_real_)) %>%
  mutate(SLEEPQ = case_when(
    SWEEP == 7 ~ GCSQLT00,
    SWEEP == 8 ~ hssqlt00,
    .default = NA_real_)) %>%
  mutate(SOCMEDH = case_when(
    SWEEP == 7 ~ GCSOME00,
    SWEEP == 8 ~ hssome00,
    .default = NA_real_)) %>%
  mutate(SOCMEDA = case_when(
    SWEEP == 7 ~ GCSOCM00,
    SWEEP == 8 ~ hssocm00,
    .default = NA_real_)) %>%
  mutate(SOCMEDC = case_when(
    SWEEP == 7 ~ GCSOCH00,
    SWEEP == 8 ~ hssoch00,
    .default = NA_real_)) %>%
  mutate(WGHTP = case_when(
    SWEEP == 6 ~ FCWEGT00,
    SWEEP == 7 ~ GCWEGT00,
    SWEEP == 8 ~ hswegt00,
    .default = NA_real_))

health_all <- health_all %>% mutate(SMFQ = rowSums(across(all_of(smfq_items)), na.rm = TRUE))

# for to attach labels to variables 
vars_to_label <- c("EMOTION_C", "CONDUCT_C", "HYPER_C", "PEER_C", "PROSOC_C", "EBDTOT_C")

for (var in vars_to_label) {
  
  # Combine all levels and labels
  all_levels <- c(-9, -8, -1)
  all_labels <- c("Refusal", "Don't know", "Not applicable")
  
  # Use := with !!sym() to programmatically assign to variable name
  health_all <- health_all %>%
    mutate(!!sym(var) := labelled(.data[[var]], labels = setNames(all_levels, all_labels)))
}

health_all <- health_all %>%
  mutate(SELFHA = labelled(SELFHA,
                           labels = c("Refusal" = -9, "Don't know" = -8, "Not Applicable" = -1, "No" = 0, "Yes" = 1))) %>%
  mutate(KESSLER_C = labelled(KESSLER_C,
                           labels = c("Refusal" = -9, "Not enough information" = -8, "Not Applicable" = -1))) %>%
  mutate(SLEEPQ = labelled(SLEEPQ,
                              labels = c("Prefer not to say" = -9, "Don't know" = -8, "Not asked at case fieldwork stage" = -3, "Not Applicable" = -1,
                                         "Very good" = 1, "Fairly good" = 2, "Fairly bad" = 3, "Very bad" = 4))) %>%
  mutate(SOCMEDH = labelled(SOCMEDH,
                              labels = c("Prefer not to say" = -9, "Don't know" = -8, "Not asked at case fieldwork stage" = -3, "Not Applicable" = -1,
                                         "None" = 1, "Less than half an hour" = 2, "Half an hour to less than 1 hour" = 3, "1 hour to less than 2 hours" = 4, 
                                         "2 hours to less than 3 hours" = 5, "3 hours to less than 5 hours" = 6, "5 hours to less than 7 hours" = 7,
                                         "7 hours to less than 10 hours" = 8, "10 hours or more" = 9))) %>%
  mutate(SOCMEDA = labelled(SOCMEDA,
                              labels = c("Prefer not to say" = -9, "Don't know" = -8, "Not asked at case fieldwork stage" = -3, "Not Applicable" = -1,
                                         "Strongly agree" = 1, "Agree" = 2, "Disgaree" = 3, "Strongly disagree" = 4))) %>%
  mutate(SOCMEDC = labelled(SOCMEDC,
                              labels = c("Prefer not to say" = -9, "Don't know" = -8, "Not asked at case fieldwork stage" = -3, "Not Applicable" = -1,
                                         "Strongly agree" = 1, "Agree" = 2, "Disgaree" = 3, "Strongly disagree" = 4))) %>%
  mutate(WGHTP = labelled(WGHTP,
                              labels = c("Prefer not to say" = -9, "Don't know" = -8, "Not asked at case fieldwork stage" = -3, "Not Applicable" = -1,
                                         "Underweight" = 1, "About the right weight" = 2, "Slightly overweight" = 3, "Very overweight" = 4)))

attr(health_all$EMOTION_C, "label") <- "DV SDQ Emotional Symptoms (cohort member-reported)"
attr(health_all$CONDUCT_C, "label") <- "DV SDQ Conduct Problems (cohort member-reported)"
attr(health_all$HYPER_C, "label") <- "DV SDQ Hyperactivity/Inattention (cohort member-reported)"
attr(health_all$PEER_C, "label") <- "DV SDQ Peer Problems (cohort member-reported)"
attr(health_all$PROSOC_C, "label") <- "DV SDQ Prosocial (cohort member-reported)"
attr(health_all$EBDTOT_C, "label") <- "DV SDQ Total (cohort member-reported)"
attr(health_all$KESSLER_C, "label") <- "DV K6 Kessler score (cohort member-reported)"
attr(health_all$SELFHA, "label") <- "Hurt yourself on purpose during the last year"
attr(health_all$SMFQ, "label") <- "Short Mood and Feelings Questionnaire total score"
attr(health_all$SLEEPQ, "label") <- "Self-assessed sleep quality (past 4 weeks/month)"
attr(health_all$SOCMEDH, "label") <- "Number of weekday hours spent on social media"
attr(health_all$SOCMEDA, "label") <- "Feeling addicted to social media"
attr(health_all$SOCMEDC, "label") <- "More connected and happier online than in real life"
attr(health_all$WGHTP, "label") <- "Perception of weight"

table(health_all$EMOTION_C, health_all$SWEEP, useNA = "ifany")
table(health_all$CONDUCT_C, health_all$SWEEP, useNA = "ifany")
table(health_all$HYPER_C, health_all$SWEEP, useNA = "ifany")
table(health_all$PEER_C, health_all$SWEEP, useNA = "ifany")
table(health_all$PROSOC_C, health_all$SWEEP, useNA = "ifany")
table(health_all$EBDTOT_C, health_all$SWEEP, useNA = "ifany")
table(health_all$KESSLER_C, health_all$SWEEP, useNA = "ifany")
table(health_all$SELFHA, health_all$SWEEP, useNA = "ifany")
table(health_all$SMFQ, health_all$SWEEP, useNA = "ifany")
table(health_all$SLEEPQ, health_all$SWEEP, useNA = "ifany")
table(health_all$SOCMEDH, health_all$SWEEP, useNA = "ifany")
table(health_all$SOCMEDA, health_all$SWEEP, useNA = "ifany")
table(health_all$SOCMEDC, health_all$SWEEP, useNA = "ifany")
table(health_all$WGHTP, health_all$SWEEP, useNA = "ifany")

#4, save temporal data 
health_all <- health_all %>% select(SWEEP, MCSID, CNUM, EMOTION_C, CONDUCT_C, HYPER_C, PEER_C, 
                                    PROSOC_C, EBDTOT_C, KESSLER_C, SELFHA, SMFQ,
                                    SLEEPQ, SOCMEDH, SOCMEDA, SOCMEDC, WGHTP)
health_all <- health_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c("MCS6" = 6, "MCS7" = 7, "MCS8" = 8)))

health_all <- health_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(health_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(health_all, file = file.path(temp_data_cdv, "health.Rds"))

#5, save working memory
rm(health_mcs6, health_mcs7, health_mcs7derived, health_mcs7interview, health_all, health_mcs8derived, health_mcs8survey, health_mcs8, datasets, smfq_items)