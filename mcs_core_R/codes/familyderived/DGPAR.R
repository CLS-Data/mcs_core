# DGPAR: DV Grandparents of CM in HH

#1, Extract variables from raw MCS data
dgpar_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dgpar_all <- bind_rows(dgpar_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dgpar_all <- dgpar_all %>%
  zap_labels(dgpar_all) %>%
  mutate(DGPAR = case_when(
    SWEEP == 1 ~ ADGPAR00,
    SWEEP == 2 ~ BDGPAR00,
    SWEEP == 3 ~ CDGPAR00,
    SWEEP == 4 ~ DDGPAR00,
    SWEEP == 5 ~ EGPAR00,
    SWEEP == 6 ~ FDGPAR00,
    SWEEP == 7 ~ GDGPAR00,
    .default = NA_real_)) %>%
  mutate(
    DGPAR = case_when(
      DGPAR == -2 ~ -8,
      TRUE ~ DGPAR))

dgpar_all <- dgpar_all %>%
  mutate(DGPAR = labelled(
    DGPAR,
    labels = c(
      "Refusal"                    = -9,
      "Don't know"                 = -8,
      "Not Applicable"            = -1,
      "At least 1 grandparent in HH" = 1,
      "No grandparents in HH"       = 2
    )
  ))
attr(dgpar_all$DGPAR, "label") <- "DV Grandparents of CM in HH"
table(dgpar_all$DGPAR, dgpar_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dgpar_all <- dgpar_all %>% select(MCSID, SWEEP, DGPAR)
dgpar_all <- dgpar_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))


attr(dgpar_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dgpar_all, file = file.path(temp_data_fdv, "DGPAR.Rds"))

#5, save working memory
rm(dgpar_all, temporary)