# DOEDP: DV OECD Below 60% median indicator  

#1, Extract variables from raw MCS data
doedp_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  doedp_all <- bind_rows(doedp_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
doedp_all <- doedp_all %>%
  zap_labels(DOEDP) %>%
  mutate(DOEDP = case_when(
    SWEEP == 1 ~ ADOEDP00,
    SWEEP == 2 ~ BDOEDP00,
    SWEEP == 3 ~ CDOEDP00,
    SWEEP == 4 ~ DDOEDP00,
    SWEEP == 5 ~ EOEDP000,
    SWEEP == 6 ~ FOEDP000,
    SWEEP == 7 ~ -1,
    .default = NA_real_))

doedp_all <- doedp_all %>%
  mutate(DOEDP = labelled(
    DOEDP,
    labels = c(
      "Refusal"           = -9,
      "Don't know"        = -8,
      "Not Applicable"    = -1,
      "Above 60% median"  = 0,
      "Below 60% median"  = 1
    )
  ))
attr(doedp_all$DOEDP, "label") <- "DV OECD Below 60% median indicator"
table(doedp_all$DOEDP, doedp_all$SWEEP, useNA = "ifany")

#4, save temporal data 
doedp_all <- doedp_all %>% select(MCSID, SWEEP, DOEDP)
doedp_all <- doedp_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(doedp_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(doedp_all, file = file.path(temp_data_fdv, "DOEDP.Rds"))

#5, save working memory
rm(doedp_all, temporary)