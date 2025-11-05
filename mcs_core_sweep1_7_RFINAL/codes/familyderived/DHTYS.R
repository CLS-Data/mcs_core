# DHTYS DV Summary of Parents/Carers in Household

#1, Extract variables from raw MCS data
dhtys_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dhtys_all <- bind_rows(dhtys_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dhtys_all <- dhtys_all %>%
  zap_labels(dhtys_all$GDHTYP00) %>%
  mutate(
    DHTYS = case_when(
    SWEEP == 1 ~ ADHTYS00,
    SWEEP == 2 ~ BDHTYS00,
    SWEEP == 3 ~ CDHTYS00,
    SWEEP == 4 ~ DDHTYS00,
    SWEEP == 5 ~ EHTYS00,
    SWEEP == 6 ~ FDHTYS00,
    SWEEP == 7 ~ GDHTYS00,
    .default = NA_real_))

dhtys_all <- dhtys_all %>%
  mutate(
    DHTYS = labelled(
      DHTYS,
      labels = c(
        "Refusal"             = -9,
        "Don't know"          = -8,
        "Not Applicable"      = -1,
        "Two parents/carers"  = 1,
        "One parent/carer"    = 2
      )
    )
  )
attr(dhtys_all$DHTYS, "label") <- "DV Summary of Parents/Carers in Household"
table(dhtys_all$DHTYS, dhtys_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dhtys_all <- dhtys_all %>% select(MCSID, SWEEP, DHTYS)
dhtys_all <- dhtys_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dhtys_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dhtys_all, file = file.path(temp_data_fdv, "DHTYS.Rds"))

#5, save working memory
rm(dhtys_all, temporary)