# DSSIB: Step siblings of CM in household 

#1, Extract variables from raw MCS data
dssib_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dssib_all <- bind_rows(dssib_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dssib_all <- dssib_all %>%
  zap_labels(dssib_all) %>%
  mutate(DSSIB = case_when(
    SWEEP == 1 ~ ADSSIB00,
    SWEEP == 2 ~ BDSSIB00,
    SWEEP == 3 ~ CDSSIB00,
    SWEEP == 4 ~ DDSSIB00,
    SWEEP == 5 ~ ESSIB00,
    SWEEP == 6 ~ FDSSIB00,
    SWEEP == 7 ~ GDSSIB00,
    .default = NA_real_)) %>%
  mutate(
    DSSIB = case_when(
      DSSIB == -2 ~ -8,
      TRUE ~ DSSIB))

dssib_all <- dssib_all %>%
  mutate(DSSIB = labelled(
    DSSIB,
    labels = c(
      "Refusal"                  = -9,
      "Don't know"               = -8,
      "Not Applicable"           = -1,
      "At least 1 step sib in HH" = 1,
      "No step sib in HH"         = 2
    )
  ))
attr(dssib_all$DSSIB, "label") <- "DV Step siblings of CM in household"
table(dssib_all$DSSIB, dssib_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dssib_all <- dssib_all %>% select(MCSID, SWEEP, DSSIB)
dssib_all <- dssib_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dssib_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dssib_all, file = file.path(temp_data_fdv, "DSSIB.Rds"))

#5, save working memory
rm(dssib_all, temporary)