# DTOTP: DV Number of people in HH including CMs

#1, Extract variables from raw MCS data
dtotp_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dtotp_all <- bind_rows(dtotp_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dtotp_all <- dtotp_all %>%
  zap_labels(dtotp_all) %>%
  mutate(DTOTP = case_when(
    SWEEP == 1 ~ ADTOTP00,
    SWEEP == 2 ~ BDTOTP00,
    SWEEP == 3 ~ CDTOTP00,
    SWEEP == 4 ~ DDTOTP00,
    SWEEP == 5 ~ ETOTP00,
    SWEEP == 6 ~ FDTOTP00,
    SWEEP == 7 ~ GDTOTP00,
    .default = NA_real_)) %>%
  mutate(DTOTP = case_when(
    SWEEP == 7 & DTOTP == 0 ~ -1,
    TRUE ~ DTOTP))

# Step 1: Identify valid values (excluding special/missing codes)
valid_vals <- sort(unique(dtotp_all$DTOTP[!dtotp_all$DTOTP %in% c(-9, -8, -1)]))
valid_labs <- as.character(valid_vals)

# Step 2: Define full value-label mapping
all_vals <- c(valid_vals, -9, -8, -1)
all_labs <- c(valid_labs, "Refusal", "Don't know", "Not applicable")

# Step 3: Attach labels to the numeric variable
dtotp_all <- dtotp_all %>%
  mutate(DTOTP = labelled(DTOTP, labels = setNames(all_vals, all_labs)))
val_labels(dtotp_all$DTOTP)

attr(dtotp_all$DTOTP, "label") <- "DV Number of people in HH including CMs"
table(dtotp_all$DTOTP, dtotp_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dtotp_all <- dtotp_all %>% select(MCSID, SWEEP, DTOTP)
dtotp_all <- dtotp_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dtotp_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dtotp_all, file = file.path(temp_data_fdv, "DTOTP.Rds"))

#5, save working memory
rm(dtotp_all, temporary)