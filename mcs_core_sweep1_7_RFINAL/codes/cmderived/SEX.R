# SEX: CM Sex at birth

#1, Extract variables from raw MCS data
sex_mcs1 <- read_dta(file.path(mcs1, "mcs1_hhgrid.dta")) %>%
  filter(!is.na(ACNUM00), ACNUM00 != 0) %>%
  rename(CNUM = ACNUM00) %>%
  select(MCSID, CNUM, AHCSEX00)

sex_mcs1 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

sex_mcs2 <- read_dta(file.path(mcs2, "mcs2_hhgrid.dta")) %>%
  filter(!is.na(BCNUM00), BCNUM00 != 0) %>%
  rename(CNUM = BCNUM00) %>%
  select(MCSID, CNUM, BHCSEX00)

sex_mcs3 <- read_dta(file.path(mcs3, "mcs3_hhgrid.dta")) %>%
  filter(!is.na(CCNUM00), CCNUM00 != 0) %>%
  rename(CNUM = CCNUM00) %>%
  select(MCSID, CNUM, CHCSEX00)

sex_mcs3_int <- read_dta(file.path(mcs3, "mcs3_cm_interview.dta")) %>%
  filter(!is.na(CCNUM00), CCNUM00 != 0) %>%
  rename(CNUM = CCNUM00) %>%
  rename(CHCSEX00_cm_int = CHCSEX00) %>%
  select(MCSID, CNUM, CHCSEX00_cm_int)

sex_mcs4 <- read_dta(file.path(mcs4, "mcs4_hhgrid.dta")) %>%
  filter(!is.na(DCNUM00), DCNUM00 != -1) %>%
  rename(CNUM = DCNUM00) %>%
  select(MCSID, CNUM, DHCSEX00)

sex_mcs4 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

sex_mcs5 <- read_dta(file.path(mcs5, "mcs5_hhgrid.dta")) %>%
  filter(!is.na(ECNUM00), ECNUM00 != -1) %>%
  rename(CNUM = ECNUM00) %>%
  select(MCSID, CNUM, ECSEX0000)

sex_mcs5 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

sex_mcs6 <- read_dta(file.path(mcs6, "mcs6_hhgrid.dta")) %>%
  filter(!is.na(FCNUM00), FCNUM00 != -1) %>%
  rename(CNUM = FCNUM00) %>%
  select(MCSID, CNUM, FHCSEX00)

sex_mcs6 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

sex_all <- sex_mcs1 %>%
  full_join(sex_mcs2, by = c("MCSID", "CNUM")) %>%
  full_join(sex_mcs3, by = c("MCSID", "CNUM")) %>%
  full_join(sex_mcs3_int, by = c("MCSID", "CNUM")) %>%
  full_join(sex_mcs4, by = c("MCSID", "CNUM")) %>%
  full_join(sex_mcs5, by = c("MCSID", "CNUM")) %>%
  full_join(sex_mcs6, by = c("MCSID", "CNUM"))

#3, Generate new variable in a longitudinal format
sex_all <- sex_all %>%
  zap_labels(sex_all) %>%
  mutate(SEX = coalesce(AHCSEX00, BHCSEX00, CHCSEX00, DHCSEX00, ECSEX0000, FHCSEX00, CHCSEX00_cm_int))
  
sex_all <- sex_all %>%
  mutate(SEX = labelled(
    SEX,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1,
      "Male"           = 1,
      "Female"        = 2
    )
  ))  

#4, save temporal data 
sex_all <- sex_all %>% select(MCSID, CNUM, SEX) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
saveRDS(sex_all, file = file.path(temp_data_cdv, "SEX.Rds"))

#5, save working memory
rm(sex_all, sex_mcs1, sex_mcs2, sex_mcs3, sex_mcs4, sex_mcs5, sex_mcs6, sex_mcs3_int)