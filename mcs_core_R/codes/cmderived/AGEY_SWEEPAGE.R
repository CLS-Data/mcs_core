# AGEY:	Age at Interview (years)
# SWEEPAGE:	Age at MCS Sweep (years)

#1, Extract variables from raw MCS data
agey_mcs1 <- read_dta(file.path(mcs1, "mcs1_hhgrid.dta")) %>%
  filter(!is.na(ACNUM00), ACNUM00 != 0) %>%
  rename(CNUM = ACNUM00) %>%
  mutate(SWEEP = 1) %>%
  select(MCSID, CNUM, SWEEP, AHCSEX00, AHCAGE00)

agey_mcs1 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

agey_mcs2 <- read_dta(file.path(mcs2, "mcs2_hhgrid.dta")) %>%
  filter(!is.na(BCNUM00), BCNUM00 != 0) %>%
  rename(CNUM = BCNUM00) %>%
  mutate(SWEEP = 2) %>%
  select(MCSID, CNUM, SWEEP, BHCSEX00, BHCAGE00)

agey_mcs3 <- read_dta(file.path(mcs3, "mcs3_hhgrid.dta")) %>%
  filter(!is.na(CCNUM00), CCNUM00 != 0) %>%
  rename(CNUM = CCNUM00) %>%
  mutate(SWEEP = 3) %>%
  select(MCSID, CNUM, SWEEP, CHCSEX00, CHCAGE00)

agey_mcs4 <- read_dta(file.path(mcs4, "mcs4_hhgrid.dta")) %>%
  filter(!is.na(DCNUM00), DCNUM00 != -1) %>%
  rename(CNUM = DCNUM00) %>%
  mutate(SWEEP = 4) %>%
  select(MCSID, CNUM, SWEEP, DHCSEX00, DHCAGE00)

agey_mcs4 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

agey_mcs5_interview <- read_dta(file.path(mcs5, "mcs5_cm_interview.dta")) %>%
  select(MCSID, ECNUM00, EMCS5AGE) %>%
  rename(CNUM = ECNUM00)

agey_mcs5_interview %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

agey_mcs5 <- read_dta(file.path(mcs5, "mcs5_hhgrid.dta")) %>%
  filter(!is.na(ECNUM00), ECNUM00 != -1) %>%
  rename(CNUM = ECNUM00) %>%
  mutate(SWEEP = 5) %>%
  select(MCSID, CNUM, SWEEP, ECSEX0000, ECAGE0000)

agey_mcs5 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

agey_mcs6 <- read_dta(file.path(mcs6, "mcs6_hhgrid.dta")) %>%
  filter(!is.na(FCNUM00), FCNUM00 != -1) %>%
  rename(CNUM = FCNUM00) %>%
  mutate(SWEEP = 6) %>%
  select(MCSID, CNUM, SWEEP, FHCSEX00, FHCAGE00)

agey_mcs6 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

agey_mcs7 <- read_dta(file.path(mcs7, "mcs7_hhgrid.dta")) %>%
  filter(!is.na(GCNUM00), GCNUM00 != -1) %>%
  rename(CNUM = GCNUM00) %>%
  mutate(SWEEP = 7) %>%
  select(MCSID, CNUM, SWEEP, GHCSEX00, GHCAGE00)

agey_mcs7 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

datasets <- list(agey_mcs1, agey_mcs2, agey_mcs3, agey_mcs4,
                      agey_mcs5, agey_mcs6, agey_mcs7)
agey_all <- bind_rows(datasets)
agey_all <- left_join(agey_all, agey_mcs5_interview, by = c("MCSID", "CNUM"))

table(agey_all$SWEEP, useNA = "ifany")

#3, Generate new variable in a longitudinal format
agey_all <- agey_all %>% mutate(
  CHCAGE00 = na_if(CHCAGE00, -1),
  across(c(AHCAGE00, BHCAGE00, CHCAGE00, DHCAGE00), ~ .x / 365.25), 
  EMCS5AGE = na_if(EMCS5AGE, 18),
  EMCS5AGE = if_else(is.na(EMCS5AGE) & !is.na(ECAGE0000) & SWEEP == 5, ECAGE0000, EMCS5AGE),
  GHCAGE00 = na_if(GHCAGE00, -1))

agey_all <- agey_all %>%
  mutate(AGEY = case_when(
    SWEEP == 1 ~ AHCAGE00,
    SWEEP == 2 ~ BHCAGE00,
    SWEEP == 3 ~ CHCAGE00,
    SWEEP == 4 ~ DHCAGE00,
    SWEEP == 5 ~ EMCS5AGE,
    SWEEP == 6 ~ FHCAGE00,
    SWEEP == 7 ~ GHCAGE00,
    .default = NA_real_))

agey_all <- agey_all %>%
  mutate(SWEEPAGE = SWEEP) %>%
  mutate(
    SWEEPAGE = case_when(
      SWEEPAGE == 1 ~ 1,
      SWEEPAGE == 2 ~ 3,
      SWEEPAGE == 3 ~ 5,
      SWEEPAGE == 4 ~ 7,
      SWEEPAGE == 5 ~ 11,
      SWEEPAGE == 6 ~ 14,
      SWEEPAGE == 7 ~ 17,
      TRUE ~ SWEEPAGE)) 

table(agey_all$SWEEPAGE, useNA = "ifany")

# Step 1: Define full value-label mapping
all_vals <- c( -9, -8, -1)
all_labs <- c("Refusal", "Don't know", "Not applicable")

# Step 2: Attach labels to the numeric variable
agey_all <- agey_all %>%
  mutate(AGEY = labelled(AGEY, labels = setNames(all_vals, all_labs)))
val_labels(agey_all$AGEY)

agey_all$AGEY <- round(agey_all$AGEY, 1)
attr(agey_all$AGEY, "label") <- "Age at interview (years)"
table(agey_all$AGEY, agey_all$SWEEP, useNA = "ifany")

agey_all <- agey_all %>%
  mutate(
    SWEEPAGE = labelled(
      SWEEPAGE,
      labels = c(
        "Refusal"         = -9,
        "Don't know"      = -8,
        "Not Applicable"  = -1,
        "9 months"        = 1,
        "3 years"         = 3,
        "5 years"         = 5,
        "7 years"         = 7,
        "11 years"        = 11,
        "14 years"        = 14,
        "17 years"        = 17
      )
    )
  )

table(agey_all$SWEEPAGE, useNA = "ifany")
val_labels(agey_all$SWEEPAGE)

#4, save temporal data 
agey_all <- agey_all %>% select(MCSID, CNUM, SWEEP, AGEY, SWEEPAGE)
agey_all <- agey_all %>%
  mutate(SWEEP = labelled(SWEEP, labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

agey_all <- agey_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(agey_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(agey_all, file = file.path(temp_data_cdv, "AGEY_SWEEPAGE.Rds"))

#5, save working memory
rm(agey_all, agey_mcs1, agey_mcs2, agey_mcs3, agey_mcs4, agey_mcs5, agey_mcs6, agey_mcs7, agey_mcs5_interview, datasets)