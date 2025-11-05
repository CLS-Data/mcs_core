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

#1, Extract variables from raw MCS data
health_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  rename(CNUM = FCNUM00) %>%
  mutate(SWEEP = 6) %>%
  select(MCSID, CNUM, SWEEP, FCHARM00, FCMDSA00, FCMDSB00, FCMDSC00, FCMDSD00, FCMDSE00, FCMDSF00, FCMDSG00, 
         FCMDSH00, FCMDSI00, FCMDSJ00, FCMDSK00, FCMDSL00, FCMDSM00)

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
  select(MCSID, CNUM, GSELFHA)

health_mcs7 <- health_mcs7derived %>%
  full_join(health_mcs7interview, by = c("MCSID", "CNUM"))

datasets <- list(health_mcs6, health_mcs7)
health_all <- bind_rows(datasets)
table(health_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
health_all <- health_all %>%
  rename(EMOTION_C = GEMOTION_C,
         CONDUCT_C = GCONDUCT_C,
         HYPER_C = GHYPER_C,
         PEER_C = GPEER_C,
         PROSOC_C = GPROSOC_C,
         EBDTOT_C = GEBDTOT_C,
         KESSLER_C = GDCKESSL)

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
  
#3, Generate new variable in a longitudinal format
health_all <- health_all %>%
  mutate(SELFHA = case_when(
    SWEEP == 6 ~ FCHARM00,
    SWEEP == 7 ~ GSELFHA,
    .default = NA_real_)) %>%
  mutate(SELFHA = case_when(
    SELFHA == 2 ~ 0,
    TRUE ~ SELFHA))

health_all <- health_all %>% mutate(SMFQ = rowSums(across(all_of(smfq_items))), na.rm = TRUE) 

# for to attach labels to variables 
vars_to_label <- c("EMOTION_C", "CONDUCT_C", "HYPER_C", "PEER_C", "PROSOC_C", "EBDTOT_C", "KESSLER_C")

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
    labels = c("Refusal" = -9, "Don't know" = -8, "Not Applicable" = -1,
      "No" = 0, "Yes" = 1)))  

attr(health_all$EMOTION_C, "label") <- "DV SDQ Emotional Symptoms (cohort member-reported)"
attr(health_all$CONDUCT_C, "label") <- "DV SDQ Conduct Problems (cohort member-reported)"
attr(health_all$HYPER_C, "label") <- "DV SDQ Hyperactivity/Inattention (cohort member-reported)"
attr(health_all$PEER_C, "label") <- "DV SDQ Peer Problems (cohort member-reported)"
attr(health_all$PROSOC_C, "label") <- "DV SDQ Prosocial (cohort member-reported)"
attr(health_all$EBDTOT_C, "label") <- "DV SDQ Total (cohort member-reported)"
attr(health_all$KESSLER_C, "label") <- "DV K6 Kessler score (cohort member-reported)"
attr(health_all$SELFHA, "label") <- "Hurt yourself on purpose during the last year"
attr(health_all$SMFQ, "label") <- "Short Mood and Feelings Questionnaire total score"

table(health_all$EMOTION_C, health_all$SWEEP, useNA = "ifany")
table(health_all$CONDUCT_C, health_all$SWEEP, useNA = "ifany")
table(health_all$HYPER_C, health_all$SWEEP, useNA = "ifany")
table(health_all$PEER_C, health_all$SWEEP, useNA = "ifany")
table(health_all$PROSOC_C, health_all$SWEEP, useNA = "ifany")
table(health_all$EBDTOT_C, health_all$SWEEP, useNA = "ifany")
table(health_all$KESSLER_C, health_all$SWEEP, useNA = "ifany")
table(health_all$SELFHA, health_all$SWEEP, useNA = "ifany")
table(health_all$SMFQ, health_all$SWEEP, useNA = "ifany")

#4, save temporal data 
health_all <- health_all %>% select(SWEEP, MCSID, CNUM, EMOTION_C, CONDUCT_C, HYPER_C, PEER_C, 
                                    PROSOC_C, EBDTOT_C, KESSLER_C, SELFHA, SMFQ)
health_all <- health_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c("MCS6" = 6, "MCS7" = 7)))

health_all <- health_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(health_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(health_all, file = file.path(temp_data_cdv, "health.Rds"))

#5, save working memory
rm(health_mcs6, health_mcs7, health_mcs7derived, health_mcs7interview, health_all, datasets, smfq_items)