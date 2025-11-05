# DTOTS:  DV Number of sibs in hhold plus CMs

#1, Extract variables from raw MCS data
dtots_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dtots_all <- bind_rows(dtots_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dtots_all <- dtots_all %>%
  zap_labels(dtots_all) %>%
  mutate(DTOTS = case_when(
    SWEEP == 1 ~ ADTOTS00,
    SWEEP == 2 ~ BDTOTS00,
    SWEEP == 3 ~ CDTOTS00,
    SWEEP == 4 ~ DDTOTS00,
    SWEEP == 5 ~ ETOTS00,
    SWEEP == 6 ~ FDTOTS00,
    SWEEP == 7 ~ GDTOTS00,
    .default = NA_real_)) %>%
  mutate(DTOTS = case_when(
    SWEEP == 4 & DTOTS == -2 ~ -8,
    SWEEP == 7 & DTOTS == 0 ~ -1,
    TRUE ~ DTOTS))

# Step 1: Identify valid values (excluding special/missing codes)
valid_vals <- sort(unique(dtots_all$DTOTS[!dtots_all$DTOTS %in% c(-9, -8, -1)]))
valid_labs <- as.character(valid_vals)

# Step 2: Define full value-label mapping
all_vals <- c(valid_vals, -9, -8, -1)
all_labs <- c(valid_labs, "Refusal", "Don't know", "Not applicable")

# Step 3: Attach labels to the numeric variable
dtots_all <- dtots_all %>%
  mutate(DTOTS = labelled(DTOTS, labels = setNames(all_vals, all_labs)))
attr(dtots_all$DTOTS, "label") <- "DV Number of sibs in hhold plus CMs"
table(dtots_all$DTOTS, dtots_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dtots_all <- dtots_all %>% select(MCSID, SWEEP, DTOTS)
dtots_all <- dtots_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dtots_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dtots_all, file = file.path(temp_data_fdv, "DTOTS.Rds"))

#5, save working memory
rm(dtots_all, temporary)