#----------------------------------------------------------------------------#
# R Script to generate the mcs_longitudinal_cm_file_long dataset using tidyverse
#----------------------------------------------------------------------------#

# Required packages
library(dplyr)
library(tidyr)
library(stringr)
library(haven)

#----------------------------------------------------------------------------#
# Step 1: Load the raw MCS data
#----------------------------------------------------------------------------#

# Load the MCS longitudinal CM file (adjust the path accordingly)
mcs_longitudinal_cm_file <- read_dta(file.path(mcslf, "mcs_longitudinal_cm_file.dta")) %>%
  rename(CNUM = cnum, MCSID = mcsid) %>%
  select(-data_licence, -dualbabyfamily, -hcasetype)

# Define the number of sweeps
sweeps <- 8

#----------------------------------------------------------------------------#
# Step 2: Change/recode/edit variables if needed
#----------------------------------------------------------------------------#
#remove unavailable people
mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>% filter(!data_availability == 0) %>% select(-data_availability)

#remove triplets
#NOTE TO USER: the main MCS datasets on UKDS do not include triplets. for that reason,
#they are excluded here. if you are using other forms of the data, you may want to retain
#the triplets. If so, do not run this section of code.
mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>% filter(nocmhh != 3)

# Rename variables
mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>%
  rename(sptn = sptn00, ptty = ptty00)

# Recode specific variables
mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>%
  mutate(baoutc00 = case_when(
    baoutc00 == 1 ~ 1,
    baoutc00 == 2 ~ 4,
    baoutc00 == 3 ~ 5,
    baoutc00 == 4 ~ 2,
    baoutc00 == 5 ~ 6,
    baoutc00 == 6 ~ 3
  )) %>%
  mutate(aaoutc00 = case_when(
    aaoutc00 == 2 ~ 1,
    TRUE ~ aaoutc00)) %>%
  mutate(baoutc00 = ifelse(bissued == 0, 0, baoutc00),
         caoutc00 = ifelse(cissued == 0, 0, caoutc00),
         faoutc00 = ifelse(fissued == 0, 0, faoutc00),
         faoutc00 = ifelse(faoutc00 == -1, 0, faoutc00),
         gaoutc00 = ifelse(gaoutc00 == -1, 0, gaoutc00),
         haoutc00 = ifelse(haoutc00 == -1, 0, haoutc00))

# Remove Sweep-Letter Prefix
for (sweep in 1:sweeps) {
  letter <- letters[sweep]
  
  mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "issued"), paste0("issued_", sweep)),
                starts_with(paste0(letter, "issued"))) %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "aoutc00"), paste0("aoutc_", sweep)),
                starts_with(paste0(letter, "aoutc00"))) %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "ovwt1"), paste0("ovwt1_", sweep)),
                starts_with(paste0(letter, "ovwt1"))) %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "ovwt2"), paste0("ovwt2_", sweep)),
                starts_with(paste0(letter, "ovwt2")))
  
  if (sweep %in% c(2, 5, 6, 7, 8)) {
    mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>%
      rename_with(~ str_replace_all(., paste0("^", letter, "nrespwt"), paste0("nrespwt_", sweep)),
                  starts_with(paste0(letter, "nrespwt")))
  }
  
  if (sweep %in% c(2, 3, 4, 8)) {
    mcs_longitudinal_cm_file <- mcs_longitudinal_cm_file %>%
      rename_with(~ str_replace_all(., paste0("^", letter, "ovwtgb"), paste0("ovwtgb_", sweep)),
                  starts_with(paste0(letter, "ovwtgb")))
  }
}

#----------------------------------------------------------------------------#
# Step 3: Generate new variables in a longitudinal format
#----------------------------------------------------------------------------#

# Reshape from wide to long format
suppressWarnings({
  mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file %>%
    pivot_longer(cols = matches("^(issued|aoutc|ovwt1|ovwt2|nrespwt|ovwtgb)_\\d+$"),
      names_to = c("var", "sweep"),
      names_pattern = "^(.*)_(\\d+)$") %>%
    pivot_wider(names_from = "var", values_from = "value") %>%
    arrange(MCSID, CNUM)
})

# Add labels to the variables
attr(mcs_longitudinal_cm_file_long$nrespwt, "label") <- "Non-Response Weight"
attr(mcs_longitudinal_cm_file_long$ovwt1, "label") <- "Overall Weight (inc NR adjustment) single country analysis"
attr(mcs_longitudinal_cm_file_long$ovwt2, "label") <- "Overall Weight (inc NR adjustment) whole UK analyses"
attr(mcs_longitudinal_cm_file_long$ovwtgb, "label") <- "Overall weight for use on GB analysis"

mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(sweep = as.numeric(sweep))

mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(
    aoutc = labelled(
      aoutc,
      labels = c(
        "0. Not Issued"         = 0,
        "1. Productive"         = 1,
        "2. Refusal"            = 2,
        "3. Other unproductive" = 3,
        "4. Ineligible"         = 4,
        "5. Untraced"           = 5,
        "6. No contact"         = 6
      )
    ),
    issued = labelled(
      issued,
      labels = c("No" = 0, "Yes" = 1)
    ),
    sweep = labelled(
      sweep,
      labels = setNames(1:8, as.character(1:8))
    ),
    nocmhh = labelled(
      nocmhh,
      labels = c(
        "1. Singletons" = 1,
        "2. Twins"      = 2,
        "3. Triplets"   = 3
      )))
    
mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), labels = c("1st Cohort Member of the family",
                                                              "2nd Cohort Member of the family",
                                                              "3rd Cohort Member of the family")))

mcs_longitudinal_cm_file_long <- mcs_longitudinal_cm_file_long %>%
  mutate(sweep = labelled(sweep,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, 
                                            "MCS5" = 5, "MCS6" = 6, "MCS7" = 7, "MCS8" = 8))) %>%
  rename(SWEEP = sweep)
attr(mcs_longitudinal_cm_file_long$SWEEP, "label") <- "MCS Sweep"
attr(mcs_longitudinal_cm_file_long$nrespwt, "labels") <- c("New family at Sweep 2" = -2)

#----------------------------------------------------------------------------#
# Step 4: Save the final dataset
#----------------------------------------------------------------------------#

# Compress the dataset (optional)
mcs_longitudinal_cm_file_long <- as_tibble(mcs_longitudinal_cm_file_long)

# Save the final dataset
saveRDS(mcs_longitudinal_cm_file_long, file = file.path(temp_data, "mcs_longitudinal_cm_file_long.Rds"))
