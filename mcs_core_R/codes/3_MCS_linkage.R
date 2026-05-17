#----------------------------------------------------------------------------#
# R Script to generate the mcs_core_sweeps1_8 dataset using tidyverse
#----------------------------------------------------------------------------#

# Required packages
library(dplyr)
library(tidyr)
library(haven)
library(labelled)

# Load the initial dataset
mcs_longitudinal_cm_file_long <- readRDS(file.path(temp_data, "mcs_longitudinal_cm_file_long.Rds"))

#----------------------------------------------------------------------------#
# 1) Merge Family derived variables (MCSID SWEEP)
#----------------------------------------------------------------------------#

# List of family derived variables to merge
familyvar <- c("ACTRY", "AREGN", "DRSPO", "DHTYP", "DHTYS", "DRELP", "DMINH", "DFINH", "DOTHS",
               "DNOCM", "DTOTS", "DNSIB", "DHSIB", "DSSIB", "DASIB", "DFSIB", "DGPAR", "DOTHA", 
               "DNUMH", "DTOTP", "DCWRK", "DROOW", "DMBMI", "DHLAN", "DOEDS", "DOEDE", "DOEDP")

# Merge each family variable dataset
for (var in familyvar) {
  family_data <- readRDS(file.path(temp_data_fdv, paste0(var, ".Rds")))
  mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
    left_join(family_data, by = c("MCSID", "SWEEP"))}

#----------------------------------------------------------------------------#
# 2) Merge Cohort member derived variables (MCSID CNUM SWEEP)
#----------------------------------------------------------------------------#

# Time-variant variables
cmvartv <- c("AGEY_SWEEPAGE", "SDQ_SCBQ", "HEALTH", "CGHE", "CLSI_CLSL", 
             "CLOSER_BMI_WT_HT_XAGE", "WEIGHT_HEIGHT", "ROSENBERG", 
             "DWEMWBS", "COGNITIVE", "SUBSTANCE", "CRIME")

for (var in cmvartv) {
  cm_data <- readRDS(file.path(temp_data_cdv, paste0(var, ".Rds")))
  mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
    left_join(cm_data, by = c("MCSID", "CNUM", "SWEEP"))}

# Time-invariant variables
cmvarin <- c("SEX", "DC11E", "BWGT", "GESTAGE")
for (var in cmvarin) {
  cm_data <- readRDS(file.path(temp_data_cdv, paste0(var, ".Rds")))
  mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
    left_join(cm_data, by = c("MCSID", "CNUM"))}

#----------------------------------------------------------------------------#
# 3) Merge Parent derived variables
#----------------------------------------------------------------------------#

parentvar <- c("D05S_D07S_D13S_D05C_D07C_D13C", "DACAQ_DNVQ", "DACAQ_DNVQ_P", "KESSLER_WALI_GEHE_GENA")

for (var in parentvar) {
  parent_data <- readRDS(file.path(temp_data_pdv, paste0(var, ".Rds")))
  mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
    left_join(parent_data, by = c("MCSID", "SWEEP"))}

#----------------------------------------------------------------------------#
# 4) Change/edit variable names/labels/order and other
#----------------------------------------------------------------------------#
# Reorder variables
mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  arrange(MCSID, CNUM, SWEEP) %>%
  select(MCSID, CNUM, SWEEP, everything())

# Replace missing SWEEPAGE values based on sweep number
mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(SWEEPAGE = case_when(
           SWEEP == 1 & is.na(SWEEPAGE) ~ 1,
           SWEEP == 2 & is.na(SWEEPAGE) ~ 3,
           SWEEP == 3 & is.na(SWEEPAGE) ~ 5,
           SWEEP == 4 & is.na(SWEEPAGE) ~ 7,
           SWEEP == 5 & is.na(SWEEPAGE) ~ 11,
           SWEEP == 6 & is.na(SWEEPAGE) ~ 14,
           SWEEP == 7 & is.na(SWEEPAGE) ~ 17,
           TRUE ~ SWEEPAGE))

# Replace missing AGEY values for unproductive surveys
mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(AGEY = as.numeric(as.character(AGEY))) %>%
  mutate(AGEY = if_else(aoutc != 1, NA_real_, AGEY),
         AGEY = if_else(is.na(AGEY) & aoutc != 1, as.numeric(as.character(SWEEPAGE)), AGEY))

# Replace missing values for other variables in unproductive surveys
listvar <- c("ACTRY", "AREGN", "DRSPO", "DHTYP", "DHTYS", "DRELP", "DMINH", "DFINH", "DOTHS", 
             "DNOCM", "DTOTS", "DNSIB", "DHSIB", "DSSIB", "DASIB", "DFSIB", "DGPAR", "DOTHA",
             "DNUMH", "DTOTP","DCWRK", "DOEDE", "DOEDP")
for (v in listvar) {
  mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
    mutate(!!sym(v) := if_else(aoutc == 1 & is.na(.data[[v]]), -8, .data[[v]]))
}

# Set missing values for specific variables to -8 (Don't know)
listvar_dk <- c("DROOW", "DHLAN")
mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(
    across(
      all_of(listvar_dk),
      ~ if_else(aoutc == 1 & is.na(.x) & !SWEEP %in% c("7", "8"), -8, .x)
    )
  )

# Add in missing labels
attr(mcs_longitudinal_cm_file_long$CNUM, "label") <- "Cohort Member number within an MCS family"
attr(mcs_longitudinal_cm_file_long$nocmhh, "label") <- "Number of Cohort Children in Household at Entry to Survey"
attr(mcs_longitudinal_cm_file_long$issued, "label") <- "Family Issued at MCS survey"
attr(mcs_longitudinal_cm_file_long$aoutc, "label") <- "Survey Outcome Code"
attr(mcs_longitudinal_cm_file_long$AGEY, "label") <- "Age at Interview (years)"
attr(mcs_longitudinal_cm_file_long$MCSID, "label") <- "Research ID - Anonymised Family/Household identifier"

# Make all variable names lower case
names(mcs_longitudinal_cm_file_long) <- tolower(names(mcs_longitudinal_cm_file_long))

#----------------------------------------------------------------------------#
# 5) Save dataset
#----------------------------------------------------------------------------#

# Compress and save the final dataset
mcs_core_sweeps1_8 <- mcs_longitudinal_cm_file_long %>%
  arrange(mcsidcmh, mcsid, cnum, sweep)

# Save as .dta
saveRDS(mcs_core_sweeps1_8, file = file.path(temp_data, "mcs_core_sweeps1_8.Rds"))

#save memory
rm(list = setdiff(ls(), "mcs_core_sweeps1_8"))