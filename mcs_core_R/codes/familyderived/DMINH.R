# DMINH:DV Natural mother in HH

#1, Extract variables from raw MCS data
dminh_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dminh_all <- bind_rows(dminh_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dminh_all <- dminh_all %>%
  mutate(DMINH = case_when(
    SWEEP == 1 ~ ADMINH00,
    SWEEP == 2 ~ BDMINH00,
    SWEEP == 3 ~ CDMINH00,
    SWEEP == 4 ~ DDMINH00,
    SWEEP == 5 ~ EMINH00,
    SWEEP == 6 ~ FDMINH00,
    SWEEP == 7 ~ GDMINH00,
    .default = NA_real_))

dminh_all <- dminh_all %>%
  mutate(
    DMINH = labelled(
      DMINH,
      labels = c(
        "Refusal"                   = -9,
        "Don't know"               = -8,
        "Not Applicable"           = -1,
        "Resident in household"    = 1,
        "Not resident in household"= 2,
        "Deceased"                 = 3
      )
    )
  )
attr(dminh_all$DMINH, "label") <- "DV Natural father in HH"
table(dminh_all$DMINH, dminh_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dminh_all <- dminh_all %>% select(MCSID, SWEEP, DMINH)
dminh_all <- dminh_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dminh_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dminh_all, file = file.path(temp_data_fdv, "DMINH.Rds"))

#5, save working memory
rm(dminh_all, temporary)