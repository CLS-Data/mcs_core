# MCS Cognitive Variables. Total of 47 variables (12+17+15+3)

# MCS 1 – age 9 months
# 	Developmental Milestones (12 variables)
# MCS 2 - age 3
# 	Bracken School Readiness Assessment-Revised (BSRA-R) with all subcategories (17 variables)
# MCS 2, 3, 4, 5 - (ages 3, 5, 7, 11)
# 	BAS II: 
# 		Naming Vocabulary in MCS 2 and 3 (3 variables)
# 		Pattern Construction in MCS 3 and 4  (3 variables)
#     Picture Similarities in MCS 3 only (3 variables)
# 		Word Reading in MCS 4 only (3 variables)
# 		Verbal Similarities in MCS 5 only (3 variables)
# MCS 4 - age 7 
# 	NFER Progress in Maths (3 variables)
# MCS 6 - age 14
# 	APU Vocabulary Test of CM (Word activity score out of 20)	

# References: *https://cls.ucl.ac.uk/wp-content/uploads/2017/07/MCS-data-note-20131-Test-Scores-Roxanne-Connelly.pdf
#https://www.closer.ac.uk/wp-content/uploads/250820-Guide-to-cognitive-measures-in-five-British-birth-cohorts.pdf
#https://closer.ac.uk/cross-study-data-guides/cognitive-measures-guide/mcs-cognition/
  
# Name and label of variables: 
#	SMIL	:	Developmental milestones: smiles
#	SITU	:	Developmental milestones: sits up
#	STAN	:	Developmental milestones: stands up holding on
#	HAND	:	Developmental milestones: hands together
#	GRAB	:	Developmental milestones: grabs objects
#	PICK	:	Developmental milestones: holds small objects
#	PTOY	:	Developmental milestones: passes a toy
#	WALK	:	Developmental milestones: take child to park or playground
#	GIVE	:	Developmental milestones: gives toy
#	WAVE	:	Developmental milestones: waves bye-bye
#	ARMS	:	Developmental milestones: extend arms for being picked up
#	NODS	:	Developmental milestones: nods for yes
#	DCOSC	:	DV Bracken: Colours Raw Score
#	DCMAS	:	DV Bracken: Colours % mastery
#	DLESC	:	DV Bracken: Letters Raw Score
#	DLMAS	:	DV Bracken: Letters % mastery
#	DNOSC	:	DV Bracken: Numbers Raw Score
#	DNMAS	:	DV Bracken: Numbers % mastery
#	DSZSC	:	DV Bracken: Sizes Raw Score
#	DSMAS	:	DV Bracken: Size % mastery
#	DCMSC	:	DV Bracken: Comparisons Raw Score
#	DOMAS	:	DV Bracken: Comparisons % mastery
#	DSHSC	:	DV Bracken: Shapes Raw Score
#	DHMAS	:	DV Bracken: Shapes % mastery
#	DBSRC	:	DV Bracken: School Readiness Composite
#	DSRCM	:	DV Bracken: School Readiness Composite % mastery
#	DSRCS	:	DV Bracken: School Readiness Composit Standard Score
#	DSRCP	:	DV Bracken: School Readiness Composite Percentile
#	DSRCN	:	DV Bracken:School Readiness Comp Normativ Classificatn
#	DNVRS	:	DV BAS Naming Vocabulary - Raw Scores
#	DNVAB	:	DV BAS Naming Vocabulary - Ability Scores
#	DNVTS	:	DV BAS Naming Vocabulary - T-Scores
#	DPCRS	:	DV BAS Pattern Construction - Raw Scores
#	DPCAB	:	DV BAS Pattern Construction - Ability Scores
#	DPCTS	:	DV BAS Pattern Construction - T Scores
#	DPSRS	:	DV BAS Picture Similarities - Raw Scores
#	DPSAB	:	DV BAS Picture Similarities - Ability Scores
#	DPSTS	:	DV BAS Picture Similarities - T Scores
#	DWRRS	:	DV BAS Word Reading - Raw Scores
#	DWRAB	:	DV BAS Word Reading - Ability Scores
#	DWRTS	:	DV BAS Word Reading - T Scores
#	DVSRS	:	DV BAS Verbal Similarities - Raw Scores
#	DVSAB	:	DV BAS Verbal Similarities - Ability Scores
#	DVSTS	:	DV BAS Verbal Similarities - T Scores
#	CMTOTSCOR	:	DV NFER Maths Test  (Total Raw Score)
#	CMATHS7SC	:	DV NFER Maths Test (Raw score scaled to original test out of 28 marks)
#	CMATHS7SA	:	DV NFER Maths Test (Standardised Age Score based on standardisation in 2004)
#	CWRDSC	:	DV APU Vocabulary Test of CM (Word activity score out of 20)

#1, Extract variables from raw MCS data
cognitive_mcs1 <- read_dta(file.path(mcs1, "mcs1_parent_cm_interview.dta")) %>%
  filter(AELIG00 == 1) %>%
  mutate(SWEEP = 1) %>%
  mutate(CNUM = ACNUM00) %>%
  rename(HAND = ACHAND00, GRAB = ACGRAB00, PICK = ACPICK00, PTOY = ACPTOY00,
    SITU = ACSITU00, STAN = ACSTAN00, WALK = ACWALK00, SMIL = ACSMIL00,
    GIVE = ACGIVE00, WAVE = ACWAVE00, ARMS = ACARMS00, NODS = ACNODS00) %>%
  select(MCSID, CNUM, SWEEP, HAND, GRAB, PICK, PTOY, SITU, STAN, WALK, SMIL, GIVE, WAVE, ARMS, NODS)

cognitive_mcs2 <- read_dta(file.path(mcs2, "mcs2_cm_cognitive_assessment.dta")) %>%
  mutate(SWEEP = 2) %>%
  mutate(CNUM = BCNUM00) %>%
  rename(DCOSC = BDCOSC00, DLESC = BDLESC00, DNOSC = BDNOSC00, DSZSC = BDSZSC00,
         DCMSC = BDCMSC00, DSHSC = BDSHSC00, DBSRC = BDBSRC00, DCMAS = BDCMAS00,
         DLMAS = BDLMAS00, DNMAS = BDNMAS00, DSMAS = BDSMAS00, DOMAS = BDOMAS00,
         DHMAS = BDHMAS00, DSRCM = BDSRCM00, DSRCS = BDSRCS00, DSRCP = BDSRCP00, DSRCN = BDSRCN00) %>%
  select(MCSID, CNUM, SWEEP, BDBASR00, BDBASA00, BDBAST00, DBSRC, DSRCM,
         DSRCS, DSRCP, DSRCN, DCOSC, DCMAS, DLESC, DLMAS,
         DNOSC, DNMAS, DSZSC, DSMAS, DCMSC, DOMAS, DSHSC, DHMAS)

cognitive_mcs3 <- read_dta(file.path(mcs3, "mcs3_cm_cognitive_assessment.dta")) %>%
  mutate(SWEEP = 3) %>%
  mutate(CNUM = CCNUM00) %>%
  select(MCSID, CNUM, SWEEP, CCNSCO00, CCNVABIL, CCNVTSCORE, CCCSCO00, CCPCABIL, 
         CCPCTSCORE, CCPSCO00, CCPSABIL, CCPSTSCORE)

cognitive_mcs4 <- read_dta(file.path(mcs4, "mcs4_cm_cognitive_assessment.dta")) %>%
  mutate(SWEEP = 4) %>%
  mutate(CNUM = DCNUM00) %>%
  rename(CMTOTSCOR = DCMTOTSCOR, CMATHS7SC = DCMATHS7SC, CMATHS7SA = DCMATHS7SA) %>%
  select(MCSID, CNUM, SWEEP, DCTOTS00, DCPCAB00, DCPCTS00, DCWRSC00, 
         DCWRAB00, DCWRSD00, CMTOTSCOR, CMATHS7SC, CMATHS7SA)

cognitive_mcs5 <- read_dta(file.path(mcs5, "mcs5_cm_derived.dta")) %>%
  mutate(SWEEP = 5) %>%
  mutate(CNUM = ECNUM00) %>%
  select(MCSID, CNUM, SWEEP, EVSRAW, EVSABIL, EVSTSCO)

cognitive_mcs6 <- read_dta(file.path(mcs6, "mcs6_cm_derived.dta")) %>%
  mutate(SWEEP = 6) %>%
  mutate(CNUM = FCNUM00) %>%
  select(MCSID, CNUM, SWEEP, FCWRDSC)

datasets <- list(cognitive_mcs1, cognitive_mcs2, cognitive_mcs3,
                 cognitive_mcs4, cognitive_mcs5, cognitive_mcs6)
cognitive_all <- bind_rows(datasets)
table(cognitive_all$SWEEP, useNA = "ifany")

#3, Generate new variable in a longitudinal format
cognitive_all <- cognitive_all %>%
  zap_labels(cognitive_all) %>%
  mutate(DNVRS = case_when(
    SWEEP == 2 ~ BDBASR00,
    SWEEP == 3 ~ CCNSCO00,
    .default = NA_real_)) %>%
  mutate(DNVAB = case_when(
    SWEEP == 2 ~ BDBASA00,
    SWEEP == 3 ~ CCNVABIL,
    .default = NA_real_)) %>%
  mutate(DNVTS = case_when(
    SWEEP == 2 ~ BDBAST00,
    SWEEP == 3 ~ CCNVTSCORE,
    .default = NA_real_)) %>%
  mutate(DPCRS = case_when(
    SWEEP == 3 ~ CCCSCO00,
    SWEEP == 4 ~ DCTOTS00,
    .default = NA_real_)) %>%
  mutate(DPCAB = case_when(
    SWEEP == 3 ~ CCPCABIL,
    SWEEP == 4 ~ DCPCAB00,
    .default = NA_real_)) %>%
  mutate(DPCTS = case_when(
    SWEEP == 3 ~ CCPCTSCORE,
    SWEEP == 4 ~ DCPCTS00,
    .default = NA_real_)) %>%
  mutate(DPSRS = case_when(
    SWEEP == 3 ~ CCPSCO00,
    .default = NA_real_)) %>%
  mutate(DPSAB = case_when(
    SWEEP == 3 ~ CCPSABIL,
    .default = NA_real_)) %>%
  mutate(DPSTS = case_when(
    SWEEP == 3 ~ CCPSTSCORE,
    .default = NA_real_)) %>%
  mutate(DWRRS = case_when(
    SWEEP == 4 ~ DCWRSC00,
    .default = NA_real_)) %>%
  mutate(DWRAB = case_when(
    SWEEP == 4 ~ DCWRAB00,
    .default = NA_real_)) %>%
  mutate(DWRTS = case_when(
    SWEEP == 4 ~ DCWRSD00,
    .default = NA_real_))%>%
  mutate(DVSRS = case_when(
    SWEEP == 5 ~ EVSRAW,
    .default = NA_real_)) %>%
  mutate(DVSAB = case_when(
    SWEEP == 5 ~ EVSABIL,
    .default = NA_real_)) %>%
  mutate(DVSTS = case_when(
    SWEEP == 5 ~ EVSTSCO,
    .default = NA_real_)) %>%
  mutate(CWRDSC = case_when(
    SWEEP == 6 ~ FCWRDSC,
    .default = NA_real_))

attr(cognitive_all$HAND, "label") <- "Developmental milestones: hands together"
attr(cognitive_all$GRAB, "label") <- "Developmental milestones: grabs objects"
attr(cognitive_all$PICK, "label") <- "Developmental milestones: holds small objects"
attr(cognitive_all$PTOY, "label") <- "Developmental milestones: passes a toy"
attr(cognitive_all$SITU, "label") <- "Developmental milestones: sits up"
attr(cognitive_all$STAN, "label") <- "Developmental milestones: stands up holding on"
attr(cognitive_all$WALK, "label") <- "Developmental milestones: take child to park or playground"
attr(cognitive_all$SMIL, "label") <- "Developmental milestones: smiles"
attr(cognitive_all$GIVE, "label") <- "Developmental milestones: gives toy"
attr(cognitive_all$WAVE, "label") <- "Developmental milestones: waves bye-bye"
attr(cognitive_all$ARMS, "label") <- "Developmental milestones: extend arms for being picked up"
attr(cognitive_all$NODS, "label") <- "Developmental milestones: nods for yes"
attr(cognitive_all$DNVRS, "label") <- "DV BAS Naming Vocabulary - Raw Scores"
attr(cognitive_all$DNVAB, "label") <- "DV BAS Naming Vocabulary - Ability Scores"
attr(cognitive_all$DNVTS, "label") <- "DV BAS Naming Vocabulary - T-Scores"
attr(cognitive_all$DPCRS, "label") <- "DV BAS Pattern Construction - Raw Scores"
attr(cognitive_all$DPCAB, "label") <- "DV BAS Pattern Construction - Ability Scores"
attr(cognitive_all$DPCTS, "label") <- "DV BAS Pattern Construction - T-Scores"
attr(cognitive_all$DPSRS, "label") <- "DV BAS Picture Similarities - Raw Scores"
attr(cognitive_all$DPSAB, "label") <- "DV BAS Picture Similarities - Ability Scores"
attr(cognitive_all$DPSTS, "label") <- "DV BAS Picture Similarities - T-Scores"
attr(cognitive_all$DWRRS, "label") <- "DV BAS Word Reading - Raw Scores"
attr(cognitive_all$DWRAB, "label") <- "DV BAS Word Reading - Ability Scores"
attr(cognitive_all$DWRTS, "label") <- "DV BAS Word Reading - T-Scores"
attr(cognitive_all$DVSRS, "label") <- "DV BAS Verbal Similarities - Raw Scores"
attr(cognitive_all$DVSAB, "label") <- "DV BAS Verbal Similarities - Ability Scores"
attr(cognitive_all$DVSTS, "label") <- "DV BAS Verbal Similarities - T-Scores"
attr(cognitive_all$CMTOTSCOR, "label") <- "DV NFER Maths Test  (Total Raw Score)"
attr(cognitive_all$CMATHS7SC, "label") <- "DV NFER Maths Test (Raw score scaled to original test out of 28 marks)"
attr(cognitive_all$CMATHS7SA, "label") <- "DV NFER Maths Test (Standardised Age Score based on standardisation in 2004)"
attr(cognitive_all$CWRDSC, "label") <- "DV APU Vocabulary Test of CM (Word activity score out of 20)"

cognitive_all <- cognitive_all %>%
  mutate(SITU = labelled(
    SITU,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(STAN = labelled(
    STAN,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(HAND = labelled(
    HAND,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(PICK = labelled(
    PICK,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(PTOY = labelled(
    PTOY,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(WALK = labelled(
    WALK,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(GIVE = labelled(
    GIVE,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(WAVE = labelled(
    WAVE,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(ARMS = labelled(
    ARMS,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(NODS = labelled(
    NODS,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(DCOSC = labelled(
    DCOSC,
    labels = c("Not carried out" = -7, "Not applicable" = -1)
  )) %>%
  mutate(DCMAS = labelled(
    DCMAS,
    labels = c("Not carried out" = -7, "Not applicable" = -1)
  )) %>%
  mutate(DLESC = labelled(
    DLESC,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DLMAS = labelled(
    DLMAS,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DNOSC = labelled(
    DNOSC,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DNMAS = labelled(
    DNMAS,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DSZSC = labelled(
    DSZSC,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DSMAS = labelled(
    DSMAS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DCMSC = labelled(
    DCMSC,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DOMAS = labelled(
    DOMAS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DSHSC = labelled(
    DSHSC,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DHMAS = labelled(
    DHMAS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DBSRC = labelled(
    DBSRC,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Not applicable" = -1)
  )) %>%
  mutate(DSRCM = labelled(
    DSRCM,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DSRCS = labelled(
    DSRCS,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Age unknown" = -3, "Not applicable" = -1)
  )) %>%
  mutate(DSRCP = labelled(
    DSRCP,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Age unknown" = -3, "Not applicable" = -1)
  )) %>%
  mutate(DSRCN = labelled(
    DSRCN,
    labels = c("Not carried out" = -7, "Sub-test not completed" = -4, "Age unknown" = -3, "Not applicable" = -1)
  )) %>%
  mutate(DNVRS = labelled(
    DNVRS,
    labels = c("Ended early" = -8, "Not carried out" = -7, "Not administered" = -6, "Not applicable" = -1)
  )) %>%
  mutate(DNVAB = labelled(
    DNVAB,
    labels = c("Ended early" = -8, "Not carried out" = -7, "Not administered" = -6, "Not applicable" = -1)
  )) %>%
  mutate(DNVTS = labelled(
    DNVTS,
    labels = c("Ended early" = -8, "Not carried out" = -7, "Not administered" = -6, "Not applicable" = -1)
  )) %>%
  mutate(DPCRS = labelled(
    DPCRS,
    labels = c("Refusal" = -9, "Don't know" = -8, "Not applicable" = -1)
  )) %>%
  mutate(DPCAB = labelled(
    DPCAB,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DPCTS = labelled(
    DPCTS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DPSRS = labelled(
    DPSRS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DWRRS = labelled(
    DWRRS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DWRAB = labelled(
    DWRAB,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DWRTS = labelled(
    DWRTS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DVSRS = labelled(
    DVSRS,
    labels = c("Invalid due to routing error" = -2, "Not applicable" = -1)
  )) %>%
  mutate(DVSAB = labelled(
    DVSAB,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(DVSTS = labelled(
    DVSTS,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(CMTOTSCOR = labelled(
    CMTOTSCOR,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(CMATHS7SC = labelled(
    CMATHS7SC,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(CMATHS7SA = labelled(
    CMATHS7SA,
    labels = c("Not applicable" = -1)
  )) %>%
  mutate(CWRDSC = labelled(
    CWRDSC,
    labels = c("Software error/respondent completed wrong activity" = -3, "Not applicable" = -1)
  ))

#4, save temporal data 
cognitive_all <- cognitive_all %>% select(SWEEP, MCSID, CNUM, SMIL, SITU, STAN, HAND, GRAB, PICK, PTOY,
                                          WALK, GIVE, WAVE, ARMS, NODS, DCOSC, DCMAS, DLESC, DLMAS, DNOSC,
                                          DNMAS, DSZSC, DSMAS, DCMSC, DOMAS, DSHSC, DHMAS, DBSRC, DSRCM, DSRCS,
                                          DSRCP, DSRCN, DNVRS, DNVAB, DNVTS, DPCRS, DPCAB, DPCTS, DPSRS, DPSAB,
                                          DPSTS, DWRRS, DWRAB, DWRTS, DVSRS, DVSAB, DVSTS, CMTOTSCOR, CMATHS7SC,
                                          CMATHS7SA, CWRDSC)

cognitive_all <- cognitive_all  %>%
  mutate(SWEEP = labelled(SWEEP,labels = c( "MCS1" = 1, "MCS2" = 2, "MCS3" = 3, "MCS4" = 4, "MCS5" = 5, "MCS6" = 6)))

cognitive_all <- cognitive_all %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
attr(cognitive_all$SWEEP, "label") <- "MCS Sweep"
saveRDS(cognitive_all, file = file.path(temp_data_cdv, "COGNITIVE.Rds"))

#5, save working memory
rm(cognitive_all, cognitive_mcs1, cognitive_mcs2, cognitive_mcs3, cognitive_mcs4, cognitive_mcs5, cognitive_mcs6, datasets)