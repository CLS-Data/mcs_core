# DROOW: DV Housing Tenure 

#1, Extract variables from raw MCS data
droow_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  droow_all <- bind_rows(droow_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
droow_all <- droow_all %>%
  zap_labels(droow_all) %>%
  mutate(DROOW = case_when(
    SWEEP == 1 ~ ADROOW00,
    SWEEP == 2 ~ BDROOW00,
    SWEEP == 3 ~ CDROOW00,
    SWEEP == 4 ~ DDROOW00,
    SWEEP == 5 ~ EROOW00,
    SWEEP == 6 ~ FDROOW00,
    SWEEP == 7 ~ NA,
    .default = NA_real_))

droow_all <- droow_all %>%
  mutate(DROOW = labelled(
    DROOW,
    labels = c(
      "Refusal"                                      = -9,
      "Don't know"                                   = -8,
      "Not Applicable"                               = -1,
      "Own outright"                                 = 1,
      "Own - mortgage/loan"                          = 2,
      "Part rent/part mortgage (shared equity)"      = 3,
      "Rent from local authority"                    = 4,
      "Rent from Housing Association"                = 5,
      "Rent privately"                               = 6,
      "Living with parents"                          = 7,
      "Live rent free"                               = 8,
      "Squatting"                                    = 9,
      "Other"                                        = 10
    )
  ))
attr(droow_all$DROOW, "label") <- "DV Housing Tenure"
table(droow_all$DROOW, droow_all$SWEEP, useNA = "ifany")

#4, save temporal data 
droow_all <- droow_all %>% select(MCSID, SWEEP, DROOW)
droow_all <- droow_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(droow_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(droow_all, file = file.path(temp_data_fdv, "DROOW.Rds"))

#5, save working memory
rm(droow_all, temporary)