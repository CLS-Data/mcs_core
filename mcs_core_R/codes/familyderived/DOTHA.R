# DOTHA: DV Other adult in HH

#1, Extract variables from raw MCS data
dotha_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dotha_all <- bind_rows(dotha_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dotha_all <- dotha_all %>%
  zap_labels(dotha_all) %>%
  mutate(DOTHA = case_when(
    SWEEP == 1 ~ ADOTHA00,
    SWEEP == 2 ~ BDOTHA00,
    SWEEP == 3 ~ CDOTHA00,
    SWEEP == 4 ~ DDOTHA00,
    SWEEP == 5 ~ EOTHA00,
    SWEEP == 6 ~ FDOTHA00,
    SWEEP == 7 ~ GDOTHA00,
    .default = NA_real_)) %>%
  mutate(
    DOTHA = case_when(
      DOTHA == -2 ~ -8,
      TRUE ~ DOTHA))

dotha_all <- dotha_all %>%
  mutate(DOTHA = labelled(
    DOTHA,
    labels = c(
      "Refusal" = -9,
      "Don't know" = -8,
      "Not Applicable" = -1,
      "At least 1 other adult in HH" = 1,
      "No other adults in HH" = 2
    )
  ))
attr(dotha_all$DOTHA, "label") <- "DV Other adult in HH"
table(dotha_all$DOTHA, dotha_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dotha_all <- dotha_all %>% select(MCSID, SWEEP, DOTHA)
dotha_all <- dotha_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dotha_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dotha_all, file = file.path(temp_data_fdv, "DOTHA.Rds"))

#5, save working memory
rm(dotha_all, temporary)