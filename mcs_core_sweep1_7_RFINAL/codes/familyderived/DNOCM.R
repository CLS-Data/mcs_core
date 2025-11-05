# DNOCM: DV Number of CM in household

#1, Extract variables from raw MCS data
dnocm_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dnocm_all <- bind_rows(dnocm_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dnocm_all <- dnocm_all %>%
  zap_labels(dnocm_all) %>%
  mutate(DNOCM = case_when(
    SWEEP == 1 ~ ADNOCM00,
    SWEEP == 2 ~ BDNOCM00,
    SWEEP == 3 ~ CDNOCM00,
    SWEEP == 4 ~ DDNOCM00,
    SWEEP == 5 ~ ENOCM00,
    SWEEP == 6 ~ FDNOCM00,
    SWEEP == 7 ~ GDNOCM00,
    .default = NA_real_)) %>%
  mutate(DNOCM = case_when(
    SWEEP == 7 & DNOCM == 0 ~ -1,
    TRUE ~ DNOCM))

# Step 1: Identify valid codes (excluding missing codes)
valid_vals <- sort(unique(dnocm_all$DNOCM[!dnocm_all$DNOCM %in% c(-9, -8, -1)]))
valid_labs <- as.character(valid_vals)

# Step 2: Define full value-label mapping
all_vals <- c(valid_vals, -9, -8, -1)
all_labs <- c(valid_labs, "Refusal", "Don't know", "Not applicable")

# Step 3: Apply labels without converting to factor
dnocm_all <- dnocm_all %>%
  mutate(DNOCM = labelled(DNOCM, labels = setNames(all_vals, all_labs)))
val_labels(dnocm_all$DNOCM)
attr(dnocm_all$DNOCM, "label") <- "DV Number of CM in household"
table(dnocm_all$DNOCM, dnocm_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dnocm_all <- dnocm_all %>% select(MCSID, SWEEP, DNOCM)
dnocm_all <- dnocm_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dnocm_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dnocm_all, file = file.path(temp_data_fdv, "DNOCM.Rds"))

#5, save working memory
rm(dnocm_all, temporary)