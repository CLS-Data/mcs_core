# AREGN: Interview Government Office Region

#1, Extract variables from raw MCS data
aregn_mcs7 <- read_dta(file.path(mcs7, "mcs7_hhgrid.dta")) %>%
  mutate(SWEEP = 7) %>%
  filter(GPNUM00 != -1) %>%
  distinct(MCSID, GPNUM00, SWEEP, GAREGN00, keep.all = TRUE) %>%
  filter(GPNUM00 == 1) %>%
  select(MCSID, GPNUM00, SWEEP, GAREGN00)

aregn_all <- tibble()
for(i in 1:6){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  aregn_all <- bind_rows(aregn_all, temporary)}
aregn_all <- bind_rows(aregn_all, aregn_mcs7)

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
aregn_all <- aregn_all %>%
  mutate(AREGN = case_when(
    SWEEP == 1 ~ AAREGN00,
    SWEEP == 2 ~ BAREGN00,
    SWEEP == 3 ~ CAREGN00,
    SWEEP == 4 ~ DAREGN00,
    SWEEP == 5 ~ EAREGN00,
    SWEEP == 6 ~ FAREGN00,
    SWEEP == 7 ~ GAREGN00,
    .default = NA_real_))
aregn_all <- aregn_all %>%
  mutate(AREGN = labelled(
  AREGN,
  labels = c(
    "Refusal"                                 = -9,
    "Don't know"                              = -8,
    "Not Applicable"                          = -1,
    "North East"                              = 1,
    "North West"                              = 2,
    "Yorkshire and the Humber"                = 3,
    "East Midlands"                           = 4,
    "West Midlands"                           = 5,
    "East of England"                         = 6,
    "London"                                  = 7,
    "South East"                              = 8,
    "South West"                              = 9,
    "Wales"                                   = 10,
    "Scotland"                                = 11,
    "Northern Ireland"                        = 12,
    "Not app in IoM Ch Is"                    = 13
  )
))
attr(aregn_all$AREGN, "label") <- "Interview Government Office Region"
table(aregn_all$AREGN, aregn_all$SWEEP, useNA = "ifany")

#4, save temporal data 
aregn_all <- aregn_all %>% select(MCSID, SWEEP, AREGN)
aregn_all <- aregn_all %>%
  mutate(SWEEP = labelled(SWEEP, labels = c("MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5,
                                            "MCS6" = 6, "MCS7" = 7)))

attr(aregn_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(aregn_all, file = file.path(temp_data_fdv, "AREGN.Rds"))

#5, save working memory
rm(aregn_all, aregn_mcs7, temporary)