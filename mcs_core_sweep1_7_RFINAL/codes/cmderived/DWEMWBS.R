#YP Warwick-Edinburgh Mental Wellbeing Scale (WEMWBS) 
# DWEMWBS:	DV WEMWBS: Sum of raw mental welbeing scores transformed to metric scale

#1, Extract variables from raw MCS data
dwemwbs_all <- read_dta(file.path(mcs7, "mcs7_cm_derived.dta")) %>%
  mutate(SWEEP = 7) %>%
  rename(CNUM = GCNUM00) %>%
  rename(DWEMWBS = GDWEMWBS) %>%
  select(MCSID, CNUM, SWEEP, DWEMWBS)

table(dwemwbs_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dwemwbs_all <- dwemwbs_all %>%
  mutate(DWEMWBS = labelled(
    DWEMWBS,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1
    )
  ))  
attr(dwemwbs_all$DWEMWBS, "label") <- "DV WEMWBS: Sum of raw mental welbeing scores transformed to metric scale"
table(dwemwbs_all$DWEMWBS, useNA = "ifany")

#4, save temporal data 
dwemwbs_all$SWEEP <- 7
dwemwbs_all <- dwemwbs_all %>%
  mutate(SWEEP = labelled(SWEEP,labels = c("MCS7"= 7 ))) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(dwemwbs_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dwemwbs_all, file = file.path(temp_data_cdv, "DWEMWBS.Rds"))

#5, save working memory
rm(dwemwbs_all)