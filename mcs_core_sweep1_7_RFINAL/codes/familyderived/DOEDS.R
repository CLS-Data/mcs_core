# DOEDS: DV Equivalised family income OECD scores

#1, Extract variables from raw MCS data
doeds_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  doeds_all <- bind_rows(doeds_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
doeds_all <- doeds_all %>%
  zap_labels(doeds_all) %>%
  mutate(DOEDS = case_when(
    SWEEP == 1 ~ ADOEDS00,
    SWEEP == 2 ~ BDOEDS00,
    SWEEP == 3 ~ CDOEDS00,
    SWEEP == 4 ~ DDOEDS00,
    SWEEP == 5 ~ NA,
    SWEEP == 6 ~ NA,
    SWEEP == 7 ~ NA,
    .default = NA_real_))
attr(doeds_all$DOEDS, "label") <- "DV Equivalised family income OECD scores"
table(doeds_all$DOEDS, doeds_all$SWEEP, useNA = "ifany")

#4, save temporal data 
doeds_all <- doeds_all %>% select(MCSID, SWEEP, DOEDS)
doeds_all <- doeds_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

table(doeds_all$DOEDS, useNA = "ifany")
val_labels(doeds_all$DOEDS)
attr(doeds_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(doeds_all, file = file.path(temp_data_fdv, "DOEDS.Rds"))

#5, save working memory
rm(doeds_all, temporary)