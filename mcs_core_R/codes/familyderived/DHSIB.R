# DHSIB: DV Half siblings of CM in household  

#1, Extract variables from raw MCS data
dhsib_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dhsib_all <- bind_rows(dhsib_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dhsib_all <- dhsib_all %>%
  zap_labels(dhsib_all) %>%
  mutate(DHSIB = case_when(
    SWEEP == 1 ~ ADHSIB00,
    SWEEP == 2 ~ BDHSIB00,
    SWEEP == 3 ~ CDHSIB00,
    SWEEP == 4 ~ DDHSIB00,
    SWEEP == 5 ~ EHSIB00,
    SWEEP == 6 ~ FDHSIB00,
    SWEEP == 7 ~ GDHSIB00,
    .default = NA_real_)) %>%
  mutate(
    DHSIB = case_when(
      DHSIB == -2 ~ -8,
      TRUE ~ DHSIB))

dhsib_all <- dhsib_all %>%
  mutate(DHSIB = labelled(
    DHSIB,
    labels = c(
      "Refusal"                 = -9,
      "Don't know"              = -8,
      "Not Applicable"          = -1,
      "At least 1 half sib in HH" = 1,
      "No half sibs in HH"        = 2
    )
  ))
attr(dhsib_all$DHSIB, "label") <- "DV Half siblings of CM in household"
table(dhsib_all$DHSIB, dhsib_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dhsib_all <- dhsib_all %>% select(MCSID, SWEEP, DHSIB)
dhsib_all <- dhsib_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dhsib_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dhsib_all, file = file.path(temp_data_fdv, "DHSIB.Rds"))

#5, save working memory
rm(dhsib_all, temporary)