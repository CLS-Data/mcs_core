#----------------------------------------------------------------------------#
# R Script to generate the mcs_longitudinal_family_file_long dataset using tidyverse
#----------------------------------------------------------------------------#

# Required packages
library(dplyr)
library(tidyr)
library(stringr)
library(haven)

#----------------------------------------------------------------------------#
# Step 1: Load the raw MCS data
#----------------------------------------------------------------------------#

# Load the MCS longitudinal family file (adjust the path accordingly)
mcs_longitudinal_family_file <- read_dta(file.path(mcslf, "mcs_longitudinal_family_file.dta")) %>% 
  select(-DATA_LICENCE, -DUALBABYFAMILY)

# Define the number of sweeps
sweeps <- 7

#----------------------------------------------------------------------------#
# Step 2: Change/recode/edit variables if needed
#----------------------------------------------------------------------------#
#remove unavailable people
mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>% filter(!DATA_AVAILABILITY == 0) %>% select(-DATA_AVAILABILITY)

#remove triplets
#NOTE TO USER: the main MCS datasets on UKDS do not include triplets. for that reason,
#they are excluded here. if you are using other forms of the data, you may want to retain
#the triplets. If so, do not run this section of code.
mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>% filter(NOCMHH != 3)

#rename CNUM00
mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>%
  rowwise() %>%
  mutate(CNUM = list(seq_len(NOCMHH))) %>%
  unnest(CNUM) # Expand rows based on NOCMHH

# Rename variables
mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>%
  rename(SPTN = SPTN00, PTTY = PTTY00)

# Recode specific variables
mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>%
  mutate(BAOUTC00 = case_when(
    BAOUTC00 == 1 ~ 1,
    BAOUTC00 == 2 ~ 4,
    BAOUTC00 == 3 ~ 5,
    BAOUTC00 == 4 ~ 2,
    BAOUTC00 == 5 ~ 6,
    BAOUTC00 == 6 ~ 3
  )) %>%
  mutate(AAOUTC00 = case_when(
    AAOUTC00 == 2 ~ 1,
    TRUE ~ AAOUTC00)) %>%
  mutate(BAOUTC00 = ifelse(BISSUED == 0, 0, BAOUTC00),
         CAOUTC00 = ifelse(CISSUED == 0, 0, CAOUTC00),
         FAOUTC00 = ifelse(FISSUED == 0, 0, FAOUTC00),
         FAOUTC00 = ifelse(FAOUTC00 == -1, 0, FAOUTC00),
         GAOUTC00 = ifelse(GAOUTC00 == -1, 0, GAOUTC00))

# Remove Sweep-Letter Prefix
for (sweep in 1:sweeps) {
  letter <- LETTERS[sweep]
  
  mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "ISSUED"), paste0("ISSUED_", sweep)),
                starts_with(paste0(letter, "ISSUED"))) %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "AOUTC00"), paste0("AOUTC_", sweep)),
                starts_with(paste0(letter, "AOUTC00"))) %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "OVWT1"), paste0("OVWT1_", sweep)),
                starts_with(paste0(letter, "OVWT1"))) %>%
    rename_with(~ str_replace_all(., paste0("^", letter, "OVWT2"), paste0("OVWT2_", sweep)),
                starts_with(paste0(letter, "OVWT2")))
  
  if (sweep %in% c(2, 5, 6, 7)) {
    mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>%
      rename_with(~ str_replace_all(., paste0("^", letter, "NRESPWT"), paste0("NRESPWT_", sweep)),
                  starts_with(paste0(letter, "NRESPWT")))
  }
  
  if (sweep %in% c(2, 3, 4)) {
    mcs_longitudinal_family_file <- mcs_longitudinal_family_file %>%
      rename_with(~ str_replace_all(., paste0("^", letter, "OVWTGB"), paste0("OVWTGB_", sweep)),
                  starts_with(paste0(letter, "OVWTGB")))
  }
}

#----------------------------------------------------------------------------#
# Step 3: Generate new variables in a longitudinal format
#----------------------------------------------------------------------------#

# Reshape from wide to long format
suppressWarnings({
mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file %>%
  pivot_longer(cols = matches("^(ISSUED|AOUTC|OVWT1|OVWT2|NRESPWT|OVWTGB)_\\d+$"),
               names_to = c("VAR", "SWEEP"),
               names_pattern = "^(.*)_(\\d+)$") %>%
  pivot_wider(names_from = "VAR", values_from = "value") %>%
  arrange(MCSID, CNUM)
})

# Add labels to the variables
attr(mcs_longitudinal_family_file_long$CNUM, "label") <- "Cohort Member number within an MCS family"
attr(mcs_longitudinal_family_file_long$AOUTC, "label") <- "Survey Outcome Code"
attr(mcs_longitudinal_family_file_long$NRESPWT, "label") <- "Non-Response Weight"
attr(mcs_longitudinal_family_file_long$ISSUED, "label") <- "Family Issued at MCS survey"
attr(mcs_longitudinal_family_file_long$SWEEP, "label") <- "MCS Sweep"

mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  mutate(SWEEP = as.numeric(SWEEP))

mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  mutate(
    AOUTC = labelled(
      AOUTC,
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
    ISSUED = labelled(
      ISSUED,
      labels = c("No" = 0, "Yes" = 1)
    ),
    SWEEP = labelled(
      SWEEP,
      labels = setNames(1:7, as.character(1:7))
    ),
    NOCMHH = labelled(
      NOCMHH,
      labels = c(
        "1. Singletons" = 1,
        "2. Twins"      = 2,
        "3. Triplets"   = 3
      )))
    
mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  mutate(CNUM = factor (CNUM, levels = c(1, 2, 3), labels = c("1st Cohort Member of the family",
                                                                  "2nd Cohort Member of the family",
                                                                  "3rd Cohort Member of the family")))

mcs_longitudinal_family_file_long <- mcs_longitudinal_family_file_long %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, 
                                            "MCS5" = 5, "MCS6" = 6, "MCS7" = 7)))
#----------------------------------------------------------------------------#
# Step 4: Save the final dataset
#----------------------------------------------------------------------------#

# Compress the dataset (optional)
mcs_longitudinal_family_file_long <- as_tibble(mcs_longitudinal_family_file_long)

# Save the final dataset
saveRDS(mcs_longitudinal_family_file_long, file = file.path(temp_data, "mcs_longitudinal_family_file_long.Rds"))
