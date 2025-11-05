# DCWRK: DV Combined labour market status of Main and Partner

#1, Extract variables from raw MCS data
dcwrk_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dcwrk_all <- bind_rows(dcwrk_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dcwrk_all <- dcwrk_all %>%
  zap_labels(dcwrk_all) %>%
  mutate(DCWRK = case_when(
    SWEEP == 1 ~ ADCWRK00,
    SWEEP == 2 ~ BDCWRK00,
    SWEEP == 3 ~ NA,
    SWEEP == 4 ~ DDCWRK00,
    SWEEP == 5 ~ ECWRK00,
    SWEEP == 6 ~ FDCWRK00,
    SWEEP == 7 ~ -1,
    .default = NA_real_))

# Step 1: Define the numeric values and their corresponding labels
dcwrk_values <- c(-9, -8, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
dcwrk_labels <- c(
  "Refusal", "Don't know", "Not Applicable",
  "Both in work", "Main in work, partner not", "Partner in work, main not",
  "Both not in work", "Main in work or on leave, no partner",
  "Main not in work nor on leave, no partner", "Main work status unknown, partner in work",
  "Main work status unknown, partner not in work", "Main in work, partner work status unknown",
  "Main not in work, partner work status unknown", "Main working status unknown, no partner"
)

# Step 2: Apply labels using labelled()
dcwrk_all <- dcwrk_all %>%
  mutate(DCWRK = labelled(DCWRK, labels = setNames(dcwrk_values,dcwrk_labels )))

attr(dcwrk_all$DCWRK, "label") <- "DV Combined labour market status of Main and Partner"
table(dcwrk_all$DCWRK, dcwrk_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dcwrk_all <- dcwrk_all %>% select(MCSID, SWEEP, DCWRK)
dcwrk_all <- dcwrk_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))
attr(dcwrk_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dcwrk_all, file = file.path(temp_data_fdv, "DCWRK.Rds"))

#5, save working memory
rm(dcwrk_all, temporary)