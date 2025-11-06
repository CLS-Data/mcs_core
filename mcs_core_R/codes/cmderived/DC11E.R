# DC11E: DV Cohort Member Ethnic Group - 11 category Census class

#1, Extract variables from raw MCS data
dc11e_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_cm_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i) %>% rename_with(~ substr(., 2, nchar(.)), ends_with("CNUM00"))
  dc11e_all <- bind_rows(dc11e_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dc11e_all <- dc11e_all %>%
  zap_labels(dc11e_all) %>%
  mutate(DC11E = case_when(
    SWEEP == 1 ~ ADC11E00,
    SWEEP == 2 ~ BDC11E00,
    SWEEP == 3 ~ CDC11E00,
    SWEEP == 4 ~ DDC11E00,
    SWEEP == 5 ~ NA,
    SWEEP == 6 ~ NA,
    SWEEP == 7 ~ NA,
    .default = NA_real_)) 

dc11e_all <- dc11e_all %>%
  mutate(DC11E = labelled(
    DC11E,
    labels = c(
      "Refusal"               = -9,
      "Don't know"            = -8,
      "Not Applicable"        = -1,
      "White"                 = 1,
      "Mixed"                 = 2,
      "Indian"                = 3,
      "Pakistani"             = 4,
      "Bangladeshi"           = 5,
      "Other Asian"           = 6,
      "Black Caribbean"       = 7,
      "Black African"         = 8,
      "Other Black"           = 9,
      "Chinese"               = 10,
      "Other Ethnic Group"    = 11
    )
  ))
attr(dc11e_all$DC11E, "label") <- "DV Cohort Member Ethnic Group - 11 category Census class"
table(dc11e_all$DC11E, dc11e_all$SWEEP, useNA = "ifany")

dc11e_all <- dc11e_all %>% select(MCSID, CNUM00, SWEEP, DC11E) %>%
  rename(CNUM = CNUM00) %>%
  pivot_wider(names_from = SWEEP,
              values_from = DC11E,
              names_prefix = "DC11E_") %>%
  mutate(
  DC11E = DC11E_1,
  DC11E = case_when(
    DC11E %in% c(-9, -8, -1, NA) ~ DC11E_2,
    TRUE ~ DC11E),
  DC11E = case_when(
    DC11E %in% c(-9, -8, -1, NA) ~ DC11E_3,
    TRUE ~ DC11E),
  DC11E = case_when(
    DC11E %in% c(-9, -8, -1, NA) ~ DC11E_4,
    TRUE ~ DC11E))
attr(dc11e_all$DC11E, "label") <- "DV Cohort Member Ethnic Group - 11 category Census class (first recorded)" 
table(dc11e_all$DC11E, useNA = "ifany")

#4, save temporal data 
dc11e_all <- dc11e_all %>% select(MCSID, CNUM, DC11E) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
saveRDS(dc11e_all, file = file.path(temp_data_cdv, "DC11E.Rds"))

#5, save working memory
rm(dc11e_all, temporary)