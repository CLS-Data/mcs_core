 #SDQ
#EMOTION	:	DV SDQ Emotional Symptoms (parent-reported)
#CONDUCT	:	DV SDQ Conduct Problems (parent-reported)
#HYPER	:	DV SDQ Hyperactivity/Inattention (parent-reported)
#PEER	:	DV SDQ Peer Problems (parent-reported)
#PROSOC	:	DV SDQ Prosocial (parent-reported)
#EBDTOT	:	DV SDQ Total Difficulties (parent-reported)

# Child Social Behaviour Questionnaire
#DCSBI	:	DV Child Social Behaviour Questionnaire (Independence-Self Regulation)
#DCSBE	:	DV Child Social Behaviour Questionnaire (Emotional-Dysregulation)
#DCSBC	:	DV Child Social Behaviour Questionnaire (Cooperation) 

#1, Extract variables from raw MCS data
sdq_scbq_all <- tibble()
for(i in 1:7){
  folder <- get(paste0("mcs", i))
  input_file <- file.path(folder, paste0("mcs", i, "_cm_derived.dta"))
  temporary <- read_dta(input_file) %>% mutate(SWEEP = i) %>% rename_with(~ substr(., 2, nchar(.)), ends_with("CNUM00"))
  sdq_scbq_all <- bind_rows(sdq_scbq_all, temporary)}

table(sdq_scbq_all$SWEEP, useNA = "ifany")

#2, Change/recode/edit variables if needed
sdq_scbq_all <- sdq_scbq_all %>%
  rename(DEMOTION = DDEMOTION,
         DCONDUCT = DDCONDUCT,
         DHYPER = DDHYPER,
         DPEER = DDPEER,
         DPROSOC = DDPROSOC,
         DEBDTOT = DDDEBDTOT) %>%
  rename(CNUM = CNUM00)

#3, Generate new variable in a longitudinal format
sdq_scbq_all <- sdq_scbq_all %>%
  zap_labels(sdq_scbq_all) %>%
  mutate(
    EMOTION = case_when(
      SWEEP == 2 ~ BEMOTION,
      SWEEP == 3 ~ CEMOTION,
      SWEEP == 4 ~ DEMOTION,
      SWEEP == 5 ~ EEMOTION,
      SWEEP == 6 ~ FEMOTION,
      SWEEP == 7 ~ GEMOTION,
      TRUE ~ NA_real_),
    CONDUCT = case_when(
      SWEEP == 2 ~ BCONDUCT,
      SWEEP == 3 ~ CCONDUCT,
      SWEEP == 4 ~ DCONDUCT,
      SWEEP == 5 ~ ECONDUCT,
      SWEEP == 6 ~ FCONDUCT,
      SWEEP == 7 ~ GCONDUCT,
      TRUE ~ NA_real_),
    HYPER = case_when(
      SWEEP == 2 ~ BHYPER,
      SWEEP == 3 ~ CHYPER,
      SWEEP == 4 ~ DHYPER,
      SWEEP == 5 ~ EHYPER,
      SWEEP == 6 ~ FHYPER,
      SWEEP == 7 ~ GHYPER,
      TRUE ~ NA_real_),
    PEER = case_when(
      SWEEP == 2 ~ BPEER,
      SWEEP == 3 ~ CPEER,
      SWEEP == 4 ~ DPEER,
      SWEEP == 5 ~ EPEER,
      SWEEP == 6 ~ FPEER,
      SWEEP == 7 ~ GPEER,
      TRUE ~ NA_real_),
    PROSOC = case_when(
      SWEEP == 2 ~ BPROSOC,
      SWEEP == 3 ~ CPROSOC,
      SWEEP == 4 ~ DPROSOC,
      SWEEP == 5 ~ EPROSOC,
      SWEEP == 6 ~ FPROSOC,
      SWEEP == 7 ~ GPROSOC,
      TRUE ~ NA_real_),
    EBDTOT = case_when(
      SWEEP == 2 ~ BEBDTOT,
      SWEEP == 3 ~ CEBDTOT,
      SWEEP == 4 ~ DEBDTOT,
      SWEEP == 5 ~ EEBDTOT,
      SWEEP == 6 ~ FEBDTOT,
      SWEEP == 7 ~ GEBDTOT,
      TRUE ~ NA_real_),
    DCSBI = case_when(
      SWEEP == 2 ~ BDCSBI00,
      SWEEP == 3 ~ CDCSBI00,
      SWEEP == 4 ~ DDCSBI00,
      TRUE ~ NA_real_),
    DCSBE = case_when(
      SWEEP == 2 ~ BDCSBE00,
      SWEEP == 3 ~ CDCSBE00,
      SWEEP == 4 ~ DDCSBE00,
      TRUE ~ NA_real_)) %>%
  mutate(DCSBC = ifelse(SWEEP == 4, DDCSBC00, NA_real_)) 

# for to attach labels to variables 
vars_to_label <- c("EMOTION", "CONDUCT", "HYPER", "PEER", "PROSOC", 
                   "EBDTOT", "DCSBI", "DCSBE", "DCSBC")

for (var in vars_to_label) {
  
  # Combine all levels and labels
  all_levels <- c( -9, -8, -1)
  all_labels <- c( "Refusal", "Don't know", "Not applicable")
  
  # Use := with !!sym() to programmatically assign to variable name
  sdq_scbq_all <- sdq_scbq_all %>%
    mutate(!!sym(var) := labelled(.data[[var]], labels = setNames( all_levels, all_labels)))
}

val_labels(sdq_scbq_all$EMOTION)

#sdq_scbq_all$EMOTION  
attr(sdq_scbq_all$EMOTION, "label") <- "DV SDQ Emotional Symptoms (parent-reported)"
attr(sdq_scbq_all$CONDUCT, "label") <- "DV SDQ Conduct Problems (parent-reported)"
attr(sdq_scbq_all$HYPER, "label") <- "DV SDQ Hyperactivity/Inattention (parent-reported)"
attr(sdq_scbq_all$PEER, "label") <- "DV SDQ Peer Problems (parent-reported)"
attr(sdq_scbq_all$PROSOC, "label") <- "DV SDQ Prosocial (parent-reported)"
attr(sdq_scbq_all$EBDTOT, "label") <- "DV SDQ Emotional Symptoms (parent-reported)"
attr(sdq_scbq_all$DCSBI, "label") <- "DV Child Social Behaviour Questionnaire (Independence-Self Regulation)"
attr(sdq_scbq_all$DCSBE, "label") <- "DV Child Social Behaviour Questionnaire (Emotional-Dysregulation)"
attr(sdq_scbq_all$DCSBE, "label") <- "DV Child Social Behaviour Questionnaire (Cooperation)"

table(sdq_scbq_all$DCSBI, sdq_scbq_all$SWEEP, useNA = "ifany")
table(sdq_scbq_all$DCSBE, sdq_scbq_all$SWEEP, useNA = "ifany")
table(sdq_scbq_all$DCSBE, sdq_scbq_all$SWEEP, useNA = "ifany")

#4, save temporal data 
sdq_scbq_all <- sdq_scbq_all %>% select(MCSID, CNUM, SWEEP, EMOTION, CONDUCT, HYPER,
                                        PEER, PROSOC, EBDTOT, DCSBI, DCSBE, DCSBC)

sdq_scbq_all <- sdq_scbq_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6,"MCS7" = 7)))

sdq_scbq_all <- sdq_scbq_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(sdq_scbq_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(sdq_scbq_all, file = file.path(temp_data_cdv, "SDQ_SCBQ.Rds"))

#5, save working memory
rm(sdq_scbq_all, temporary)