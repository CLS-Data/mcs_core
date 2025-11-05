# ACTRY: ADMIN Country at interview (E,W,S,NI)

#1, Extract variables from raw MCS data
actry_mcs7 <- read_dta(file.path(mcs7, "mcs7_hhgrid.dta")) %>%
  mutate(SWEEP = 7) %>%
  filter(GPNUM00 != -1) %>%
  distinct(MCSID, GPNUM00, SWEEP, GACTRY00, keep.all = TRUE) %>%
  filter(GPNUM00 == 1) %>%
  select(MCSID, GPNUM00, SWEEP, GACTRY00)

actry_all <- tibble()
for(i in 1:6){
  folder <- get(paste0("mcs", i))  # Get the folder path for this sweep
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  actry_all <- bind_rows(actry_all, temporary)}
actry_all <- bind_rows(actry_all, actry_mcs7)

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
actry_all <- actry_all %>%
  mutate(ACTRY = case_when(
    SWEEP == 1 ~ AACTRY00,
    SWEEP == 2 ~ BACTRY00,
    SWEEP == 3 ~ CACTRY00,
    SWEEP == 4 ~ DACTRY00,
    SWEEP == 5 ~ EACTRY00,
    SWEEP == 6 ~ FACTRY00,
    SWEEP == 7 ~ GACTRY00,
    .default = NA_real_))

actry_all <- actry_all %>%
  mutate(
    ACTRY = labelled(
      ACTRY,
      labels = c(
        "Refusal"         = -9,
        "Don't know"      = -8,
        "Not Applicable"  = -1,
        "England"         = 1,
        "Wales"           = 2,
        "Scotland"        = 3,
        "Northern Ireland" = 4
      )
    )
  )
attr(actry_all$ACTRY, "label") <- "ADMIN Country at interview (E,W,S,NI)"
table(actry_all$ACTRY, actry_all$SWEEP, useNA = "ifany")

#4, save temporal data 
actry_all <- actry_all %>% select(MCSID, SWEEP, ACTRY)
actry_all <- actry_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))
attr(actry_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(actry_all, file = file.path(temp_data_fdv, "ACTRY.Rds"))

#5, save working memory
rm(actry_all, actry_mcs7, temporary)