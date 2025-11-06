# DNSIB: Natural siblings of CM in household

#1, Extract variables from raw MCS data
dnsib_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dnsib_all <- bind_rows(dnsib_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dnsib_all <- dnsib_all %>%
  zap_labels(dnsib_all) %>%
  mutate(DNSIB = case_when(
    SWEEP == 1 ~ ADNSIB00,
    SWEEP == 2 ~ BDNSIB00,
    SWEEP == 3 ~ CDNSIB00,
    SWEEP == 4 ~ DDNSIB00,
    SWEEP == 5 ~ ENSIB00,
    SWEEP == 6 ~ FDNSIB00,
    SWEEP == 7 ~ GDNSIB00,
    .default = NA_real_)) %>%
  mutate(
    DNSIB = case_when(
      DNSIB == -2 ~ -8,
      TRUE ~ DNSIB))

dnsib_all <- dnsib_all %>%
  mutate(DNSIB = labelled(
    DNSIB,
    labels = c(
      "Refusal"                    = -9,
      "Don't know"                 = -8,
      "Not Applicable"             = -1,
      "At least 1 natural sib in HH" = 1,
      "No natural sibs in HH"        = 2
    )
  ))
attr(dnsib_all$DNSIB, "label") <- "DV Natural siblings of CM in household"
table(dnsib_all$DNSIB, dnsib_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dnsib_all <- dnsib_all %>% select(MCSID, SWEEP, DNSIB)
dnsib_all <- dnsib_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dnsib_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dnsib_all, file = file.path(temp_data_fdv, "DNSIB.Rds"))

#5, save working memory
rm(dnsib_all, temporary)