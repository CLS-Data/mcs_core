#----------------------------------------------------------------------------#
# R Script to generate the MCS Core dataset
#----------------------------------------------------------------------------#

# NB. Please use .dta files only throughout your workflow.

# Required packages
library(dplyr)
library(tidyr)
library(haven)
library(labelled)

#----------------------------------------------------------------------------#
# Step 1: Define paths for your data and code directories
#----------------------------------------------------------------------------#

# Define the root path where the MCS Core folder is located
core_dir <- "" # Add the path to your 'mcs_core' folder here

# Define specific subpaths for datasets
mcs1 <- "" # Path to the MCS 1 datasets - UKDS SN 4683
mcs2 <- "" # Path to the MCS 2 datasets - UKDS SN 5350
mcs3 <- ""# Path to the MCS 3 datasets - UKDS SN 5795
mcs4 <- "" # Path to the MCS 4 datasets - UKDS SN 6411
mcs5 <- "" # Path to the MCS 5 datasets - UKDS SN 7464
mcs6 <- "" # Path to the MCS 6 datasets - UKDS SN 8156
mcs7 <- "" # Path to the MCS 7 datasets - UKDS SN 8682
mcslf <- "" # Path to the MCS Longitudinal File - UKDS SN 8172
closer <- "" # Path to the Harmonised Height, Weight and BMI dataset - UKDS SN 8550

#----------------------------------------------------------------------------#
# Step 2: Define paths for temporary data and code directories
#----------------------------------------------------------------------------#
#set temp_data folders
temp_data <- file.path(core_dir, "temp_data/")
temp_data_fdv <- file.path(temp_data, "familyderived")
temp_data_cdv <- file.path(temp_data, "cmderived")
temp_data_pdv <- file.path(temp_data, "parentderived")

#set code folders
codes <- file.path(core_dir, "codes/")
codes_fdv <- file.path(codes, "familyderived")
codes_cdv <- file.path(codes, "cmderived")
codes_pdv <- file.path(codes, "parentderived")

#----------------------------------------------------------------------------#
# Step 3: Run the R scripts to generate the derived variables
#----------------------------------------------------------------------------#

# Family derived variables
dfamilyvar <- c("ACTRY", "AREGN", "DRSPO", "DHTYP", "DHTYS", "DRELP", "DMINH",
                "DFINH", "DOTHS", "DNOCM", "DTOTS", "DNSIB", "DHSIB", "DSSIB",
                "DASIB", "DFSIB", "DGPAR", "DOTHA", "DNUMH", "DTOTP", "DCWRK",
                "DROOW", "DMBMI", "DHLAN", "DOEDS", "DOEDE", "DOEDP")

for (var in dfamilyvar) {
  script_path <- file.path(codes_fdv, paste0(var, ".R"))
  source(script_path)  # Execute each R script for family derived variables
}

# Cohort member derived variables
dcmvartv <- c("AGEY_SWEEPAGE", "BWGT", "CGHE", "CLOSER_BMI_WT_HT_XAGE", "CLSI_CLSL",
              "DC11E", "GESTAGE", "SDQ_SCBQ", "HEALTH", "SEX", "WEIGHT_HEIGHT",
              "ROSENBERG_SATI_GDQL_DOWL_VALU_GDSF", "DWEMWBS", "COGNITIVE",
              "SUBSTANCE", "CRIME")

for (var in dcmvartv) {
  script_path <- file.path(codes_cdv, paste0(var, ".R"))
  source(script_path)  # Execute each R script for cohort member derived variables
}

# Parent derived variables
dparentvar <- c("D05S_D07S_D13S_D05C_D07C_D13C", "DACAQ_DNVQ", 
                "DACAQ_DNVQ_P", "KESSLER_WALI_GEHE_GENA")

for (var in dparentvar) {
  script_path <- file.path(codes_pdv, paste0(var, ".R"))
  source(script_path)  # Execute each R script for parent derived variables
}

#----------------------------------------------------------------------------#
# Step 4: Run the R scripts to merge variables and create the final dataset
#----------------------------------------------------------------------------#

# Run the script to generate the mcs_longitudinal_family_file_long dataset
source(file.path(codes, "2_MCS_long.R"))

# Run the script to generate the MCS Core dataset
source(file.path(codes, "3_MCS_linkage.R"))

#----------------------------------------------------------------------------#