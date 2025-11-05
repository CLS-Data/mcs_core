# DASIB: DV Adoptive siblings of CM in HH 

#1, Extract variables from raw MCS data
dasib_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dasib_all <- bind_rows(dasib_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dasib_all <- dasib_all %>%
  zap_labels(dasib_all) %>%
  mutate(DASIB = case_when(
    SWEEP == 1 ~ ADASIB00,
    SWEEP == 2 ~ BDASIB00,
    SWEEP == 3 ~ CDASIB00,
    SWEEP == 4 ~ DDASIB00,
    SWEEP == 5 ~ EASIB00,
    SWEEP == 6 ~ FDASIB00,
    SWEEP == 7 ~ GDASIB00,
    .default = NA_real_)) %>%
  mutate(
    DASIB = case_when(
      DASIB == -2 ~ -8,
      TRUE ~ DASIB))

dasib_all <- dasib_all %>%
  mutate(DASIB = labelled(
    DASIB,
    labels = c(
      "Refusal"                         = -9,
      "Don't know"                      = -8,
      "Not Applicable"                  = -1,
      "At least 1 adoptive sib in HH"   = 1,
      "No adoptive sibs in HH"          = 2
    )
  ))
attr(dasib_all$DASIB, "label") <- "DV Adoptive siblings of CM in HH"
table(dasib_all$DASIB, dasib_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dasib_all <- dasib_all %>% select(MCSID, SWEEP, DASIB)
dasib_all <- dasib_all %>%
  mutate(SWEEP = labelled(SWEEP, labels = c("MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5,
                                            "MCS6" = 6, "MCS7" = 7)))
attr(dasib_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dasib_all, file = file.path(temp_data_fdv, "DASIB.Rds"))

#5, save working memory
rm(dasib_all, temporary)