#----------------------------------------------------------------------------#
# R Script to generate the mcs_core_sweeps1_7 dataset using tidyverse
#----------------------------------------------------------------------------#

# Required packages
library(dplyr)
library(tidyr)
library(haven)
library(labelled)

# Load the initial dataset
mcs_longitudinal_family_file_long <- readRDS(file.path(temp_data, "mcs_longitudinal_family_file_long.Rds"))

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
  mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
    full_join(family_data, by = c("MCSID", "SWEEP"))}

#----------------------------------------------------------------------------#
# 2) Merge Cohort member derived variables (MCSID CNUM SWEEP)
#----------------------------------------------------------------------------#

# Time-variant variables
cmvartv <- c("AGEY_SWEEPAGE", "SDQ_SCBQ", "HEALTH", "CGHE", "CLSI_CLSL", 
             "CLOSER_BMI_WT_HT_XAGE", "WEIGHT_HEIGHT", "ROSENBERG_SATI_GDQL_DOWL_VALU_GDSF", 
             "DWEMWBS", "COGNITIVE", "SUBSTANCE", "CRIME")

for (var in cmvartv) {
  cm_data <- readRDS(file.path(temp_data_cdv, paste0(var, ".Rds")))
  mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
    full_join(cm_data, by = c("MCSID", "CNUM", "SWEEP"))}

# Time-invariant variables
cmvarin <- c("SEX", "DC11E", "BWGT", "GESTAGE")
for (var in cmvarin) {
  cm_data <- readRDS(file.path(temp_data_cdv, paste0(var, ".Rds")))
  mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
    left_join(cm_data, by = c("MCSID", "CNUM"))}

#----------------------------------------------------------------------------#
# 3) Merge Parent derived variables
#----------------------------------------------------------------------------#

parentvar <- c("D05S_D07S_D13S_D05C_D07C_D13C", "DACAQ_DNVQ", "DACAQ_DNVQ_P", "KESSLER_WALI_GEHE_GENA")

for (var in parentvar) {
  parent_data <- readRDS(file.path(temp_data_pdv, paste0(var, ".Rds")))
  mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
    full_join(parent_data, by = c("MCSID", "SWEEP"))}

#----------------------------------------------------------------------------#
# 4) Change/edit variable names/labels/order and other
#----------------------------------------------------------------------------#
# Remove the triplets
mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  filter(NOCMHH != 3)

# Reorder variables
mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  arrange(MCSID, CNUM, SWEEP) %>%
  select(MCSID, CNUM, SWEEP, everything())

# Replace missing SWEEPAGE values based on sweep number
mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  mutate(SWEEPAGE = case_when(
           SWEEP == 1 & is.na(SWEEPAGE) ~ 1,
           SWEEP == 2 & is.na(SWEEPAGE) ~ 3,
           SWEEP == 3 & is.na(SWEEPAGE) ~ 5,
           SWEEP == 4 & is.na(SWEEPAGE) ~ 7,
           SWEEP == 5 & is.na(SWEEPAGE) ~ 11,
           SWEEP == 6 & is.na(SWEEPAGE) ~ 14,
           SWEEP == 7 & is.na(SWEEPAGE) ~ 17,
           TRUE ~ SWEEPAGE))

# Relabel variables
attr(mcs_longitudinal_family_file_long$OVWT1, "label") <- "Overall Weight (inc NR adjustment) single country analysis"
attr(mcs_longitudinal_family_file_long$OVWT2, "label") <- "Overall Weight (inc NR adjustment) whole UK analyses"
attr(mcs_longitudinal_family_file_long$OVWTGB, "label") <- "Overall weight for use on GB analysis"

# Replace missing AGEY values for unproductive surveys
mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  mutate(AGEY = as.numeric(as.character(AGEY))) %>%
  mutate(AGEY = if_else(AOUTC != 1, NA_real_, AGEY),
         AGEY = if_else(is.na(AGEY) & AOUTC == 1, as.numeric(SWEEPAGE), AGEY))

# Replace missing values for other variables in unproductive surveys
listvar <- c("ACTRY", "AREGN", "DRSPO", "DHTYP", "DHTYS", "DRELP", "DMINH", "DFINH", "DOTHS", 
             "DNOCM", "DTOTS", "DNSIB", "DHSIB", "DSSIB", "DASIB", "DFSIB", "DGPAR", "DOTHA",
             "DNUMH", "DTOTP","DCWRK", "DOEDE", "DOEDP")
for (v in listvar) {
  mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
    mutate(!!sym(v) := if_else(AOUTC == 1 & is.na(.data[[v]]), -8, .data[[v]]))
}

# Set missing values for specific variables to -8 (Don't know)
listvar_dk <- c("DROOW", "DHLAN")
for (v in listvar_dk) {
  mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
    mutate(!!sym(v) := if_else(AOUTC == 1 & is.na(.data[[v]]) & SWEEP != 7, -8, .data[[v]]))
}

#----------------------------------------------------------------------------#
# 5) Save dataset
#----------------------------------------------------------------------------#

# Compress and save the final dataset
mcs_core_sweeps1_7 <- mcs_longitudinal_family_file_long %>%
  arrange(MCSID, CNUM, SWEEP)

# Save as .dta
saveRDS(mcs_core_sweeps1_7, file = file.path(temp_data, "mcs_core_sweeps1_7.Rds"))

#save memory
rm(list = setdiff(ls(), "mcs_core_sweeps1_7"))