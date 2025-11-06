#DACAQ:	DV NVQ equivalent of highest Academic qualification across previous sweeps (Main Interviewee)
#DNVQ:	DV Respondent NVQ Highest Level (all sweeps- Main Interviewee)

#1, Extract variables from raw MCS data
dacaq_dnvq_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_parent_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dacaq_dnvq_all <- bind_rows(dacaq_dnvq_all, temporary)}

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
dacaq_dnvq_all <- dacaq_dnvq_all %>%
  zap_labels(dacaq_dnvq_all) %>%
  mutate(ELIG00 = case_when(
    SWEEP == 1 ~ AELIG00,
    SWEEP == 2 ~ BELIG00,
    SWEEP == 3 ~ CELIG00,
    SWEEP == 4 ~ DELIG00,
    SWEEP == 5 ~ EELIG00,
    SWEEP == 6 ~ FELIG00,
    .default = NA_real_)) %>%
  filter(ELIG00 == 1)

dacaq_dnvq_all %>% group_by(MCSID, SWEEP) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

dacaq_dnvq_all <- dacaq_dnvq_all %>%
  mutate(ELIG00 = labelled(
    ELIG00,
    labels = c(
      "Refusal"                    = -9,
      "Don't know"                 = -8,
      "Not Applicable"             = -1,
      "Main Interview"             = 1,
      "Partner Interview"          = 2,
      "Proxy Partner Interview"    = 3,
      "Not eligible for interview" = 4
    )
  ))
attr(dacaq_dnvq_all$ELIG00, "label") <- "Eligibility for survey: Whether resp eligible for role of Main /(Proxy)Partner"
table(dacaq_dnvq_all$ELIG00, dacaq_dnvq_all$SWEEP, useNA = "ifany")

dacaq_dnvq_all <- dacaq_dnvq_all %>%
  mutate(PNUM00 = case_when(
    SWEEP == 1 ~ APNUM00,
    SWEEP == 2 ~ BPNUM00,
    SWEEP == 3 ~ CPNUM00,
    SWEEP == 4 ~ DPNUM00,
    SWEEP == 5 ~ EPNUM00,
    SWEEP == 6 ~ FPNUM00,
    .default = NA_real_))
attr(dacaq_dnvq_all$PNUM00, "label") <- "Person number within an MCS family data (excl Cohort Members, see CNUM)"

dacaq_dnvq_all <- dacaq_dnvq_all %>%
  mutate(DNVQ = case_when(
    SWEEP == 1 ~ ADDNVQ00,
    SWEEP == 2 ~ BDDNVQ00,
    SWEEP == 3 ~ CDDNVQ00,
    SWEEP == 4 ~ DDDNVQ00,
    SWEEP == 5 ~ EDNVQ00,
    SWEEP == 6 ~ FDNVQ00,
    .default = NA_real_))

dacaq_dnvq_all <- dacaq_dnvq_all %>%
  mutate(DNVQ = labelled(
    DNVQ,
    labels = c(
      "Refusal"              = -9,
      "Don't know"           = -8,
      "Not Applicable"       = -1,
      "NVQ level 1"          = 1,
      "NVQ level 2"          = 2,
      "NVQ level 3"          = 3,
      "NVQ level 4"          = 4,
      "NVQ level 5"          = 5,
      "Overseas qual only"   = 95,
      "None of these"        = 96
    )
  ))
attr(dacaq_dnvq_all$DNVQ, "label") <- "DV Respondent NVQ Highest Level (all sweeps - Main Interviewee)"
table(dacaq_dnvq_all$DNVQ, dacaq_dnvq_all$SWEEP, useNA = "ifany")

dacaq_dnvq_all <- dacaq_dnvq_all %>%
  mutate(DACAQ = case_when(
    SWEEP == 1 ~ ADACAQ00,
    SWEEP == 2 ~ BDACAQ00,
    SWEEP == 3 ~ CDACAQ00,
    SWEEP == 4 ~ DDACAQ00,
    SWEEP == 5 ~ EACAQ00,
    SWEEP == 6 ~ FDACAQ00,
    .default = NA_real_))

dacaq_dnvq_all <- dacaq_dnvq_all %>%
  mutate(DACAQ = labelled(
    DACAQ,
    labels = c(
      "Refusal"              = -9,
      "Don't know"           = -8,
      "Not Applicable"       = -1,
      "NVQ level 1"          = 1,
      "NVQ level 2"          = 2,
      "NVQ level 3"          = 3,
      "NVQ level 4"          = 4,
      "NVQ level 5"          = 5,
      "Overseas qual only"   = 95,
      "None of these"        = 96
    )
  ))
attr(dacaq_dnvq_all$DACAQ, "label") <- "DV NVQ equivalent of highest Academic qualification across previos sweeps (Main Interviewee)"
table(dacaq_dnvq_all$DACAQ, dacaq_dnvq_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dacaq_dnvq_all <- dacaq_dnvq_all %>% select(MCSID, SWEEP, DACAQ, DNVQ)
dacaq_dnvq_all <- dacaq_dnvq_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6)))
attr(dacaq_dnvq_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dacaq_dnvq_all, file = file.path(temp_data_pdv, "DACAQ_DNVQ.Rds"))

#5, save working memory
rm(dacaq_dnvq_all, temporary)