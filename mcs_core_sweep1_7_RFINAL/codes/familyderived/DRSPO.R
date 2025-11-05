# DRSPO: DV Parent Interview response summary

#1, Extract variables from raw MCS data
drspo_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  drspo_all <- bind_rows(drspo_all, temporary)}

#2, Change/recode/edit variables if needed
drspo_all <- drspo_all %>%
  zap_labels(ADRSPO00, BDRSPO00, CDRSPO00, DDRSPO00) %>%
  mutate(
    ADRSPO00 = case_when(
      ADRSPO00 == 5 ~ 6,
      TRUE ~ ADRSPO00),
    BDRSPO00 = case_when(
      BDRSPO00 == 5 ~ 6,
      BDRSPO00 == 6 ~ 9,
      BDRSPO00 == 7 ~ 8, 
      TRUE ~ BDRSPO00),
    CDRSPO00 = case_when(
      CDRSPO00 == 5 ~ 6,
      CDRSPO00 == 7 ~ 8, 
      TRUE ~ CDRSPO00),
    DDRSPO00 = case_when(
      DDRSPO00 == 5 ~ 6,
      DDRSPO00 == 7 ~ 8, 
      TRUE ~ DDRSPO00))

#3, Generate new variable in a longitudinal format
drspo_all <- drspo_all %>%
  mutate(DRSPO = case_when(
    SWEEP == 1 ~ ADRSPO00,
    SWEEP == 2 ~ BDRSPO00,
    SWEEP == 3 ~ CDRSPO00,
    SWEEP == 4 ~ DDRSPO00,
    SWEEP == 5 ~ ERSPO00,
    SWEEP == 6 ~ FDRSPO00,
    SWEEP == 7 ~ -1,
    .default = NA_real_))

drspo_all <- drspo_all %>%
  mutate(
    DRSPO = labelled(
      DRSPO,
      labels = c(
        "Refusal"                                               = -9,
        "Don't know"                                            = -8,
        "Not Applicable"                                        = -1,
        "Main resp in person, no eligible partner"              = 1,
        "Main and partner respondent in person"                 = 2,
        "Main in person, partner by proxy"                      = 3,
        "Main in person, partner elig but not interviewed"      = 4,
        "Main in person, partner elig by prox but not interviewed" = 5,
        "No main response, partner interviewed"                 = 6,
        "No main response, nobody eligible for partner"         = 7,
        "No parent interviews"                                  = 8,
        "No main interview, partner by proxy"                   = 9
      )
    )
  )
attr(drspo_all$DRSPO, "label") <- "DV Parent Interview response summary"
table(drspo_all$DRSPO, drspo_all$SWEEP, useNA = "ifany")

#4, save temporal data 
drspo_all <- drspo_all %>% select(MCSID, SWEEP, DRSPO)
drspo_all <- drspo_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(drspo_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(drspo_all, file = file.path(temp_data_fdv, "DRSPO.Rds"))

#5, save working memory
rm(drspo_all, temporary)