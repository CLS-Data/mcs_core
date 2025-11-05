#GESTAGE: Gestational age (days)
#PRETERM: DV Pre term Gestational age (days < 259)

#1, Extract variables from raw MCS data
input_file <- file.path(mcs1, paste0("mcs1_cm_derived.dta"))
gestage_all <- read_dta(input_file) %>% rename(CNUM = ACNUM00) %>% select(MCSID, CNUM, ADGEST00)

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
gestage_all <- gestage_all %>%
  mutate(GESTAGE = ADGEST00) %>%
  zap_labels(gestage_all) %>%
  mutate(PRETERM = case_when(
    GESTAGE > 0 & GESTAGE < 259 ~ 1,
    GESTAGE >= 259 & GESTAGE < 400 ~ 2,
    GESTAGE == -8 ~ -8,
    .default = NA_real_)) 

gestage_all <- gestage_all %>%
  mutate(GESTAGE = labelled(
    GESTAGE,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1
    )
  ))  
attr(gestage_all$GESTAGE, "label") <- "Gestational age (days)"
table(gestage_all$GESTAGE, useNA = "ifany")

gestage_all <- gestage_all %>%
  mutate(PRETERM = labelled(
    PRETERM,
    labels = c(
      "Refusal"         = -9,
      "Don't know"      = -8,
      "Not Applicable"  = -1,
      "Yes"             = 1,
      "No"              = 2
    )
  ))
attr(gestage_all$PRETERM, "label") <- "DV Pre term Gestational age (days< 259)"
table(gestage_all$PRETERM, useNA = "ifany")

#4, save temporal data 
gestage_all <- gestage_all %>% select(MCSID, CNUM, GESTAGE, PRETERM) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
saveRDS(gestage_all, file = file.path(temp_data_cdv, "GESTAGE.Rds"))

#5, save working memory
rm(gestage_all)