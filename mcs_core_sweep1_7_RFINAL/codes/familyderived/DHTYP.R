# DHTYP: DV Parents/Carers in Household   

#1, Extract variables from raw MCS data
dhtyp_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_family_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i)
  dhtyp_all <- bind_rows(dhtyp_all, temporary)}

#2, Change/recode/edit variables if needed
dhtyp_all <- dhtyp_all %>%
  zap_labels(dhtyp_all$ADHTYP00) %>%
  mutate(
    ADHTYP00 = case_when(
      ADHTYP00 == NA ~ -1,
      ADHTYP00 == 6 ~ 8,
      ADHTYP00 == 7 ~ 10,
      ADHTYP00 == 8 ~ 11,
      ADHTYP00 == 9 ~ 12,
      ADHTYP00 == 10 ~ 15,
      ADHTYP00 == 11 ~ 16,
      ADHTYP00 == 12 ~ 21,
      ADHTYP00 == 13 ~ 20,
      TRUE ~ ADHTYP00))

#3, Generate new variable in a longitudinal format
dhtyp_all <- dhtyp_all %>%
  mutate(DHTYP = case_when(
    SWEEP == 1 ~ ADHTYP00,
    SWEEP == 2 ~ BDHTYP00,
    SWEEP == 3 ~ CDHTYP00,
    SWEEP == 4 ~ DDHTYP00,
    SWEEP == 5 ~ EHTYP00,
    SWEEP == 6 ~ FDHTYP00,
    SWEEP == 7 ~ GDHTYP00,
    .default = NA_real_)) %>%
  mutate(
    DHTYP = case_when(
      DHTYP == -1 ~ -8,
      TRUE ~ DHTYP))

dhtyp_all <- dhtyp_all %>%
  mutate(
    DHTYP = labelled(
      DHTYP,
      labels = c(
        "Refusal"                                       = -9,
        "Don't know"                                    = -8,
        "Not Applicable"                                = -1,
        "Both natural parents"                          = 1,
        "Natural mother and step-parent"                = 2,
        "Natural mother and other parent/carer"         = 3,
        "Natural mother and adoptive parent"            = 4,
        "Natural father and step-parent"                = 5,
        "Natural father and other parent/carer"         = 6,
        "Natural father and adoptive parent"            = 7,
        "Two adoptive parents"                          = 8,
        "Adoptive mother and other parent/carer"        = 9,
        "Two foster parents"                            = 10,
        "Two grandparents"                              = 11,
        "Grandmother and other parent/carer"            = 12,
        "Grandfather and other parent/carer"            = 13,
        "Two other parents"                             = 14,
        "Natural mother only"                           = 15,
        "Natural father only"                           = 16,
        "Adoptive mother only"                          = 17,
        "Adoptive father only"                          = 18,
        "Step mother only"                              = 19,
        "Grandmother only"                              = 20,
        "Other parent/carer only (foster/sib/rel)"      = 21,
        "Step father only"                              = 22,
        "Unknown parent types"                          = 23,
        "Grandfather only"                              = 24,
        "Adoptive mother and step parent"               = 25,
        "Two step-parents"                              = 26
      )
    )
  )

attr(dhtyp_all$DHTYP, "label") <- "DV Parents/Carers in Household"
table(dhtyp_all$DHTYP, dhtyp_all$SWEEP, useNA = "ifany")

#4, save temporal data 
dhtyp_all <- dhtyp_all %>% select(MCSID, SWEEP, DHTYP)
dhtyp_all <- dhtyp_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

attr(dhtyp_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(dhtyp_all, file = file.path(temp_data_fdv, "DHTYP.Rds"))

#5, save working memory
rm(dhtyp_all, temporary)