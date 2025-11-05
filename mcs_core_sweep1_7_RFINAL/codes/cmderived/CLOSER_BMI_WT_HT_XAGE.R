#XAGE_C 	:	Actual age (CLOSER)
#WT_C 		:	Harmonised weight (CLOSER)
#WTSELF_C 	:	Weight, measured or self-report (CLOSER)
#WTIMP_C 	:	Weight, imperial or metric (CLOSER)
#WTPRE_C 	:	Weight (precision) (CLOSER)
#HT_C 		:	Harmonised height (CLOSER)
#HTSELF_C 	:	Height, measured or self-report (CLOSER)
#HTIMP_C 	:	Height, imperial or metric (CLOSER)
#HTPRE_C 	:	Height (precision) (CLOSER)
#BMI_C 		:	Body mass index (kg/m2) (CLOSER)

#1, Extract variables from raw MCS data
closer_all <- read_dta(file.path(closer, "mcs_closer_wp1.dta"))

#3, Generate new variable in a longitudinal format
closer_all <- closer_all %>%
  mutate(CNUM = 1) %>%
  zap_labels(closer_all) %>%
  mutate(SWEEP = case_when(
    visitage == 1 ~ 1,
    visitage == 3 ~ 2,
    visitage == 5 ~ 3,
    visitage == 7 ~ 4,
    visitage == 11 ~ 5,
    .default = NA_real_)) %>%
  rename(
    MCSID = mcsid,
    XAGE_C = xage,
    WT_C = wt,
    WTSELF_C = wtself,
    WTIMP_C = wtimp,
    WTPRE_C = wtpre,
    HT_C = ht,
    HTSELF_C = htself,
    HTIMP_C = htimp,
    HTPRE_C = htpre,
    BMI_C = bmi
  )

attr(closer_all$XAGE_C, "label") <- "Actual age (CLOSER)"
attr(closer_all$WT_C, "label") <- "Harmonised weight (kilograms) (CLOSER)"
attr(closer_all$WTSELF_C, "label") <- "Weight, measured or self-report (CLOSER)"
attr(closer_all$WTIMP_C, "label") <- "Weight, imperial or metric (CLOSER)"
attr(closer_all$WTPRE_C, "label") <- "Weight (precision) (CLOSER)"
attr(closer_all$HT_C, "label") <- "Harmonised height (metres) (CLOSER)"
attr(closer_all$HTSELF_C, "label") <- "Height, measured or self-report (CLOSER)"
attr(closer_all$HTIMP_C, "label") <- "Height, imperial or metric (CLOSER)"
attr(closer_all$HTPRE_C, "label") <- "Height (precision) (CLOSER)"
attr(closer_all$BMI_C, "label") <- "Body mass index (kg/m2) (CLOSER)"

table(closer_all$XAGE_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$WT_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$WTSELF_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$WTIMP_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$WTPRE_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$HT_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$HTSELF_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$HTIMP_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$HTPRE_C, closer_all$SWEEP, useNA = "ifany")
table(closer_all$BMI_C, closer_all$SWEEP, useNA = "ifany")

#4, save temporal data 
closer_all <- closer_all %>% select(MCSID, CNUM, SWEEP, XAGE_C, WT_C, HT_C, BMI_C) %>%
  filter(!is.na(SWEEP))
closer_all <- closer_all %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5))) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                       labels = c("1st Cohort Member of the family",
                                  "2nd Cohort Member of the family",
                                  "3rd Cohort Member of the family")))
attr(closer_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(closer_all, file = file.path(temp_data_cdv, "CLOSER_BMI_WT_HT_XAGE.Rds"))

#5, save working memory
rm(closer_all)