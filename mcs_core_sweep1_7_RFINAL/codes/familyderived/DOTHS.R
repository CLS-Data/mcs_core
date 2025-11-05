# DOTHS: DV Number of siblings of CM in HH

#1, Extract variables from raw MCS data
doths_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  doths_all <- bind_rows(doths_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
doths_all <- doths_all %>%
  zap_labels(doths_all) %>%
  mutate(DOTHS = case_when(
    SWEEP == 1 ~ ADOTHS00,
    SWEEP == 2 ~ BDOTHS00,
    SWEEP == 3 ~ CDOTHS00,
    SWEEP == 4 ~ DDOTHS00,
    SWEEP == 5 ~ EOTHS00,
    SWEEP == 6 ~ FDOTHS00,
    SWEEP == 7 ~ GDOTHS00,
    .default = NA_real_))

# Identify valid values (excluding -8 and -1)
valid_levels <- sort(unique(doths_all$DOTHS[!doths_all$DOTHS %in% c(-8, -1)]))
valid_labels <- as.character(valid_levels)

# Combine all levels and labels
all_levels <- c(valid_levels, -8, -1)
all_labels <- c(valid_labels, "Don't know", "Not applicable")

# Attach labels without converting to factor
doths_all <- doths_all %>%
  mutate(DOTHS = labelled(DOTHS, labels = setNames(all_levels, all_labels)))


attr(doths_all$DOTHS, "label") <- "DV Number of siblings of CM in HH"
table(doths_all$DOTHS, doths_all$SWEEP, useNA = "ifany")

#4, save temporal data 
doths_all <- doths_all %>% select(MCSID, SWEEP, DOTHS)
doths_all <- doths_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(doths_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(doths_all, file = file.path(temp_data_fdv, "DOTHS.Rds"))

#5, save working memory
rm(doths_all, temporary)