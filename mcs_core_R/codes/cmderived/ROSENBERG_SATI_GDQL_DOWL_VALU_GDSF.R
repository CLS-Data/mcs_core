# Rosenberg Self-esteem 
#ROSENBERG	:	DV Rosenberg Self-esteem Score (0-15)
#SATI	:	RosenbergGrid: On the whole, I am satisfied with myself
#GDQL	:	RosenbergGrid: I feel I have a number of good qualities
#DOWL	:	RosenbergGrid: I am able to do things as well as most other people
#VALU	:	RosenbergGrid: I am a person of value
#GDSF	:	RosenbergGrid: I feel good about myself

#1, Extract variables from raw MCS data
rosenberg_mcs5 <- read_dta(file.path(mcs5, "mcs5_cm_interview.dta")) %>%
  mutate(SWEEP = 5) %>%
  mutate(CNUM = ECNUM00) %>%
  mutate(ECQ11A00 = case_when(
    ECQ11A00 == -8 ~ -9,
    TRUE ~ ECQ11A00)) %>%
  mutate(ECQ11B00 = case_when(
    ECQ11B00 == -8 ~ -9,
    TRUE ~ ECQ11B00)) %>%
  mutate(ECQ11C00 = case_when(
    ECQ11C00 == -8 ~ -9,
    TRUE ~ ECQ11C00)) %>%
  mutate(ECQ11D00 = case_when(
    ECQ11D00 == -8 ~ -9,
    TRUE ~ ECQ11D00)) %>%
  mutate(ECQ11E00 = case_when(
    ECQ11E00 == -8 ~ -9,
    TRUE ~ ECQ11E00)) %>%
  select(MCSID, SWEEP, CNUM, ECQ11A00, ECQ11B00, ECQ11C00, ECQ11D00, ECQ11E00)

rosenberg_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_interview.dta")) %>%
  mutate(SWEEP = 6) %>%
  mutate(CNUM = FCNUM00) %>%
  select(MCSID, SWEEP, CNUM, FCSATI00, FCGDQL00, FCDOWL00, FCVALU00, FCGDSF00)

rosenberg_mcs7 <- read_dta(file.path(mcs7, "mcs7_cm_interview.dta")) %>%
  mutate(SWEEP = 7) %>%
  mutate(CNUM = GCNUM00) %>%
  mutate(GCSATI00 = case_when(
    GCSATI00 == 5 ~ -8,
    GCSATI00 == 6 ~ -9,
    GCSATI00 == 7 ~ -9,
    TRUE ~ GCSATI00)) %>%
  mutate(GCGDQL00 = case_when(
    GCGDQL00 == 5 ~ -8,
    GCGDQL00 == 6 ~ -9,
    GCGDQL00 == 7 ~ -9,
    TRUE ~ GCGDQL00)) %>%
  mutate(GCDOWL00 = case_when(
    GCDOWL00 == 5 ~ -8,
    GCDOWL00 == 6 ~ -9,
    GCDOWL00 == 7 ~ -9,
    TRUE ~ GCDOWL00)) %>%
  mutate(GCVALU00 = case_when(
    GCVALU00 == 5 ~ -8,
    GCVALU00 == 6 ~ -9,
    GCVALU00 == 7 ~ -9,
    TRUE ~ GCVALU00)) %>%
  mutate(GCGDSF00 = case_when(
    GCGDSF00 == 5 ~ -8,
    GCGDSF00 == 6 ~ -9,
    GCGDSF00 == 7 ~ -9,
    TRUE ~ GCGDSF00)) %>%
  select(MCSID, SWEEP, CNUM, GCSATI00, GCGDQL00, GCDOWL00, GCVALU00, GCGDSF00)

datasets <- list(rosenberg_mcs5, rosenberg_mcs6, rosenberg_mcs7)
rosenberg_all <- bind_rows(datasets)
table(rosenberg_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
rosenberg_all <- rosenberg_all %>%
  zap_labels(rosenberg_all) %>%
  mutate(SATI = case_when(
    SWEEP == 5 ~ ECQ11A00,
    SWEEP == 6 ~ FCSATI00,
    SWEEP == 7 ~ GCSATI00,
    .default = NA_real_)) %>%
  mutate(GDQL = case_when(
    SWEEP == 5 ~ ECQ11B00,
    SWEEP == 6 ~ FCGDQL00,
    SWEEP == 7 ~ GCGDQL00,
    .default = NA_real_)) %>%
  mutate(DOWL = case_when(
    SWEEP == 5 ~ ECQ11C00,
    SWEEP == 6 ~ FCDOWL00,
    SWEEP == 7 ~ GCDOWL00,
    .default = NA_real_)) %>%
  mutate(VALU = case_when(
    SWEEP == 5 ~ ECQ11D00,
    SWEEP == 6 ~ FCVALU00,
    SWEEP == 7 ~ GCVALU00,
    .default = NA_real_)) %>%
  mutate(GDSF = case_when(
    SWEEP == 5 ~ ECQ11E00,
    SWEEP == 6 ~ FCGDSF00,
    SWEEP == 7 ~ GCGDSF00,
    .default = NA_real_)) %>%
  mutate(SATI_AUX = SATI) %>%
  mutate(SATI_AUX = case_when(
    SATI_AUX == -9 ~ NA,
    SATI_AUX == -8 ~ NA,
    SATI_AUX == -1 ~ NA,
    SATI_AUX == 1 ~ 3,
    SATI_AUX == 2 ~ 2,
    SATI_AUX == 3 ~ 1,
    SATI_AUX == 4 ~ 0,
    TRUE ~ SATI_AUX)) %>%
  mutate(GDQL_AUX = GDQL) %>%
  mutate(GDQL_AUX = case_when(
    GDQL_AUX == -9 ~ NA,
    GDQL_AUX == -8 ~ NA,
    GDQL_AUX == -1 ~ NA,
    GDQL_AUX == 1 ~ 3,
    GDQL_AUX == 2 ~ 2,
    GDQL_AUX == 3 ~ 1,
    GDQL_AUX == 4 ~ 0,
    TRUE ~ GDQL_AUX)) %>%
  mutate(DOWL_AUX = DOWL) %>%
  mutate(DOWL_AUX = case_when(
    DOWL_AUX == -9 ~ NA,
    DOWL_AUX == -8 ~ NA,
    DOWL_AUX == -1 ~ NA,
    DOWL_AUX == 1 ~ 3,
    DOWL_AUX == 2 ~ 2,
    DOWL_AUX == 3 ~ 1,
    DOWL_AUX == 4 ~ 0,
    TRUE ~ DOWL_AUX)) %>%
  mutate(VALU_AUX = VALU) %>%
  mutate(VALU_AUX = case_when(
    VALU_AUX == -9 ~ NA,
    VALU_AUX == -8 ~ NA,
    VALU_AUX == -1 ~ NA,
    VALU_AUX == 1 ~ 3,
    VALU_AUX == 2 ~ 2,
    VALU_AUX == 3 ~ 1,
    VALU_AUX == 4 ~ 0,
    TRUE ~ VALU_AUX)) %>%
  mutate(GDSF_AUX = GDSF) %>%
  mutate(GDSF_AUX = case_when(
    GDSF_AUX == -9 ~ NA,
    GDSF_AUX == -8 ~ NA,
    GDSF_AUX == -1 ~ NA,
    GDSF_AUX == 1 ~ 3,
    GDSF_AUX == 2 ~ 2,
    GDSF_AUX == 3 ~ 1,
    GDSF_AUX == 4 ~ 0,
    TRUE ~ GDSF_AUX)) %>%
  mutate(DROSENBERG = NA_real_) %>%
  mutate(DROSENBERG = SATI_AUX + GDQL_AUX + DOWL_AUX + VALU_AUX + GDSF_AUX) 
vars_to_label <- c("SATI", "GDQL", "DOWL", "VALU", "GDSF")

for (var in vars_to_label) {
  
  # Combine all levels and labels
  all_levels <- c(-8, -1, 1, 2, 3, 4)
  all_labels <- c("Don't know", "Not Applicable", "Strongly agree", "Agree", "Disagree", "Strongly disagree")
  
  # Use := with !!sym() to programmatically assign to variable name
  rosenberg_all <- rosenberg_all %>%
    mutate(!!sym(var) := labelled(.data[[var]], labels = setNames( all_levels, all_labels)))
}

#val_labels(rosenberg_all$SATI)
attr(rosenberg_all$SATI, "label") <- "RosenbergGrid: On the whole, I am satisfied with myself"
attr(rosenberg_all$GDQL, "label") <- "RosenbergGrid: I feel I have a number of good qualities"
attr(rosenberg_all$DOWL, "label") <- "RosenbergGrid: I am able to do things as well as most other people"
attr(rosenberg_all$VALU, "label") <- "RosenbergGrid: I am a person of value"
attr(rosenberg_all$GDSF, "label") <- "RosenbergGrid: I feel good about myself"
attr(rosenberg_all$DROSENBERG, "label") <- "DV Rosenberg Self-esteem Score (0-15)"

table(rosenberg_all$SATI, rosenberg_all$SWEEP, useNA = "ifany")
table(rosenberg_all$GDQL, rosenberg_all$SWEEP, useNA = "ifany")
table(rosenberg_all$DOWL, rosenberg_all$SWEEP, useNA = "ifany")
table(rosenberg_all$VALU, rosenberg_all$SWEEP, useNA = "ifany")
table(rosenberg_all$GDSF, rosenberg_all$SWEEP, useNA = "ifany")
table(rosenberg_all$DROSENBERG, rosenberg_all$SWEEP, useNA = "ifany")

#4, save temporal data 
rosenberg_all <- rosenberg_all %>% select(SWEEP, MCSID, CNUM, DROSENBERG, SATI, GDQL, DOWL, VALU, GDSF)
rosenberg_all <- rosenberg_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c("MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

rosenberg_all <- rosenberg_all %>%  
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(rosenberg_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(rosenberg_all, file = file.path(temp_data_cdv, "ROSENBERG_SATI_GDQL_DOWL_VALU_GDSF.Rds"))

#5, save working memory
rm(rosenberg_all, rosenberg_mcs5, rosenberg_mcs6, rosenberg_mcs7, datasets)