#BWGT	:	Birth weight (Kilograms)
#BWGTC	:	DV Birth weight categories (Low, Normal, High)
#LOWBW	:	DV Low birth weight (<2.5 kg)

#1, Extract variables from raw MCS data
bwgt_mcs1 <- read_dta(file.path(mcs1, "mcs1_cm_derived.dta")) %>%
  rename(CNUM = ACNUM00) %>%
  select(MCSID, CNUM, ADBWGT00)

bwgt_mcs2 <- read_dta(file.path(mcs2, "mcs2_parent_cm_interview.dta")) %>%
  filter(BELIG00 == 1) %>%
  rename(CNUM = BCNUM00) %>%
  mutate(
    BWGT00 = if_else(BPBIWT00 == 1, BPWTKG00, NA_real_),
    BWGT00 = replace(BWGT00, BWGT00 == 0, NA),
    BWGT00 = replace(BWGT00, BWGT00 > 6.5 & BWGT00 <= 200, NA),
    lb_to_grms = if_else(BPBIWT00 == 2, BPWTLB00 * 453.592, NA_real_),
    oun_to_grms = if_else(BPBIWT00 == 2, BPWTOU00 * 28.3495, NA_real_),
    BWGT00 = if_else(BPBIWT00 == 2, round((lb_to_grms + oun_to_grms)/1000, 2), BWGT00),
    BWGT00 = replace(BWGT00, BWGT00 > 6.5 & BWGT00 <= 200, NA),
    BWGT00 = replace(BWGT00, is.na(BWGT00) & (BPBIWT00 == 1|BPBIWT00 == 2), -8)) %>%
  select(MCSID, CNUM, BWGT00)

bwgt_mcs2 %>% group_by(MCSID, CNUM) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(count > 1)

bwgt_all <- full_join(bwgt_mcs1, bwgt_mcs2, by = c("MCSID", "CNUM"))

#3, Generate new variable in a longitudinal format
bwgt_all <- bwgt_all %>% mutate(BWGT=ADBWGT00) %>%
  zap_labels() %>%
  mutate(
    BWGT = coalesce(BWGT, BWGT00),
    BWGT = replace_na(BWGT, -8),
    BWGTC = NA_real_,
    BWGTC = case_when(
      BWGT > 0 & BWGT < 2.5 ~ 1,
      BWGT >= 2.5 & BWGT < 4 ~ 2,
      BWGT >= 4 & BWGT < 10 ~ 3,
      BWGT == -8 ~ -8,
      BWGT == -1 ~ -1,
      TRUE ~ BWGTC),
    LOWBW = if_else(
      BWGTC == 1, 1, NA_real_),
    LOWBW = case_when(
      BWGTC == 2 ~ 2,
      BWGTC == 3 ~ 2,
      BWGTC == -8 ~ -8,
      BWGTC == -1 ~ -1,
      TRUE ~ LOWBW))

attr(bwgt_all$BWGT, "label") <- "Birth weight (Kilograms)"

bwgt_all <- bwgt_all %>%
  mutate(BWGT = labelled(
    BWGT,
    labels = c(
      "Don't know"     = -8,
      "Not Applicable" = -1
    )
  ))

table(bwgt_all$BWGT, useNA = "ifany")

attr(bwgt_all$BWGTC, "label") <- "DV Birth weight categories (Low, Normal, High)"

bwgt_all <- bwgt_all %>%
  mutate(BWGTC = labelled(
    BWGTC,
    labels = c(
      "Don't know"                = -8,
      "Not Applicable"           = -1,
      "Low (<2.5 kg)"            = 1,
      "Normal (>=2.5 - <4 kg)"   = 2,
      "High (>4 kg)"             = 3
    )
  ))

table(bwgt_all$BWGTC, useNA = "ifany")

attr(bwgt_all$LOWBW, "label") <- "DV Low birth weight (<2.5 kg)"

bwgt_all <- bwgt_all %>%
  mutate(LOWBW = labelled(
    LOWBW,
    labels = c(
      "Refusal"        = -9,
      "Don't know"     = -8,
      "Not Applicable" = -1,
      "Yes"            = 1,
      "No"             = 2
    )
  ))
table(bwgt_all$LOWBW, useNA = "ifany")

#4, save temporal data 
bwgt_all <- bwgt_all %>% select(MCSID, CNUM, BWGT, BWGTC, LOWBW) %>%
  mutate(CNUM = factor(CNUM, levels = c(1, 2, 3), 
                         labels = c("1st Cohort Member of the family",
                                    "2nd Cohort Member of the family",
                                    "3rd Cohort Member of the family")))
saveRDS(bwgt_all, file = file.path(temp_data_cdv, "BWGT.Rds"))

#5, save working memory
rm(bwgt_all, bwgt_mcs1, bwgt_mcs2)