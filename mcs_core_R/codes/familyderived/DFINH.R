# DFINH: DV Natural father in HH

#1, Extract variables from raw MCS data
dfinh_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dfinh_all <- bind_rows(dfinh_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dfinh_all <- dfinh_all %>%
  mutate(DFINH = case_when(
    SWEEP == 1 ~ ADFINH00,
    SWEEP == 2 ~ BDFINH00,
    SWEEP == 3 ~ CDFINH00,
    SWEEP == 4 ~ DDFINH00,
    SWEEP == 5 ~ EFINH00,
    SWEEP == 6 ~ FDFINH00,
    SWEEP == 7 ~ GDFINH00,
    .default = NA_real_))

dfinh_all <- dfinh_all %>%
  mutate(
    DFINH = labelled(
      DFINH,
      labels = c(
        "Refusal"                   = -9,
        "Don't know"                = -8,
        "Not Applicable"            = -1,
        "Resident in household"     = 1,
        "Not resident in household" = 2,
        "Deceased"                  = 3
      )
    )
  )
attr(dfinh_all$DFINH, "label") <- "DV Natural father in HH"
table(dfinh_all$DFINH, dfinh_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dfinh_all <- dfinh_all %>% select(MCSID, SWEEP, DFINH)
dfinh_all <- dfinh_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dfinh_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dfinh_all, file = file.path(temp_data_fdv, "DFINH.Rds"))

#5, save working memory
rm(dfinh_all, temporary)