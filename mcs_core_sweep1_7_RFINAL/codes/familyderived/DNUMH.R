# DNUMH: Number of people present in HH excluding CMs  

#1, Extract variables from raw MCS data
dnumh_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dnumh_all <- bind_rows(dnumh_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dnumh_all <- dnumh_all %>%
  zap_labels(dnumh_all) %>%
  mutate(DNUMH = case_when(
    SWEEP == 1 ~ ADNMHD00,
    SWEEP == 2 ~ BDNUMH00,
    SWEEP == 3 ~ CDNUMH00,
    SWEEP == 4 ~ DDNUMH00,
    SWEEP == 5 ~ ENUMH00,
    SWEEP == 6 ~ FDNUMH00,
    SWEEP == 7 ~ GDNUMH00,
    .default = NA_real_)) %>%
  mutate(DNUMH = case_when(
    SWEEP == 7 & DNUMH == 0 ~ -1,
    TRUE ~ DNUMH))

# Step 1: Identify valid values (excluding special/missing codes)
valid_vals <- sort(unique(dnumh_all$DNUMH[!dnumh_all$DNUMH %in% c(-9, -8, -1)]))
valid_labs <- as.character(valid_vals)

# Step 2: Define full value-label mapping
all_vals <- c(valid_vals, -9, -8, -1)
all_labs <- c(valid_labs, "Refusal", "Don't know", "Not applicable")

# Step 3: Attach labels to the numeric variable
dnumh_all <- dnumh_all %>%
  mutate(DNUMH = labelled(DNUMH, labels = setNames(all_vals, all_labs)))

val_labels(dnumh_all$DNUMH)
attr(dnumh_all$DNUMH, "label") <- "DV Number of people present in HH excluding CMs"
table(dnumh_all$DNUMH, dnumh_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dnumh_all <- dnumh_all %>% select(MCSID, SWEEP, DNUMH)
dnumh_all <- dnumh_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dnumh_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dnumh_all, file = file.path(temp_data_fdv, "DNUMH.Rds"))

#5, save working memory
rm(dnumh_all, temporary)