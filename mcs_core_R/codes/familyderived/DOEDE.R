# DOEDE: DV OECD equivalised income

#1, Extract variables from raw MCS data
doede_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  doede_all <- bind_rows(doede_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
doede_all <- doede_all %>%
  zap_labels(doede_all) %>%
  mutate(DOEDE = case_when(
    SWEEP == 1 ~ ADOEDE00,
    SWEEP == 2 ~ BDOEDE00,
    SWEEP == 3 ~ CDOEDE00,
    SWEEP == 4 ~ DDOEDE00,
    SWEEP == 5 ~ EOEDE000,
    SWEEP == 6 ~ FOEDE000,
    SWEEP == 7 ~ -1,
    .default = NA_real_)) %>%
  mutate(
    DOEDE = case_when(
      DOEDE == -2 ~ -8,
      TRUE ~ DOEDE))

# Step 1: Define full value-label mapping
all_vals <- c( -9, -8, -1)
all_labs <- c("Refusal", "Don't know", "Not applicable")

# Step 2: Attach labels to the numeric variable
doede_all <- doede_all %>%
  mutate(DOEDE = labelled(DOEDE, labels = setNames(all_vals, all_labs)))
val_labels(doede_all$DOEDE)

attr(doede_all$DOEDE, "label") <- "DV OECD equivalised income"
table(doede_all$DOEDE, doede_all$SWEEP, useNA = "ifany")

#4, save temporal data 
doede_all <- doede_all %>% select(MCSID, SWEEP, DOEDE)
doede_all <- doede_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))


attr(doede_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(doede_all, file = file.path(temp_data_fdv, "DOEDE.Rds"))

#5, save working memory
rm(doede_all, temporary)