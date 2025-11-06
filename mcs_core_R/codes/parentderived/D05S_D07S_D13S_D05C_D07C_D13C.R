#D05S:	DV Respondent NS-SEC 5 classes (current job) (Main Interviewee)
#D07S:	DV Respondent NS-SEC 7 classes  (current job) (Main Interviewee)
#D13S:	DV Respondent NS-SEC major categories (current job) (Main Interviewee)
#D05C:	DV Respondent NS-SEC 5 classes (last known job) (Main Interviewee)
#D07C:	DV Respondent NS-SEC 7 classes (last known job) (Main Interviewee)
#D13C:	DV Respondent NS-SEC major categories (last known job) (Main Interviewee)

#1, Extract variables from raw MCS data
NSSEC_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_parent_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  NSSEC_all <- bind_rows(NSSEC_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
NSSEC_all <- NSSEC_all %>%
  zap_labels(NSSEC_all) %>%
  mutate(ELIG00 = case_when(
    SWEEP == 1 ~ AELIG00,
    SWEEP == 2 ~ BELIG00,
    SWEEP == 3 ~ CELIG00,
    SWEEP == 4 ~ DELIG00,
    SWEEP == 5 ~ EELIG00,
    SWEEP == 6 ~ FELIG00,
    .default = NA_real_)) %>%
  filter(ELIG00 == 1)

NSSEC_all %>% group_by(MCSID, SWEEP) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

NSSEC_all <- NSSEC_all %>%
  mutate(ELIG00 = factor(ELIG00, levels = c(-9, -8, -1, 1, 2, 3, 4),
                         labels = c("Refusal", "Don't know", "Not Applicable",
                                    "Main Interview", "Partner Interview",
                                    "Proxy Partner Interview", "Not eligible for interview")))
attr(NSSEC_all$ELIG00, "label") <- "Eligibility for survey: Whether resp eligible for role of Main /(Proxy)Partner"
table(NSSEC_all$ELIG00, NSSEC_all$SWEEP, useNA = "ifany")

NSSEC_all <- NSSEC_all %>%
  mutate(PNUM00 = case_when(
    SWEEP == 1 ~ APNUM00,
    SWEEP == 2 ~ BPNUM00,
    SWEEP == 3 ~ CPNUM00,
    SWEEP == 4 ~ DPNUM00,
    SWEEP == 5 ~ EPNUM00,
    SWEEP == 6 ~ FPNUM00,
    .default = NA_real_))
attr(NSSEC_all$PNUM00, "label") <- "Person number within an MCS family data (excl Cohort Members, see CNUM)"

NSSEC_all <- NSSEC_all %>%
  mutate(D05S = case_when(
    SWEEP == 1 ~ ADD05S00,
    SWEEP == 2 ~ BDD05S00,
    SWEEP == 4 ~ DDD05S00,
    SWEEP == 5 ~ ED05S00,
    SWEEP == 6 ~ FD05S00,
    .default = NA_real_))

NSSEC_all <- NSSEC_all %>%
  mutate(D05S = labelled(
    D05S,
    labels = c(
      "Refusal"              = -9,
      "Don't know"           = -8,
      "Not Applicable"       = -1,
      "Manag and profl"      = 1,
      "Intermediate"         = 2,
      "Sm emp and s-emp"     = 3,
      "Lo sup and tech"      = 4,
      "Semi-rou and routine" = 5
    )
  ))
attr(NSSEC_all$D05S, "label") <- "DV Respondent NS-SEC 5 classes (current job) (Main Interviewee)"
table(NSSEC_all$D05S, NSSEC_all$SWEEP, useNA = "ifany")

NSSEC_all <- NSSEC_all %>%
  mutate(D07S = case_when(
    SWEEP == 1 ~ ADD07S00,
    SWEEP == 2 ~ BDD07S00,
    SWEEP == 4 ~ DDD07S00,
    SWEEP == 5 ~ ED07S00,
    SWEEP == 6 ~ FD07S00,
    .default = NA_real_))

NSSEC_all <- NSSEC_all %>%
  mutate(D07S = labelled(
    D07S,
    labels = c(
      "Refusal"             = -9,
      "Don't know"          = -8,
      "Not Applicable"      = -1,
      "Hi manag/prof"       = 1,
      "Lo manag/prof"       = 2,
      "Intermediate"        = 3,
      "Small emp and s-emp" = 4,
      "Low sup and tech"    = 5,
      "Semi routine"        = 6,
      "Routine"             = 7
    )
  ))

attr(NSSEC_all$D07S, "label") <- "DV Respondent NS-SEC 7 classes (current job) (Main Interviewee)"
table(NSSEC_all$D07S, NSSEC_all$SWEEP, useNA = "ifany")

NSSEC_all <- NSSEC_all %>%
  mutate(D13S = case_when(
    SWEEP == 1 ~ ADD13S00,
    SWEEP == 2 ~ BDD13S00,
    SWEEP == 4 ~ DDD13S00,
    SWEEP == 5 ~ ED13S00,
    SWEEP == 6 ~ FD13S00,
    .default = NA_real_))

NSSEC_all <- NSSEC_all %>%
  mutate(D13S = labelled(
    D13S,
    labels = c(
      "Refusal"            = -9,
      "Don't know"         = -8,
      "Not Applicable"     = -1,
      "Large emp"          = 1,
      "Hi manag"           = 2,
      "Higher prof"        = 3,
      "Lo prof/hi tech"    = 4,
      "Lower managers"     = 5,
      "Hi supervisory"     = 6,
      "Intermediate"       = 7,
      "Small employers"    = 8,
      "Self-emp non profl" = 9,
      "Lower supervisors"  = 10,
      "Lower technical"    = 11,
      "Semi-routine"       = 12,
      "Routine"            = 13
    )
  ))

attr(NSSEC_all$D13S, "label") <- "DV Respondent NS-SEC major categories (current job) (Main Interviewee)"
table(NSSEC_all$D13S, NSSEC_all$SWEEP, useNA = "ifany")

NSSEC_all <- NSSEC_all %>%
  mutate(D05C = case_when(
    SWEEP == 1 ~ ADD05C00,
    SWEEP == 2 ~ BDD05C00,
    SWEEP == 3 ~ CDD05C00,
    SWEEP == 4 ~ DDD05C00,
    .default = NA_real_))

NSSEC_all <- NSSEC_all %>%
  mutate(D05C = labelled(
    D05C,
    labels = c(
      "Refusal"              = -9,
      "Don't know"           = -8,
      "Not Applicable"       = -1,
      "Manag and profl"      = 1,
      "Intermediate"         = 2,
      "Sm emp and s-emp"     = 3,
      "Lo sup and tech"      = 4,
      "Semi-rou and routine" = 5
    )
  ))
attr(NSSEC_all$D05C, "label") <- "DV Respondent NS-SEC 5 classes (last known job) (Main Interviewee)"
table(NSSEC_all$D05C, NSSEC_all$SWEEP, useNA = "ifany")

NSSEC_all <- NSSEC_all %>%
  mutate(D07C = case_when(
    SWEEP == 1 ~ ADD07C00,
    SWEEP == 2 ~ BDD07C00,
    SWEEP == 3 ~ CDD07C00,
    SWEEP == 4 ~ DDD07C00,
    .default = NA_real_))

NSSEC_all <- NSSEC_all %>%
  mutate(D07C = labelled(
    D07C,
    labels = c(
      "Refusal"            = -9,
      "Don't know"         = -8,
      "Not Applicable"     = -1,
      "Hi manag/prof"      = 1,
      "Lo manag/prof"      = 2,
      "Intermediate"       = 3,
      "Small emp and s-emp"= 4,
      "Low sup and tech"   = 5,
      "Semi routine"       = 6,
      "Routine"            = 7
    )
  ))

attr(NSSEC_all$D07C, "label") <- "DV Respondent NS-SEC 7 classes (last known job) (Main Interviewee)"
table(NSSEC_all$D07C, NSSEC_all$SWEEP, useNA = "ifany")

NSSEC_all <- NSSEC_all %>%
  mutate(D13C = case_when(
    SWEEP == 1 ~ ADD13C00,
    SWEEP == 2 ~ BDD13C00,
    SWEEP == 3 ~ CDD13C00,
    SWEEP == 4 ~ DDD13C00,
    .default = NA_real_))

NSSEC_all <- NSSEC_all %>%
  mutate(D13C = labelled(
    D13C,
    labels = c(
      "Refusal"              = -9,
      "Don't know"           = -8,
      "Not Applicable"       = -1,
      "Large emp"            = 1,
      "Hi manag"             = 2,
      "Higher prof"          = 3,
      "Lo prof/hi tech"      = 4,
      "Lower managers"       = 5,
      "Hi supervisory"       = 6,
      "Intermediate"         = 7,
      "Small employers"      = 8,
      "Self-emp non profl"   = 9,
      "Lower supervisors"    = 10,
      "Lower technical"      = 11,
      "Semi-routine"         = 12,
      "Routine"              = 13
    )
  ))
attr(NSSEC_all$D13C, "label") <- "DV Respondent NS-SEC major categories (last known job) (Main Interviewee)"
table(NSSEC_all$D13C, NSSEC_all$SWEEP, useNA = "ifany")

#4, save temporal data 
NSSEC_all <- NSSEC_all %>% select(MCSID, SWEEP, D05S, D07S, D13S, D05C, D07C, D13C)
NSSEC_all <- NSSEC_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6)))

attr(NSSEC_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(NSSEC_all, file = file.path(temp_data_pdv, "D05S_D07S_D13S_D05C_D07C_D13C.Rds"))

#5, save working memory
rm(NSSEC_all, temporary)