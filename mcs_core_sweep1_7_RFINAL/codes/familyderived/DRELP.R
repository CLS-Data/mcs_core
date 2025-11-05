# DRELP: DV Relationship between Parents/Carers in Household

#1, Extract variables from raw MCS data
drelp_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  drelp_all <- bind_rows(drelp_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
drelp_all <- drelp_all %>%
  mutate(DRELP = case_when(
    SWEEP == 1 ~ ADRELP00,
    SWEEP == 2 ~ BDRELP00,
    SWEEP == 3 ~ CDRELP00,
    SWEEP == 4 ~ DDRELP00,
    SWEEP == 5 ~ ERELP00,
    SWEEP == 6 ~ FDRELP00,
    SWEEP == 7 ~ GDRELP00,
    .default = NA_real_)) %>%
  mutate(
    DRELP = case_when(
      DRELP == -2 ~ -8,
      TRUE ~ DRELP))

drelp_all <- drelp_all %>%
  mutate(
    DRELP = labelled(
      DRELP,
      labels = c(
        "Refusal"          = -9,
        "Don't know"       = -8,
        "Not Applicable"   = -1,
        "Married"          = 1,
        "Cohabiting"       = 2,
        "Neither"          = 3
      )
    )
  )
attr(drelp_all$DRELP, "label") <- "DV Relationship between Parents/Carers in Household"
table(drelp_all$DRELP, drelp_all$SWEEP, useNA = "ifany")

#4, save temporal data 
drelp_all <- drelp_all %>% select(MCSID, SWEEP, DRELP)
drelp_all <- drelp_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(drelp_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(drelp_all, file = file.path(temp_data_fdv, "DRELP.Rds"))

#5, save working memory
rm(drelp_all, temporary)