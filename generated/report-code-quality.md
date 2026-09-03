## Code Quality

### R

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 156)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 168)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 202)
  → d22 %>% filter(in_rct == 0 & in_survey == 1 & !is.na(apps_fin)) %>% filter(Progress == 100 & responded_survey == 1 & apps_fin < 10 & pace != "PACE"),

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 204)
  → filter(in_rct == 1 & in_survey == 1 & !is.na(apps_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 205)
  → filter(Progress == 100 & responded_survey == 1 & apps_fin < 10 & pace != "PACE" & treatment %in% c(1, 4))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 221)
  → filter(finished == "True" & is.na(PACE) & inconsistent_type == 0 & short_list_lab == "Short-list" & rand_money == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 324)
  → filter(finished == "True" & inconsistent_type == 0 & is.na(PACE) & !is.na(mp_carr) & short_list == 1 & valid_mp == 1 & rand_money == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 333)
  → d22 %>% filter(in_rct == 0 & in_survey == 1 & !is.na(apps_fin)) %>% filter(Progress == 100 & responded_survey == 1 & apps_fin < 10 & pace != "PACE"),

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 335)
  → filter(in_rct == 1 & in_survey == 1 & !is.na(apps_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 336)
  → filter(Progress == 100 & responded_survey == 1 & apps_fin < 10 & pace != "PACE" & treatment %in% c(1, 4))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 338)
  → filter(marca_bottom_true == 25) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 449)
  → ds <- d22 %>% filter(in_survey == 1)

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 451)
  → ds %>% filter(!is.na(info_income_top_reported)) %>% group_by(info_income_top_reported) %>% tally() %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 453)
  → ds %>% filter(!is.na(info_income_top_true)) %>% group_by(info_income_top_true) %>% tally() %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 455)
  → ds %>% filter(!is.na(info_income_bottom_reported)) %>% group_by(info_income_bottom_reported) %>% tally() %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 457)
  → ds %>% filter(!is.na(info_income_bottom_true)) %>% group_by(info_income_bottom_true) %>% tally() %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 459)
  → ds %>% filter(!is.na(info_income_random_program)) %>% group_by(info_income_random_program) %>% tally() %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 503)
  → d20 %>% filter(applied_2020 == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 508)
  → d20 %>% filter(applied_2020 == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 513)
  → d20 %>% filter(finished == "True") %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 518)
  → d20 %>% filter(finished == "True") %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 523)
  → d22 %>% filter(applied_of == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 528)
  → d22 %>% filter(applied_of == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 533)
  → d22 %>% filter(in_survey == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 538)
  → d22 %>% filter(in_survey == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 543)
  → d23 %>% filter(applied_of == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 548)
  → d23 %>% filter(applied_of == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 553)
  → d23 %>% filter(in_survey_before_after == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 558)
  → d23 %>% filter(in_survey_before_after == 1) %>% dplyr::summarise(

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 622)
  → filter(finished == "True" & is.na(PACE)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 675)
  → filter(!is.na(COD_CARRERA_PREF) & COD_CARRERA_PREF > 0 & !is.na(prob)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 683)
  → filter(preference > 0 & cutoff_pref > 0) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 693)
  → lm1 <- lm(abs_bias_prob ~ avg_lm_norm + female + income_below_median + public + voucher, data = df %>% filter(preference > 0 & cutoff_pref > 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 694)
  → lm2 <- lm(abs_bias_prob ~ avg_lm_norm + female + income_below_median + public + voucher + req_knows_share + know_cutoff_all + know_cutoff_some + nw + as.factor(preference) + abs_bias_cutoff, data = df %>% filter(preference > 0 & cutoff_pref > 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 695)
  → lm3 <- lm(abs_bias_cutoff ~ avg_lm_norm + female + income_below_median + public + voucher, data = df %>% filter(preference > 0 & cutoff_pref > 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 696)
  → lm4 <- lm(abs_bias_cutoff ~ avg_lm_norm + female + income_below_median + public + voucher + req_knows_share + know_cutoff_all + know_cutoff_some + nw + as.factor(preference), data = df %>% filter(preference > 0 & cutoff_pref > 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 790)
  → data.frame(type = "Adaptive", bias = df %>% filter(pct_changed_VAC_TOT > 0.25) %>% pull(adaptive_bias_prob)),

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 791)
  → data.frame(type = "Ratex", bias = df %>% filter(pct_changed_VAC_TOT > 0.25) %>% pull(bias_prob))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 805)
  → data.frame(type = "Adaptive", bias = df %>% filter(pct_changed_VAC_TOT < -0.25) %>% pull(adaptive_bias_prob)),

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 806)
  → data.frame(type = "Ratex", bias = df %>% filter(pct_changed_VAC_TOT < -0.25) %>% pull(bias_prob))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 823)
  → tr <- lm(abs(pct_bias_income_avg_top_reported) ~ promlm_norm + female + income_below_median + public + voucher, data = ds %>% filter(in_rct == 0 | open == 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 824)
  → tt <- lm(abs(pct_bias_income_avg_top_true) ~ promlm_norm + female + income_below_median + public + voucher, data = ds %>% filter(in_rct == 0 | open == 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 825)
  → br <- lm(abs(pct_bias_income_avg_bottom_reported) ~ promlm_norm + female + income_below_median + public + voucher, data = ds %>% filter(in_rct == 0 | open == 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 826)
  → bt <- lm(abs(pct_bias_income_avg_bottom_true) ~ promlm_norm + female + income_below_median + public + voucher, data = ds %>% filter(in_rct == 0 | open == 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 827)
  → rd <- lm(abs(pct_bias_income_avg_random) ~ promlm_norm + female + income_below_median + public + voucher, data = ds %>% filter(in_rct == 0 | open == 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 830)
  → filter(in_rct == 0 | open == 0) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 902)
  → d22 %>% filter(in_rct == 0 & in_survey == 1 & !is.na(apps_fin)) %>% filter(Progress == 100 & responded_survey == 1 & apps_fin == 10 & pace != "PACE" & applied_to_top_true_fin == 1),

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 904)
  → filter(in_rct == 1 & in_survey == 1 & !is.na(apps_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 905)
  → filter(Progress == 100 & responded_survey == 1 & apps_fin == 10 & pace != "PACE" & treatment %in% c(1, 4) & applied_to_top_true_fin == 1)

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 969)
  → filter(!is.na(treatment) & in_rct == 1 & open == 0 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 970)
  → filter(!is.na(codigo_carrera_1_int) & !is.na(codigo_carrera_1_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 975)
  → filter(!is.na(treatment) & in_rct == 1 & open == 0 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 976)
  → filter(!is.na(codigo_carrera_1_int) & !is.na(codigo_carrera_1_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 985)
  → filter(!is.na(treatment) & in_rct == 1 & open == 0 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 986)
  → filter(!is.na(codigo_carrera_1_int) & !is.na(codigo_carrera_1_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 991)
  → filter(!is.na(treatment) & in_rct == 1 & open == 0 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 992)
  → filter(!is.na(codigo_carrera_1_int) & !is.na(codigo_carrera_1_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 997)
  → filter(!is.na(treatment) & in_rct == 1 & open == 0 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 998)
  → filter(!is.na(codigo_carrera_1_int) & !is.na(codigo_carrera_1_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1007)
  → filter(!is.na(treatment) & in_rct == 1 & open == 0 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1008)
  → filter(!is.na(codigo_carrera_1_int) & !is.na(codigo_carrera_1_fin)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1014)
  → filter(treatment == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1061)
  → filter(!is.na(treatment) & in_rct == 1 & open == 1 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1062)
  → filter(!is.na(codigo_carrera_1_int)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1064)
  → filter(!is.na(withdraw)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1073)
  → filter(!is.na(treatment) & in_rct == 1 & open == 1 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1074)
  → filter(!is.na(codigo_carrera_1_int)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1076)
  → filter(!is.na(withdraw)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1084)
  → d23 %>% filter(in_policy == 1 & any_opening == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1093)
  → d23 %>% filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1107)
  → filter(!is.na(treatment) & in_rct == 1 & open == 1 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1108)
  → filter(!is.na(codigo_carrera_1_int)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1115)
  → filter(in_policy == 1 & any_opening == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1124)
  → filter(!is.na(treatment) & in_rct == 1 & open == 1 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1125)
  → filter(!is.na(codigo_carrera_1_int)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1132)
  → filter(!is.na(treatment) & in_rct == 1 & open == 1 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1133)
  → filter(!is.na(codigo_carrera_1_int)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1142)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1149)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1154)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1156)
  → filter(recibe_whatsapp == 0) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1162)
  → filter(!is.na(treatment) & in_rct == 1 & open == 1 & misfit == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1163)
  → filter(!is.na(codigo_carrera_1_int)) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1168)
  → filter(treatment == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1225)
  → fs1 <- lm(any_opening ~ factor(strata_sexo) + factor(strata_region) + factor(strata_score), data = d23 %>% filter(in_policy == 1 & recibe_whatsapp == 1))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1226)
  → fs0 <- lm(any_opening ~ factor(strata_sexo) + factor(strata_region) + factor(strata_score), data = d23 %>% filter(in_policy == 1 & recibe_whatsapp == 0))

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1231)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1235)
  → filter(in_policy == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1275)
  → d22 %>% filter(open == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1292)
  → d22 %>% filter(open == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1315)
  → filter(in_policy == 1 & !is.na(weight)) %>% # remove missing weights

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1334)
  → filter(in_policy == 1 & !is.na(weight)) %>% # remove missing weights

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1402)
  → filter(open == 1) %>%

[ADVISORY] `filter(` call not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (replication.Rmd, line 1414)
  → filter(in_policy == 1 & !is.na(weight)) %>%

[ADVISORY] `merge()` called without explicit `all=`, `all.x=`, or `all.y=` argument — defaults to inner join, which may silently drop rows. (replication.Rmd, line 187)
  → dc <- merge(dc,

[ADVISORY] `merge()` called without explicit `all=`, `all.x=`, or `all.y=` argument — defaults to inner join, which may silently drop rows. (replication.Rmd, line 764)
  → cmg <- merge(c20 %>% dplyr::mutate(VACANTES_TOTALES_20 = rowSums(across(c(VAC_1SEM, VAC_2SEM, SC_1SEM, SC_2SEM)), na.rm = TRUE)) %>% dplyr::select(CODIGO, VACANTES_TOTALES_20),

[ADVISORY] `merge()` called without explicit `all=`, `all.x=`, or `all.y=` argument — defaults to inner join, which may silently drop rows. (replication.Rmd, line 1239)
  → d23_p <- merge(d23_p0 %>% dplyr::select(mrun, open_z0), d23_p1 %>% dplyr::select(mrun, open_z1), by = "mrun")

### Stata

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_displacement_replication.do, line 200)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_displacement_replication.do, line 514)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_displacement_replication.do, line 531)
  → drop if any_new==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_displacement_replication.do, line 547)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_displacement_replication.do, line 565)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_policy_replication.do, line 23)
  → keep if codigo_carrera_1_fin!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_policy_replication.do, line 24)
  → keep if codigo_carrera_1_int!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_policy_replication.do, line 25)
  → keep if in_policy==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 30)
  → keep if in_rct==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 31)
  → keep if misfit==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 32)
  → keep if codigo_carrera_1_fin!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 33)
  → keep if codigo_carrera_1_int!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 298)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 559)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 560)
  → keep if treatment == 1 | treatment == 4

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 715)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 897)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 898)
  → drop if treatment==4

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1072)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1074)
  → keep if general_message==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1285)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1287)
  → keep if general_message==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1479)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1481)
  → keep if general_message==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1660)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1662)
  → keep if general_message==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1837)
  → keep if open == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1839)
  → keep if general_message==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 1994)
  → keep if open == 1 & responded_survey == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 2235)
  → keep if open == 1 & responded_survey == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 2246)
  → drop if treat4==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 2507)
  → keep if open==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (analysis_rct_replication.do, line 2599)
  → keep if codigo_carrera_1_fin!=.

