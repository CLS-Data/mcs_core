# DMBMI: DV Natural Mothers BMI at Interview 

#1, Extract variables from raw MCS data
dmbmi_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dmbmi_all <- bind_rows(dmbmi_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dmbmi_all <- dmbmi_all %>%
  zap_labels(dmbmi_all) %>%
  mutate(DMBMI = case_when(
    SWEEP == 1 ~ ADMBMI00,
    SWEEP == 2 ~ BDMBMI00,
    SWEEP == 3 ~ CDMBMI00,
    SWEEP == 4 ~ DDMBMI00,
    SWEEP == 5 ~ NA,
    SWEEP == 6 ~ NA,
    SWEEP == 7 ~ NA,
    .default = NA_real_)) %>%
  mutate(
    DMBMI = case_when(
      DMBMI == -2 ~ -8,
      TRUE ~ DMBMI))

# Step 1: Define full value-label mapping
all_vals <- c( -9, -8, -1)
all_labs <- c("Refusal", "Don't know", "Not applicable")

# Step 2: Attach labels to the numeric variable
dmbmi_all <- dmbmi_all %>%
  mutate(DMBMI = labelled(DMBMI, labels = setNames(all_vals, all_labs)))
val_labels(dmbmi_all$DMBMI)

attr(dmbmi_all$DMBMI, "label") <- "DV Natural Mothers BMI at Interview"
table(dmbmi_all$DMBMI, dmbmi_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dmbmi_all <- dmbmi_all %>% select(MCSID, SWEEP, DMBMI)
dmbmi_all <- dmbmi_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dmbmi_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dmbmi_all, file = file.path(temp_data_fdv, "DMBMI.Rds"))

#5, save working memory
rm(dmbmi_all, temporary)