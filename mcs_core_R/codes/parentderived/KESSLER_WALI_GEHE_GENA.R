#WALI:	Respondent's Life Satisfaction (Main Interviewee)
#GEHE:	Respondent's general health (4 categories, Main Interviewee)
#GENA:	Respondent's general health (5 categories, Main Interviewee)
#KESSLER:	DV Kessler (Main Interviewee)
#PHDE:	Kessler item: How often respondent felt depressed in last 30 days (Main Interviewee)
#PHHO:	Kessler item: How often felt hopeless in last 30 days (Main Interviewee)
#PHRF:	Kessler item: How often felt restless/fidgety in last 30 days (Main Interviewee)
#PHEE:	Kessler item: How often felt everything an effort in last 30 days (Main Interviewee)
#PHWO:	Kessler item: How often felt worthless in last 30 days (Main Interviewee)
#PHNE:	Kessler item: How often felt nervous in last 30 days (Main Interviewee) 

#1, Extract variables from raw MCS data
kessler_hhgrid_mcs1 <- read_dta(file.path(mcs1, "mcs1_hhgrid.dta")) %>%
  filter(AELIG00 != -1) %>%
  select(MCSID, APNUM00, AELIG00, ARESP00, AHPSEX00, AHPAGE00, AHCREL00, AHPJOB00)
kessler_interview_mcs1 <- read_dta(file.path(mcs1, "mcs1_parent_interview.dta")) %>%
  select(MCSID, APNUM00, AELIG00, APFCIN00, APSMUS0A, APWALI00, APGEHE00)
kessler_mcs1 <- kessler_interview_mcs1 %>%
  left_join(kessler_hhgrid_mcs1, by = c("MCSID", "APNUM00")) %>%
  select(-AELIG00.y) %>%
  rename(ELIG00 = AELIG00.x) %>%
  rename(PNUM00 = APNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 1) %>%
  mutate(APWALI00 = case_when(
    APWALI00 == 11 ~ -8,
    TRUE ~ APWALI00)) 

kessler_hhgrid_mcs2 <- read_dta(file.path(mcs2, "mcs2_hhgrid.dta")) %>%
  filter(BELIG00 != -1) %>%
  select(MCSID, BPNUM00, BELIG00, BRESP00, BHPSEX00, BHPAGE00, BHCREL00, BHPJOB00)
kessler_interview_mcs2 <- read_dta(file.path(mcs2, "mcs2_parent_interview.dta")) %>%
  select(MCSID, BPNUM00, BELIG00, BPFCIN00, BPSMUS0A, BPWALI00, BPGEHE00, BPPHDE00, BPPHHO00,
         BPPHRF00, BPPHEE00, BPPHWO00, BPPHNE00)
kessler_mcs2 <- kessler_interview_mcs2 %>%
  left_join(kessler_hhgrid_mcs2, by = c("MCSID", "BPNUM00")) %>%
  select(-BELIG00.y) %>%
  rename(ELIG00 = BELIG00.x) %>%
  rename(PNUM00 = BPNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 2) %>%
  mutate(BPWALI00 = case_when(
    BPWALI00 == 11 ~ -8,
    BPWALI00 == -2 ~ -8,
    TRUE ~ BPWALI00)) %>%
  mutate(BHCREL00 = case_when(
    BHCREL00 == -2 ~ -8,
    TRUE ~ BHCREL00)) 

kessler_hhgrid_mcs3 <- read_dta(file.path(mcs3, "mcs3_hhgrid.dta")) %>%
  filter(CELIG00 != -1) %>%
  select(MCSID, CPNUM00, CELIG00, CRESP00, CHPSEX00, CHPAGE00, CHCREL00, CHPJOB00)
kessler_interview_mcs3 <- read_dta(file.path(mcs3, "mcs3_parent_interview.dta")) %>%
  select(MCSID, CPNUM00, CELIG00, CPFCIN00, CPSMUS0A, CPWALI00, CPGENA00, CPPHDE00, CPPHHO00,
         CPPHRF00, CPPHEE00, CPPHWO00, CPPHNE00)
kessler_mcs3 <- kessler_interview_mcs3 %>%
  left_join(kessler_hhgrid_mcs3, by = c("MCSID", "CPNUM00")) %>%
  select(-CELIG00.y) %>%
  rename(ELIG00 = CELIG00.x) %>%
  rename(PNUM00 = CPNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 3) %>%
  mutate(CPWALI00 = case_when(
    CPWALI00 == 11 ~ -8,
    TRUE ~ CPWALI00)) 

kessler_hhgrid_mcs4 <- read_dta(file.path(mcs4, "mcs4_hhgrid.dta")) %>%
  filter(DELIG00 != -1) %>%
  select(MCSID, DPNUM00, DELIG00, DRESP00, DHPSEX00, DHPAGE00, DHCREL00, DHPJOB00)
kessler_interview_mcs4 <- read_dta(file.path(mcs4, "mcs4_parent_interview.dta")) %>%
  select(MCSID, DPNUM00, DELIG00, DPFCIN00, DPSMUS0A, DPWALI00, DPGENA00, DPPHDE00, DPPHHO00,
         DPPHRF00, DPPHEE00, DPPHWO00, DPPHNE00)
kessler_mcs4 <- kessler_interview_mcs4 %>%
  left_join(kessler_hhgrid_mcs4, by = c("MCSID", "DPNUM00")) %>%
  select(-DELIG00.y) %>%
  rename(ELIG00 = DELIG00.x) %>%
  rename(PNUM00 = DPNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 4) %>%
  mutate(DPWALI00 = case_when(
    DPWALI00 == 11 ~ -8,
    TRUE ~ DPWALI00)) 

kessler_hhgrid_mcs5 <- read_dta(file.path(mcs5, "mcs5_hhgrid.dta")) %>%
  select(MCSID, EPNUM00, EELIG00, ERESP00, EPSEX0000, EPAGE0000, ECREL0000, EPJOB0000)
kessler_interview_mcs5 <- read_dta(file.path(mcs5, "mcs5_parent_interview.dta")) %>%
  select(MCSID, EPNUM00, EELIG00, EPFCIN00, EPSMUS0A, EPWALI00, EPGENA00, EPPHDE00, EPPHHO00,
         EPPHRF00, EPPHEE00, EPPHWO00, EPPHNE00)
kessler_mcs5 <- kessler_interview_mcs5 %>%
  left_join(kessler_hhgrid_mcs5, by = c("MCSID", "EPNUM00")) %>%
  select(-EELIG00.y) %>%
  rename(ELIG00 = EELIG00.x) %>%
  rename(PNUM00 = EPNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 5) %>%
  mutate(EPWALI00 = case_when(
    EPWALI00 == 11 ~ 10,
    TRUE ~ EPWALI00)) %>%
  mutate(ECREL0000 = case_when(
    ECREL0000 == -1 ~ -8,
    TRUE ~ ECREL0000)) 

kessler_mcs6 <- read_dta(file.path(mcs6, "mcs6_parent_interview.dta")) %>%
  select(MCSID, FPNUM00, FELIG00, FRESP00, FPFCIN00, FPPAGE00, FPPSEX00,
         FPCREL00, FPPJOB00, FPSMUS0A, FPPHAC00, FPPHDE00, FPPHHO00, FPPHRF00,
         FPPHEE00, FPPHWO00, FPPHNE00, FPGENA00) %>%
  rename(ELIG00 = FELIG00) %>%
  rename(PNUM00 = FPNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 6) %>%
  mutate(FPCREL00 = case_when(
    FPCREL00 == -1 ~ -8,
    TRUE ~ FPCREL00)) 

kessler_hhgrid_mcs7 <- read_dta(file.path(mcs7, "mcs7_hhgrid.dta")) %>%
  filter(GPNUM00 != -1) %>%
  select(MCSID, GELIG00, GPNUM00, GHPAGE00, GHPSEX00, GHCREL00, GHPJOB00)
kessler_interview_mcs7 <- read_dta(file.path(mcs7, "mcs7_parent_interview.dta")) %>%
  select(MCSID, GPNUM00, GPVERSION1_B, GPFCIN00, GPPDHE00, GPPHHO00, GPPHRF00, GPPHEE00, GPPHWO00, GPPHNE00, GPGENA00)
kessler_mcs7 <- kessler_interview_mcs7 %>%
  left_join(kessler_hhgrid_mcs7, by = c("MCSID", "GPNUM00")) %>%
  rename(ELIG00 = GELIG00) %>%
  rename(PNUM00 = GPNUM00) %>%
  filter(ELIG00 == 1|ELIG00 == 2) %>%
  zap_labels() %>%
  mutate(SWEEP = 7) %>%
  mutate(GPPDHE00 = case_when(
    GPPDHE00 == 7 ~ -9,
    GPPDHE00 == 8 ~ -1,
    TRUE ~ GPPDHE00)) %>%
  mutate(GPPHHO00 = case_when(
    GPPHHO00 == 7 ~ -9,
    GPPHHO00 == 8 ~ -1,
    TRUE ~ GPPHHO00)) %>%
  mutate(GPPHRF00 = case_when(
    GPPHRF00 == 7 ~ -9,
    GPPHRF00 == 8 ~ -1,
    TRUE ~ GPPHRF00)) %>%
  mutate(GPPHEE00 = case_when(
    GPPHEE00 == 7 ~ -9,
    GPPHEE00 == 8 ~ -1,
    TRUE ~ GPPHEE00)) %>%
  mutate(GPPHWO00 = case_when(
    GPPHWO00 == 7 ~ -9,
    GPPHWO00 == 8 ~ -1,
    TRUE ~ GPPHWO00)) %>%
  mutate(GPPHNE00 = case_when(
    GPPHNE00 == 7 ~ -9,
    GPPHNE00 == 8 ~ -1,
    TRUE ~ GPPHNE00)) %>%
  mutate(GPGENA00 = case_when(
    GPGENA00 == 6 ~ -8,
    GPGENA00 == 7 ~ -9,
    GPGENA00 == 8 ~ -1,
    TRUE ~ GPGENA00)) 

datasets <- list(kessler_mcs1, kessler_mcs2, kessler_mcs3, kessler_mcs4, kessler_mcs5, kessler_mcs6, kessler_mcs7)
kessler_all <- bind_rows(datasets)
table(kessler_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed

#3, Generate new variable in a longitudinal format
kessler_all <- kessler_all %>%
  mutate(PHDE = case_when(
    SWEEP == 2 ~ BPPHDE00,
    SWEEP == 3 ~ CPPHDE00,
    SWEEP == 4 ~ DPPHDE00,
    SWEEP == 5 ~ EPPHDE00,
    SWEEP == 6 ~ FPPHDE00,
    SWEEP == 7 ~ GPPDHE00,
    .default = NA_real_)) %>%
  mutate(PHHO = case_when(
    SWEEP == 2 ~ BPPHHO00,
    SWEEP == 3 ~ CPPHHO00,
    SWEEP == 4 ~ DPPHHO00,
    SWEEP == 5 ~ EPPHHO00,
    SWEEP == 6 ~ FPPHHO00,
    SWEEP == 7 ~ GPPHHO00,
    .default = NA_real_)) %>%
  mutate(PHRF = case_when(
    SWEEP == 2 ~ BPPHRF00,
    SWEEP == 3 ~ CPPHRF00,
    SWEEP == 4 ~ DPPHRF00,
    SWEEP == 5 ~ EPPHRF00,
    SWEEP == 6 ~ FPPHRF00,
    SWEEP == 7 ~ GPPHRF00,
    .default = NA_real_)) %>%
  mutate(PHEE = case_when(
    SWEEP == 2 ~ BPPHEE00,
    SWEEP == 3 ~ CPPHEE00,
    SWEEP == 4 ~ DPPHEE00,
    SWEEP == 5 ~ EPPHEE00,
    SWEEP == 6 ~ FPPHEE00,
    SWEEP == 7 ~ GPPHEE00,
    .default = NA_real_)) %>%
  mutate(PHWO = case_when(
    SWEEP == 2 ~ BPPHWO00,
    SWEEP == 3 ~ CPPHWO00,
    SWEEP == 4 ~ DPPHWO00,
    SWEEP == 5 ~ EPPHWO00,
    SWEEP == 6 ~ FPPHWO00,
    SWEEP == 7 ~ GPPHWO00,
    .default = NA_real_)) %>%
  mutate(PHNE = case_when(
    SWEEP == 2 ~ BPPHNE00,
    SWEEP == 3 ~ CPPHNE00,
    SWEEP == 4 ~ DPPHNE00,
    SWEEP == 5 ~ EPPHNE00,
    SWEEP == 6 ~ FPPHNE00,
    SWEEP == 7 ~ GPPHNE00,
    .default = NA_real_)) %>%
  mutate(CREL = case_when(
    SWEEP == 1 ~ AHCREL00,
    SWEEP == 2 ~ BHCREL00,
    SWEEP == 3 ~ CHCREL00,
    SWEEP == 4 ~ DHCREL00,
    SWEEP == 5 ~ ECREL0000,
    SWEEP == 6 ~ FPCREL00,
    SWEEP == 7 ~ GHCREL00,
    .default = NA_real_)) %>%
  mutate(PSEX = case_when(
    SWEEP == 1 ~ AHPSEX00,
    SWEEP == 2 ~ BHPSEX00,
    SWEEP == 3 ~ CHPSEX00,
    SWEEP == 4 ~ DHPSEX00,
    SWEEP == 5 ~ EPSEX0000,
    SWEEP == 6 ~ FPPSEX00,
    SWEEP == 7 ~ GHPSEX00,
    .default = NA_real_)) %>%
  mutate(PSEX = case_when(
    PHNE == 0 ~ -8,
    PHNE == NA ~ -8,
    TRUE ~ PSEX)) %>%
  mutate(WALI = case_when(
    SWEEP == 1 ~ APWALI00,
    SWEEP == 2 ~ BPWALI00,
    SWEEP == 3 ~ CPWALI00,
    SWEEP == 4 ~ DPWALI00,
    SWEEP == 5 ~ EPWALI00,
    .default = NA_real_)) %>%
  mutate(GEHE = case_when(
    SWEEP == 1 ~ APGEHE00,
    SWEEP == 2 ~ BPGEHE00,
    .default = NA_real_)) %>%
  mutate(GENA = case_when(
    SWEEP == 3 ~ CPGENA00,
    SWEEP == 4 ~ DPGENA00,
    SWEEP == 5 ~ EPGENA00,
    SWEEP == 6 ~ FPGENA00,
    SWEEP == 7 ~ GPGENA00,
    .default = NA_real_))

kessler_all <- kessler_all %>%
  mutate(PHDE_AUX = case_when(
    PHDE == -9 ~ NA,
    PHDE == -8 ~ NA,
    PHDE == -1 ~ NA,
    PHDE == 1 ~ 4,
    PHDE == 2 ~ 3,
    PHDE == 3 ~ 2,
    PHDE == 4 ~ 1,
    PHDE == 5 ~ 0,
    PHDE == 6 ~ NA,
    PHDE == 8 ~ NA,
    TRUE ~ PHDE))  %>%
  mutate(PHHO_AUX = case_when(
    PHHO == -9 ~ NA,
    PHHO == -8 ~ NA,
    PHHO == -1 ~ NA,
    PHHO == 1 ~ 4,
    PHHO == 2 ~ 3,
    PHHO == 3 ~ 2,
    PHHO == 4 ~ 1,
    PHHO == 5 ~ 0,
    PHHO == 6 ~ NA,
    PHHO == 8 ~ NA,
    TRUE ~ PHHO))  %>%
  mutate(PHRF_AUX = case_when(
    PHRF == -9 ~ NA,
    PHRF == -8 ~ NA,
    PHRF == -1 ~ NA,
    PHRF == 1 ~ 4,
    PHRF == 2 ~ 3,
    PHRF == 3 ~ 2,
    PHRF == 4 ~ 1,
    PHRF == 5 ~ 0,
    PHRF == 6 ~ NA,
    PHRF == 8 ~ NA,
    TRUE ~ PHRF))  %>%
  mutate(PHEE_AUX = case_when(
    PHEE == -9 ~ NA,
    PHEE == -8 ~ NA,
    PHEE == -1 ~ NA,
    PHEE == 1 ~ 4,
    PHEE == 2 ~ 3,
    PHEE == 3 ~ 2,
    PHEE == 4 ~ 1,
    PHEE == 5 ~ 0,
    PHEE == 6 ~ NA,
    PHEE == 8 ~ NA,
    TRUE ~ PHEE))  %>%
  mutate(PHWO_AUX = case_when(
    PHWO == -9 ~ NA,
    PHWO == -8 ~ NA,
    PHWO == -1 ~ NA,
    PHWO == 1 ~ 4,
    PHWO == 2 ~ 3,
    PHWO == 3 ~ 2,
    PHWO == 4 ~ 1,
    PHWO == 5 ~ 0,
    PHWO == 6 ~ NA,
    PHWO == 8 ~ NA,
    TRUE ~ PHWO))  %>%
  mutate(PHNE_AUX = case_when(
    PHNE == -9 ~ NA,
    PHNE == -8 ~ NA,
    PHNE == -1 ~ NA,
    PHNE == 1 ~ 4,
    PHNE == 2 ~ 3,
    PHNE == 3 ~ 2,
    PHNE == 4 ~ 1,
    PHNE == 5 ~ 0,
    PHNE == 6 ~ NA,
    PHNE == 8 ~ NA,
    TRUE ~ PHNE))

kessler_all <- kessler_all %>%
  mutate(KESSLER = NA_real_) %>%
  mutate(KESSLER = PHDE_AUX + PHHO_AUX + PHRF_AUX + PHEE_AUX + PHWO_AUX + PHNE_AUX, na.rm = TRUE)

# Identify valid values (excluding -1)
valid_levels <- sort(unique(kessler_all$KESSLER[!kessler_all$KESSLER %in% c(-1)]))
valid_labels <- as.character(valid_levels)

# Combine all levels and labels
all_levels <- c(valid_levels, -1)
all_labels <- c(valid_labels, "Not applicable")

# Attach labels without converting to factor
kessler_all <- kessler_all %>%
  mutate(KESSLER = labelled(KESSLER, labels = setNames(all_levels, all_labels)))

val_labels(kessler_all$KESSLER)
table(kessler_all$KESSLER, kessler_all$SWEEP, useNA = "ifany")  

vars_to_label <- c("PHDE", "PHHO", "PHRF", "PHEE", "PHWO", "PHNE")

# Define the common value labels
ph_labels <- c(
  "Refusal"               = -9,
  "Don't know"            = -8,
  "Not Applicable"        = -1,
  "All of the time"       = 1,
  "Most of the time"      = 2,
  "Some of the time"      = 3,
  "A little of the time"  = 4,
  "None of the time"      = 5,
  "Can't say"             = 6
)

# Loop through each variable and apply labelled()
for (var in vars_to_label) {
  kessler_all <- kessler_all %>%
    mutate(!!sym(var) := labelled(.data[[var]], labels = ph_labels))
}

kessler_all <- kessler_all %>%
  mutate(CREL = labelled(
    CREL,
    labels = c(
      "Refusal"                         = -9,
      "Don't know"                      = -8,
      "Not Applicable"                  = -1,
      "Husband/Wife"                    = 1,
      "Partner/Cohabitee"               = 2,
      "Natural son/daughter"            = 3,
      "Adopted son/daughter"            = 4,
      "Foster son/daughter"             = 5,
      "Step-son/step-daughter"          = 6,
      "Natural parent"                  = 7,
      "Adoptive parent"                 = 8,
      "Foster parent"                   = 9,
      "Step-parent/partner of parent"   = 10,
      "Natural brother/Natural sister"  = 11,
      "Half-brother/Half-sister"        = 12,
      "Step-brother/Step-sister"        = 13,
      "Adopted brother/Adopted sister"  = 14,
      "Foster brother/Foster sister"    = 15,
      "Grandchild"                      = 16,
      "Grandparent"                     = 17,
      "Nanny/au pair"                   = 18,
      "Other relative"                  = 19,
      "Other non-relative"              = 20,
      "Self"                            = 96
    )
  ))

kessler_all <- kessler_all %>%
  mutate(
    PSEX = labelled(PSEX, labels = c(
      "Refusal" = -9,
      "Don't know" = -8,
      "Not Applicable" = -1,
      "Male" = 1,
      "Female" = 2
    )),
    
    WALI = labelled(WALI, labels = c(
      "Refusal" = -9,
      "Don't know" = -8,
      "Not Applicable" = -1,
      "Completely dissatisfied" = 1,
      "2" = 2,
      "3" = 3,
      "4" = 4,
      "5" = 5,
      "6" = 6,
      "7" = 7,
      "8" = 8,
      "9" = 9,
      "Completely satisfied" = 10
    )),
    
    GEHE = labelled(GEHE, labels = c(
      "Refusal" = -9,
      "Don't know" = -8,
      "Not Applicable" = -1,
      "Excellent" = 1,
      "Good" = 2,
      "Fair" = 3,
      "Poor" = 4
    )),
    
    GENA = labelled(GENA, labels = c(
      "Refusal" = -9,
      "Don't know" = -8,
      "Not Applicable" = -1,
      "Excellent" = 1,
      "Very Good" = 2,
      "Good" = 3,
      "Fair" = 4,
      "Poor" = 5
    ))
  )

attr(kessler_all$PHDE, "label") <- "Kessler item: How often respondent felt depressed in last 30 days (Main Interviewee)"
attr(kessler_all$PHHO, "label") <- "Kessler item: How often felt hopeless in last 30 days (Main Interviewee)"
attr(kessler_all$PHRF, "label") <- "Kessler item: How often felt restless/fidgety in last 30 days (Main Interviewee)"
attr(kessler_all$PHEE, "label") <- "Kessler item: How often felt everything an effort in last 30 days (Main Interviewee)"
attr(kessler_all$PHWO, "label") <- "Kessler item: How often felt worthless in last 30 days (Main Interviewee)"
attr(kessler_all$PHNE, "label") <- "Kessler item: How often felt nervous in last 30 days (Main Interviewee)"
attr(kessler_all$KESSLER, "label") <- "DV Kessler (Main Interviewee)"
attr(kessler_all$CREL, "label") <- "Relationship to Cohort Member"
attr(kessler_all$PSEX, "label") <- "Person Sex"
attr(kessler_all$WALI, "label") <- "Respondent's Life Satisfaction (Main Interviewee)"
attr(kessler_all$GEHE, "label") <- "Respondent's general health (4 categories, Main Interviewee)"
attr(kessler_all$GENA, "label") <- "Respondent's general health (5 categories, Main Interviewee)"
attr(kessler_all$PNUM00, "label") <- "Person number within an MCS family data (excl Cohort Members, see CNUM)"

table(kessler_all$PHDE, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$PHHO, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$PHRF, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$PHEE, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$PHWO, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$PHNE, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$KESSLER, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$CREL, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$PSEX, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$WALI, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$GEHE, kessler_all$SWEEP, useNA = "ifany")
table(kessler_all$GENA, kessler_all$SWEEP, useNA = "ifany")

#4, save temporal data 
kessler_all <- kessler_all %>% select(MCSID, PNUM00, ELIG00, SWEEP, CREL, PSEX,
                                      PHDE, PHHO, PHRF, PHEE, PHWO, PHNE, KESSLER, WALI, GEHE, GENA) %>%
  filter(ELIG00 == 1)
kessler_all  %>% group_by(MCSID, SWEEP, PNUM00) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)
kessler_all <- kessler_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(kessler_all$SWEEP, "label") <- "MCS Sweep"
kessler_all <- kessler_all %>%
  mutate(ELIG00  = factor(ELIG00, levels = c(-1, 1, 2, 3, 4),
                          labels = c("Not Applicable", 
                                     "Main Interview", "Partner Interview",
                                     "Proxy Partner Interview", "Not eligible for interview")))
attr(kessler_all$ELIG00, "label") <- "Eligibility for survey: Whether resp eligible for role of Main /(Proxy)Partner"
kessler_all <- kessler_all %>% select(-PNUM00, -ELIG00, -CREL, -PSEX)
kessler_all  %>% group_by(MCSID, SWEEP) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)
saveRDS(kessler_all, file = file.path(temp_data_pdv, "KESSLER_WALI_GEHE_GENA.Rds"))

#5, save working memory
rm(kessler_all, kessler_mcs1, kessler_mcs2, kessler_mcs3, kessler_mcs4, kessler_mcs5, kessler_mcs6, kessler_mcs7, datasets,
   kessler_hhgrid_mcs1, kessler_hhgrid_mcs2, kessler_hhgrid_mcs3, kessler_hhgrid_mcs4, kessler_hhgrid_mcs5, kessler_hhgrid_mcs7,
   kessler_interview_mcs1, kessler_interview_mcs2, kessler_interview_mcs3, kessler_interview_mcs4, kessler_interview_mcs5, kessler_interview_mcs7)