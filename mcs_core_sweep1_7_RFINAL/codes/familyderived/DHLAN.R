# DHLAN: DV Language Spoken in household

#1, Extract variables from raw MCS data
dhlan_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dhlan_all <- bind_rows(dhlan_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dhlan_all <- dhlan_all %>%
  zap_labels(dhlan_all) %>%
  mutate(DHLAN = case_when(
    SWEEP == 1 ~ ADHLAN00,
    SWEEP == 2 ~ BDHLAN00,
    SWEEP == 3 ~ CDHLAN00,
    SWEEP == 4 ~ DDHLAN00,
    SWEEP == 5 ~ EHLAN00,
    SWEEP == 6 ~ FDHLAN00,
    SWEEP == 7 ~ NA,
    .default = NA_real_))

dhlan_all <- dhlan_all %>%
  mutate(DHLAN = labelled(
    DHLAN,
    labels = c(
      "Refusal"                                     = -9,
      "Don't know"                                  = -8,
      "Not Applicable"                              = -1,
      "Yes - English only"                          = 1,
      "Yes - mostly English, sometimes other"       = 2,
      "Yes - about half English and half other"     = 3,
      "No - mostly other, sometimes English"        = 4,
      "No - other language(s) only"                 = 5
    )
  ))
attr(dhlan_all$DHLAN, "label") <- "DV Language Spoken in household"
table(dhlan_all$DHLAN, dhlan_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dhlan_all <- dhlan_all %>% select(MCSID, SWEEP, DHLAN)
dhlan_all <- dhlan_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dhlan_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dhlan_all, file = file.path(temp_data_fdv, "DHLAN.Rds"))

#5, save working memory
rm(dhlan_all, temporary)