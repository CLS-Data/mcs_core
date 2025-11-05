# Crime
#WEAPON: Carried a weapon in the last 12 months
#POLSTO: Ever stopped by the police
#POLARE: Ever cautioned or arrested by the police
#VICPHY: Physically assaulted in the last 12 months
#VICWEA: Assaulted with a weapon in the last 12 months
#VICSEX: Victim of sexual assault in the last 12 months

#1, Extract variables from raw MCS data
crime_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  mutate(SWEEP = 6) %>%
  rename(CNUM = FCNUM00) %>%
  select(MCSID, CNUM, SWEEP, FCKNIF00, FCPOLS00, FCCAUT00, FCARES00, FCVICA00, FCVICC00, FCVICF0A)

crime_mcs7 <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  mutate(SWEEP = 7) %>%
  rename(CNUM = GCNUM00) %>%
  select(MCSID, CNUM, SWEEP, GCKNIF00, GCPOLS00, GCCAUT00, GCARES00, GCVICA00, GCVICC00, GCVICS00)

datasets <- list(crime_mcs6, crime_mcs7)
crime_all <- bind_rows(datasets)
table(crime_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
crime_all <- crime_all %>%
  zap_labels(crime_all) %>%
  mutate(FPOLCAUARR = case_when(
    FCCAUT00 %in% c(-9, -8, -1) & FCARES00 %in% c(-9, -8, -1) ~ -1,
    FCCAUT00 == 1 | FCARES00 == 1 ~ 1,
    TRUE ~ 0)) %>%
  mutate(GPOLCAUARR = case_when(
    GCCAUT00 %in% c(3, 4, 5) & GCARES00 %in% c(3, 4, 5) ~ -1,
    GCCAUT00 == 1 | GCARES00 == 1 ~ 1,
    TRUE ~ 0))

crime_all <- crime_all %>% 
  mutate(GCKNIF00 = case_when(
    GCKNIF00 == 3 ~ -8,
    GCKNIF00 == 4 ~ -9,
    GCKNIF00 == 5 ~ -1,
    TRUE ~ GCKNIF00)) %>%
  mutate(GCPOLS00 = case_when(
    GCPOLS00 == 3 ~ -8,
    GCPOLS00 == 4 ~ -9,
    GCPOLS00 == 5 ~ -1,
    TRUE ~ GCPOLS00)) %>%
  mutate(GCVICA00 = case_when(
    GCVICA00 == 3 ~ -8,
    GCVICA00 == 4 ~ -9,
    GCVICA00 == 5 ~ -1,
    TRUE ~ GCVICA00)) %>%
  mutate(GCVICC00 = case_when(
    GCVICC00 == 3 ~ -8,
    GCVICC00 == 4 ~ -9,
    GCVICC00 == 5 ~ -1,
    TRUE ~ GCVICC00)) %>%
  mutate(GCVICS00 = case_when(
    GCVICS00 == 3 ~ -8,
    GCVICS00 == 4 ~ -9,
    GCVICS00 == 5 ~ -1,
    TRUE ~ GCVICS00))

#3, Generate new variable in a longitudinal format
crime_all <- crime_all %>%
  mutate(WEAPON = case_when(
    SWEEP == 6 ~ FCKNIF00,
    SWEEP == 7 ~ GCKNIF00,
    .default = NA_real_)) %>%
  mutate(WEAPON = case_when(
    WEAPON == 2 ~ 0,
    TRUE ~ WEAPON)) %>%
  mutate(POLSTO = case_when(
    SWEEP == 6 ~ FCPOLS00,
    SWEEP == 7 ~ GCPOLS00,
    .default = NA_real_)) %>%
  mutate(POLSTO = case_when(
    POLSTO == 2 ~ 0,
    TRUE ~ POLSTO)) %>%
  mutate(POLARE = case_when(
    SWEEP == 6 ~ FPOLCAUARR,
    SWEEP == 7 ~ GPOLCAUARR,
    .default = NA_real_)) %>%
  mutate(VICPHY = case_when(
    SWEEP == 6 ~ FCVICA00,
    SWEEP == 7 ~ GCVICA00,
    .default = NA_real_)) %>%
  mutate(VICPHY = case_when(
    VICPHY == 2 ~ 0,
    TRUE ~ VICPHY)) %>%
  mutate(VICWEA = case_when(
    SWEEP == 6 ~ FCVICC00,
    SWEEP == 7 ~ GCVICC00,
    .default = NA_real_)) %>%
  mutate(VICWEA = case_when(
    VICWEA == 2 ~ 0,
    TRUE ~ VICWEA)) %>%
  mutate(VICSEX = case_when(
    SWEEP == 6 ~ FCVICF0A,
    SWEEP == 7 ~ GCVICS00,
    .default = NA_real_)) %>%
  mutate(VICSEX = case_when(
    VICSEX == 2 ~ 0,
    TRUE ~ VICSEX))

crime_all <- crime_all %>%
  mutate(WEAPON = labelled(WEAPON,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable/No answer" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(POLSTO = labelled(POLSTO,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable/No answer" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(POLARE = labelled(POLARE,
                           labels = c("No answer" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(VICPHY = labelled(VICPHY,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable/No answer" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(VICWEA = labelled(VICWEA,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable/No answer" = -1, 
                                      "No" = 0, "Yes" = 1))) %>%
  mutate(VICSEX = labelled(VICSEX,
                           labels = c("Don't want to answer" = -9, "Don't know" = -8, "Not Applicable/No answer" = -1, 
                                      "No" = 0, "Yes" = 1)))

attr(crime_all$WEAPON, "label") <- "Ever carried a knife or a weapon"
attr(crime_all$POLSTO, "label") <- "Ever stopped or questioned by police"
attr(crime_all$POLARE, "label") <- "Ever cautioned, received warning or arrested by police"
attr(crime_all$VICPHY, "label") <- "Physically assaulted in the last 12 months"
attr(crime_all$VICWEA, "label") <- "Assaulted with a weapon in the last 12 months"
attr(crime_all$VICSEX, "label") <- "Sexually assaulted in the last 12 months"

table(crime_all$WEAPON, crime_all$SWEEP, useNA = "ifany")
table(crime_all$POLSTO, crime_all$SWEEP, useNA = "ifany")
table(crime_all$POLARE, crime_all$SWEEP, useNA = "ifany")
table(crime_all$VICPHY, crime_all$SWEEP, useNA = "ifany")
table(crime_all$VICWEA, crime_all$SWEEP, useNA = "ifany")
table(crime_all$VICSEX, crime_all$SWEEP, useNA = "ifany")

#4, save temporal data 
crime_all <- crime_all %>% select(SWEEP, MCSID, CNUM, WEAPON, POLSTO, POLARE, VICPHY, VICWEA, VICSEX)
crime_all <- crime_all  %>%
  mutate(SWEEP = labelled(SWEEP, labels = c("MCS6" = 6, "MCS7" = 7)))

crime_all <- crime_all %>%  
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(crime_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(crime_all, file = file.path(temp_data_cdv, "CRIME.Rds"))

#5, save working memory
rm(crime_all, crime_mcs6, crime_mcs7, datasets)