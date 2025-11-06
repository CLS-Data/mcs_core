# DFSIB: DV Foster siblings of CM in household 

#1, Extract variables from raw MCS data
dfsib_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dfsib_all <- bind_rows(dfsib_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dfsib_all <- dfsib_all %>%
  zap_labels(dfsib_all) %>%
  mutate(DFSIB = case_when(
    SWEEP == 1 ~ ADFSIB00,
    SWEEP == 2 ~ BDFSIB00,
    SWEEP == 3 ~ CDFSIB00,
    SWEEP == 4 ~ DDFSIB00,
    SWEEP == 5 ~ EFSIB00,
    SWEEP == 6 ~ FDFSIB00,
    SWEEP == 7 ~ GDFSIB00,
    .default = NA_real_)) %>%
  mutate(
    DFSIB = case_when(
      DFSIB == -2 ~ -8,
      TRUE ~ DFSIB))

dfsib_all <- dfsib_all %>%
  mutate(DFSIB = labelled(
    DFSIB,
    labels = c(
      "Refusal"                    = -9,
      "Don't know"                 = -8,
      "Not Applicable"            = -1,
      "At least 1 foster sib in HH" = 1,
      "No foster sibs in HH"       = 2
    )
  ))
attr(dfsib_all$DFSIB, "label") <- "DV Foster siblings of CM in household"
table(dfsib_all$DFSIB, dfsib_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dfsib_all <- dfsib_all %>% select(MCSID, SWEEP, DFSIB)
dfsib_all <- dfsib_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dfsib_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dfsib_all, file = file.path(temp_data_fdv, "DFSIB.Rds"))

#5, save working memory
rm(dfsib_all, temporary)