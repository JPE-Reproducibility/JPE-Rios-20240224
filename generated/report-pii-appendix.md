## Appendix: Detailed PII Detection Results

*Generated on 2026-09-03 14:21:57*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Data Files

**/replication-package/replication_package/Data/carreras_2019.csv**

- Variable: `RESTRINGE_SEXO`
  - Matched terms: sex
  - Sample values: NA, SOLO DAMAS, SOLO VARONES

**/replication-package/replication_package/Data/carreras_2020.csv**

- Variable: `RESTRINGE_SEXO`
  - Matched terms: sex
  - Sample values: NA, 2, 1

**/replication-package/replication_package/Data/carreras_2022.csv**

- Variable: `RESTRINGE_SEXO`
  - Matched terms: sex
  - Sample values: , F, M

**/replication-package/replication_package/Data/carreras_2023.csv**

- Variable: `RESTRINGE_SEXO`
  - Matched terms: sex
  - Sample values: SOLO MUJER, , SOLO HOMBRE

**/replication-package/replication_package/Data/data_2020.csv**

- Variable: `LOCAL_EDUCACIONAL`
  - Matched terms: loc
  - Sample values: 1381, 1100, 4184
- Variable: `PERSONAS_ESTUDIAN_SUP`
  - Matched terms: son
  - Sample values: 3, 16, 2
- Variable: `PREPARACION_ESTUDIO_PERSONAL`
  - Matched terms: son
  - Sample values: S, N
- Variable: `PUBLICA_NOMBRE_SOCIAL`
  - Matched terms: social
  - Sample values: __REPLICATION_MISSING__, S, N
- Variable: `RESTRINGE_SEXO_mp`
  - Matched terms: sex
  - Sample values: __REPLICATION_MISSING__
- Variable: `SEXO`
  - Matched terms: sex
  - Sample values: 2, 1
- Variable: `reason_error_no_1`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, Falta de acceso a la información., 
- Variable: `reason_error_no_2`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , La información es poco clara.
- Variable: `reason_error_no_3`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , No recuerdo haber visto mensajes de advertencia.
- Variable: `reason_error_yes`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , Pensé que existía la posibilidad de que la postulación a dichas carreras fuera considerada, pese a que no cumplía con alguno de los  requisitos de postulación.
- Variable: `reason_strategic`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, I did apply., Too low prob.
- Variable: `reason_strategic_1`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, SÍ, postulé a mi carrera ideal en mi primera preferencia., 
- Variable: `reason_strategic_2`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , La probabilidad de que quede seleccionado en esa carrera es muy baja.
- Variable: `reason_strategic_3`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , La carrera me parece demasiado difícil y no creo que vaya a terminarla en caso de matricularme.
- Variable: `reason_strategic_4`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , No tengo los recursos económicos para pagar el costo de la carrera.
- Variable: `reason_strategic_5`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , Para incluir mi carrera ideal tendría que excluir alguna de las carreras de mi postulación.
- Variable: `reason_strategic_6`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , La decisión de dónde postular no dependió completamente de mí, y fue influenciada por otras personas (familia, amigos u otros).
- Variable: `reason_strategic_7`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , Pensé que al incluir esta carrera en mi lista de preferencias habría reducido mis posibilidades de admisión en las demás carreras.
- Variable: `reason_strategic_8`
  - Matched terms: son
  - Sample values: __REPLICATION_MISSING__, , Dado que mi probabilidad de admisión es muy baja, prefiero no postular y quedar seleccionado en una preferencia reportada más alta.
- Variable: `strata_sexo`
  - Matched terms: sex
  - Sample values: 2, 1

**/replication-package/replication_package/Data/data_2022.csv**

- Variable: `COD_SEXO`
  - Matched terms: sex
  - Sample values: 2, 1
- Variable: `LOCAL_EDUCACIONAL`
  - Matched terms: loc
  - Sample values: 747, 1960, 1339
- Variable: `PERSONAS_ESTUDIAN_SUP`
  - Matched terms: son
  - Sample values: 16, 1, 2
- Variable: `SEXO`
  - Matched terms: sex
  - Sample values: 2, 1
- Variable: `local_educacional_int`
  - Matched terms: loc
  - Sample values: 747, 1960, 1339
- Variable: `reason_mistake`
  - Matched terms: son
  - Sample values: Al no afectar el resto de mi postulación, incluí las carreras de mi preferencia aunque no cumpliera con todos los requisitos para cada una de ellas., Pensé que existía la posibilidad de que la postulación a dichas carreras fuera considerada, pese a que no cumplía con alguno de los  requisitos de postulación., Espero un cambio en alguno(s) de mis puntajes lo que me permitiría cumplir con los requisitos de postulación.
- Variable: `strata_sexo`
  - Matched terms: sex
  - Sample values: 2, 1

**/replication-package/replication_package/Data/data_2023.csv**

- Variable: `COD_SEXO`
  - Matched terms: sex
  - Sample values: 1, 2
- Variable: `LOCAL_EDUCACIONAL`
  - Matched terms: loc
  - Sample values: 3970, 1960, 4040
- Variable: `SEXO`
  - Matched terms: sex
  - Sample values: 1, 2
- Variable: `sexo_int`
  - Matched terms: sex
  - Sample values: F, M
- Variable: `strata_sexo`
  - Matched terms: sex
  - Sample values: 1, 2

### Code Files

**/replication-package/replication_package/Makefile**

- Line 11: loc
  ```
  #   make all STATA=/usr/local/stata18/stata-mp
  ```
- Line 44: loc
  ```
  found=$$(ls -d /usr/local/stata*/stata-?? /opt/stata*/stata-?? 2>/dev/null); \
  ```
- Line 100: second
  ```
  # in the script, so this runs anywhere in about a second.
  ```

**/replication-package/replication_package/R/analysis_bcr.R**

- Line 8: lat
  ```
  ##  - LATE on predicted yearly income at h = 13: $86.74
  ```
- Line 13: gender
  ```
  ##    controls (gender, region, test-score strata) gives 0.178176,
  ```
- Line 22: lat
  ```
  late_h13    <- 86.74     # USD per year, per induced opener, at h = 13
  ```
- Line 29: lat
  ```
  # gains for the ~52% of students who open the platform without a reminder
  ```
- Line 31: lat
  ```
  itt_h13 <- first_stage * late_h13
  ```
- Line 35: lat
  ```
  #  - "working life": h = 13 gain persists flat through h = 47
  ```
- Line 42: name
  ```
  results <- expand.grid(horizon = names(horizons),
  ```
- Line 44: name
  ```
  cost = names(costs))
  ```
- Line 53: name
  ```
  print(format(results, digits = 4), row.names = FALSE)
  ```

**/replication-package/replication_package/R/replication.Rmd**

- Line 7: lat
  ```
  latex_engine: xelatex
  ```
- Line 134: lat
  ```
  # Return cleaned LaTeX
  ```
- Line 140: lat
  ```
  # Use paths relative to this replication package.
  ```
- Line 150: name
  ```
  d20 <- read.csv(file.path(data_dir, "data_2020.csv"), na.strings = "__REPLICATION_MISSING__", check.
  ```
- Line 161: name
  ```
  dplyr::rename(
  ```
- Line 173: name
  ```
  dplyr::rename(
  ```
- Line 196: name
  ```
  row.names = FALSE, fileEncoding = "UTF-8", sep = ";"
  ```
- Line 276: lon
  ```
  # Table 1 is written to a standalone .tex file that the paper \input's.
  ```
- Line 277: lat
  ```
  # The LaTeX scaffolding is written explicitly; the panel sample sizes and the
  ```
- Line 353: sex
  ```
  m_under <- lm(underconfidence_expost_mp ~ bias_mp_pos + bias_mp_neg + factor(strata_score) + factor(
  ```
- Line 354: sex
  ```
  m_order <- lm(ordering_expost_mp ~ bias_mp_pos + bias_mp_neg + factor(strata_score) + factor(strata_
  ```
- Line 355: sex
  ```
  m_over_all <- lm(over_confidence_expost_lower ~ bias_any_pos + bias_any_neg + factor(strata_score) +
  ```
- Line 356: sex
  ```
  m_over_bot <- lm(over_confidence_expost_lower ~ bias_bt_pos + bias_bt_neg + factor(strata_score) + f
  ```
- Line 360: lon
  ```
  # Table 2 is written to a standalone .tex file that the paper \input's.
  ```
- Line 366: lat
  ```
  type = "latex", style = "aer",
  ```
- Line 368: sex
  ```
  omit = c("strata_score", "strata_sexo", "strata_region"),
  ```
- Line 439: lat
  ```
  title = "Cumulative Distribution of Bias in Income Estimates",
  ```
- Line 441: lat
  ```
  y = "Cumulative Probability",
  ```
- Line 452: name
  ```
  ungroup() %>% mutate(pct = 100 * n / sum(n), type = "Top Reported") %>% dplyr::rename(response = inf
  ```
- Line 454: name
  ```
  ungroup() %>% mutate(pct = 100 * n / sum(n), type = "Top True") %>% dplyr::rename(response = info_in
  ```
- Line 456: name
  ```
  ungroup() %>% mutate(pct = 100 * n / sum(n), type = "Bottom Reported") %>% dplyr::rename(response = 
  ```
- Line 458: name
  ```
  ungroup() %>% mutate(pct = 100 * n / sum(n), type = "Bottom True") %>% dplyr::rename(response = info
  ```
- Line 460: name
  ```
  ungroup() %>% mutate(pct = 100 * n / sum(n), type = "Random") %>% dplyr::rename(response = info_inco
  ```
- Line 465: name
  ```
  ifelse(response == "Medianamente Informada/o", "Medium",
  ```
- Line 582: lon
  ```
  # Table A.1 is written to a standalone .tex file that the paper \input's.
  ```
- Line 584: block, loc
  ```
  # pair and a \midrule between year blocks. knitr omits the separator after
  ```
- Line 587: lat
  ```
  "latex",
  ```
- Line 590: name
  ```
  col.names = c("Year", "Group", "N", "Female", "Low-Income", "Avg. Math-Verbal", "Public", "Voucher",
  ```
- Line 593: name
  ```
  row.names = FALSE,
  ```
- Line 597: school
  ```
  add_header_above(c(" " = 3, " Demographics and Scores " = 3, "High-School Type" = 3))
  ```
- Line 619: sex
  ```
  demo_vars <- c("strata_score", "strata_egreso", "strata_sexo", "strata_region", "public", "voucher",
  ```
- Line 659: name
  ```
  dplyr::rename_with(~ str_replace(., "_0([1-9])$", "_\\1")) %>%
  ```
- Line 660: lon
  ```
  pivot_longer(
  ```
- Line 662: name
  ```
  names_to = c(".value", "preference"),
  ```
- Line 663: name
  ```
  names_pattern = "^(.*)_(\\d+)$"
  ```
- Line 691: name
  ```
  unlist(use.names = FALSE)
  ```
- Line 705: lat
  ```
  type = "latex", style = "aer", header = FALSE, digits = 3,
  ```
- Line 783: lat
  ```
  title = "Cumulative Distribution of Bias in Adm. Prob.",
  ```
- Line 785: lat
  ```
  y = "Cumulative Probability",
  ```
- Line 798: lat
  ```
  title = "Cumulative Distribution of Bias in Adm. Prob.",
  ```
- Line 800: lat
  ```
  y = "Cumulative Probability",
  ```
- Line 813: lat
  ```
  title = "Cumulative Distribution of Bias in Adm. Prob.",
  ```
- Line 815: lat
  ```
  y = "Cumulative Probability",
  ```
- Line 839: name
  ```
  unlist(use.names = FALSE)
  ```
- Line 843: lon
  ```
  # Table A.3 is written to a standalone .tex file that the paper \input's.
  ```
- Line 926: lon
  ```
  # Table A.4 is written to a standalone .tex file that the paper \input's.
  ```
- Line 927: lat
  ```
  # The LaTeX scaffolding below is written explicitly; the numeric row is
  ```
- Line 967: sex
  ```
  md <- lm(changed ~ factor(treatment) + factor(strata_sexo) + factor(strata_region) + factor(strata_s
  ```
- Line 973: sex
  ```
  ip <- lm(overall_prob_ratex_inc ~ factor(treatment) + factor(strata_sexo) + factor(strata_region) + 
  ```
- Line 983: sex
  ```
  im <- lm(improved ~ factor(treatment) + factor(strata_sexo) + factor(strata_region) + factor(strata_
  ```
- Line 989: sex
  ```
  et <- lm(entered ~ factor(treatment) + factor(strata_sexo) + factor(strata_region) + factor(strata_s
  ```
- Line 995: sex
  ```
  bp <- lm(impr_ent_persist ~ factor(treatment) + factor(strata_sexo) + factor(strata_region) + factor
  ```
- Line 1023: name
  ```
  unlist(use.names = FALSE)
  ```
- Line 1026: lat
  ```
  ```{r tabulate_placebo_results, echo=FALSE, message=FALSE, warning=FALSE, results='asis'}
  ```
- Line 1029: lat
  ```
  type = "latex",
  ```
- Line 1036: sex
  ```
  omit = c("strata_sexo", "strata_region", "strata_score", "general_message"),
  ```
- Line 1040: name
  ```
  model.names = FALSE,
  ```
- Line 1131: sex
  ```
  m2 <- lm(withdraw ~ factor(treatment) + factor(strata_sexo) + factor(strata_region) + factor(strata_
  ```
- Line 1147: sex
  ```
  withdraw ~ factor(strata_sexo) + factor(strata_region) + factor(strata_score) + any_opening | factor
  ```
- Line 1176: lat
  ```
  kable(stats, "latex",
  ```
- Line 1178: name
  ```
  col.names = c(" ", "N", "Count", "Mean", "Std. Dev."),
  ```
- Line 1190: lat
  ```
  type = "latex",
  ```
- Line 1196: sex
  ```
  omit = c("strata_sexo", "strata_region", "strata_score"),
  ```
- Line 1200: name
  ```
  model.names = FALSE,
  ```
- Line 1216: lat, son
  ```
  # Table C.3. Population comparison: RCT vs scale-up compliers
  ```
- Line 1219: son
  ```
  1. Estimate first stage take up, i.e., $E\left[D \mid Z=1, X \right], E\left[D \mid Z=0, X \right]$,
  ```
- Line 1220: son
  ```
  2. Compute complier score for each person, i.e., $\pi(X) = E\left[D \mid Z=1, X \right] - E\left[D \
  ```
- Line 1225: sex
  ```
  fs1 <- lm(any_opening ~ factor(strata_sexo) + factor(strata_region) + factor(strata_score), data = d
  ```
- Line 1226: sex
  ```
  fs0 <- lm(any_opening ~ factor(strata_sexo) + factor(strata_region) + factor(strata_score), data = d
  ```
- Line 1365: lat
  ```
  ```{r abadie_tabulate, echo=FALSE, message=FALSE, warning=FALSE}
  ```
- Line 1366: lon
  ```
  # Table C.3 is written to a standalone .tex file that the paper \input's.
  ```
- Line 1370: lat
  ```
  "latex",
  ```
- Line 1373: name
  ```
  col.names = c("Group", "N", "Female", "Low-Income", "Metro. Region", "Public", "Voucher", "GPA", "Ma
  ```
- Line 1375: name
  ```
  row.names = FALSE,
  ```
- Line 1379: school
  ```
  add_header_above(c(" " = 2, " Demographics" = 3, "High-School Type" = 2, "Scores" = 2))
  ```
- Line 1431: lat
  ```
  type = "latex",
  ```
- Line 1433: son
  ```
  title = "Comparison RCT-Openers vs. Scaleup-Compliers",
  ```
- Line 1434: son
  ```
  label = "tab: comparison openers vs compliers",
  ```
- Line 1438: sex
  ```
  omit = c("strata_sexo", "strata_region", "strata_score"),
  ```
- Line 1442: name
  ```
  model.names = FALSE,
  ```
- Line 1448: school, son
  ```
  out <- make_clean_table(out, caption = "Comparison RCT-Openers vs. Scaleup-Compliers", label = "tab:
  ```
- Line 1449: son
  ```
  writeLines(out, file.path(table_dir, "comparison_openers_vs_compliers.tex"))
  ```
- Line 1452: son
  ```
  \input{outputs/tables/comparison_openers_vs_compliers.tex}
  ```

**/replication-package/replication_package/Stata/analysis_displacement_replication.do**

- Line 109: name
  ```
  rename v221 bea
  ```
- Line 111: name
  ```
  rename codigo_carrera_assigned_int_t2t3 codcarr_assigned_intt2t3compfin
  ```
- Line 112: name
  ```
  rename codigo_carrera_assigned_int_none codcarr_assigned_intnonecompfin
  ```
- Line 196: name
  ```
  rename codcarr_assigned_intnonecompfin codigo_demre
  ```
- Line 215: name
  ```
  rename codcarr_assigned_intnonecompfin codigo_demre
  ```
- Line 275: name
  ```
  rename codcarr_assigned_intt2t3compfin codigo_demre
  ```
- Line 313: name
  ```
  rename full_reg      full_reg_intt2t3compfin
  ```
- Line 314: name
  ```
  rename full_pace     full_pace_intt2t3compfin
  ```
- Line 315: name
  ```
  rename full_bea      full_bea_intt2t3compfin
  ```
- Line 316: name
  ```
  rename last_from_t0  last_from_t0_intt2t3compfin
  ```
- Line 317: name
  ```
  rename last_from_t1  last_from_t1_intt2t3compfin
  ```
- Line 318: name
  ```
  rename last_from_t2  last_from_t2_intt2t3compfin
  ```
- Line 319: name
  ```
  rename last_from_t3  last_from_t3_intt2t3compfin
  ```
- Line 320: name
  ```
  rename last_from_t4  last_from_t4_intt2t3compfin
  ```
- Line 321: name
  ```
  rename last_control  last_control_intt2t3compfin
  ```
- Line 322: name
  ```
  rename cutoff_reg    cutoff_reg_intt2t3compfin
  ```
- Line 510: lon
  ```
  reshape long new_, i(mrun) j(rank)
  ```
- Line 512: name
  ```
  rename new_ codigo_demre
  ```
- Line 545: name
  ```
  rename codigo_carrera_assigned_fin codigo_demre
  ```
- Line 563: name
  ```
  rename codigo_carrera_assigned_fin codigo_demre
  ```

**/replication-package/replication_package/Stata/analysis_policy_replication.do**

- Line 33: name
  ```
  rename any_opening open
  ```
- Line 129: loc
  ```
  local n = 5  // number of scalars
  ```
- Line 146: loc
  ```
  local row = 1
  ```
- Line 155: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 156: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 157: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 158: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 159: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 174: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 176: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 179: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 181: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 184: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 186: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 189: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 191: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 194: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 196: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 240: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 260: loc
  ```
  local N: di %15.0fc r(N)
  ```
- Line 263: loc
  ```
  local mean_v1: di %6.3fc r(mean)
  ```
- Line 266: loc
  ```
  local mean_v2: di %6.3fc r(mean)
  ```
- Line 269: loc
  ```
  local mean_v3: di %6.3fc r(mean)
  ```
- Line 272: loc
  ```
  local mean_v4: di %6.3fc r(mean)
  ```
- Line 275: loc
  ```
  local mean_v5: di %6.3fc r(mean)
  ```
- Line 408: loc
  ```
  local n = 4  // number of scalars
  ```
- Line 426: loc
  ```
  local row = 1
  ```
- Line 437: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 438: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 439: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 440: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 441: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 457: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 459: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 463: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 465: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 469: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 471: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 475: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 477: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 508: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 535: loc
  ```
  local m: di %6.4fc scal_`2'
  ```
- Line 536: loc
  ```
  local m_sd: di %6.4fc scal_sd_`2'
  ```
- Line 537: loc
  ```
  local m_sd= subinstr("(`m_sd')", " ", "", .)
  ```
- Line 548: loc
  ```
  local mean_m: di %6.4fc r(mean)
  ```
- Line 550: loc
  ```
  local N_m: di %15.0fc  r(N)
  ```
- Line 552: loc
  ```
  local m_F: dis scal_F_`1'
  ```
- Line 594: loc
  ```
  local varlist ///
  ```
- Line 598: loc
  ```
  foreach var of local varlist{
  ```
- Line 615: loc
  ```
  local t = 1
  ```
- Line 616: loc
  ```
  local varlist female lowinc is_from_rm ///
  ```
- Line 619: loc
  ```
  foreach var of local varlist{
  ```
- Line 620: loc
  ```
  local mean_`t': di %6.3fc scal_`var'_what
  ```
- Line 621: loc
  ```
  local sd_`t': di %6.3fc scal_`var'sd_what
  ```
- Line 622: loc
  ```
  local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
  ```
- Line 623: loc
  ```
  local cons_`t': di %6.3fc scal_`var'_dont
  ```
- Line 624: loc
  ```
  local sd_cons_`t': di %6.3fc scal_`var'sd_dont
  ```
- Line 625: loc
  ```
  local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
  ```
- Line 626: loc
  ```
  local N_`t': dis %15.0fc scal_N_`var'
  ```
- Line 628: loc
  ```
  local t = `t' + 1
  ```
- Line 650: school
  ```
  tex     & \multicolumn{3}{c}{Demographics} & \multicolumn{2}{c}{High-School Type} & \multicolumn{2}{
  ```
- Line 671: loc
  ```
  local varlist ///
  ```
- Line 675: loc
  ```
  foreach var of local varlist{
  ```
- Line 691: loc
  ```
  local t = 1
  ```
- Line 692: loc
  ```
  local varlist female lowinc is_from_rm ///
  ```
- Line 695: loc
  ```
  foreach var of local varlist{
  ```
- Line 696: loc
  ```
  local mean_`t': di %6.3fc scal_`var'_open
  ```
- Line 697: loc
  ```
  local sd_`t': di %6.3fc scal_`var'sd_open
  ```
- Line 698: loc
  ```
  local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
  ```
- Line 699: loc
  ```
  local cons_`t': di %6.3fc scal_`var'_dont
  ```
- Line 700: loc
  ```
  local sd_cons_`t': di %6.3fc scal_`var'sd_dont
  ```
- Line 701: loc
  ```
  local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
  ```
- Line 702: loc
  ```
  local N_`t': dis %15.0fc scal_N_`var'
  ```
- Line 704: loc
  ```
  local t = `t' + 1
  ```
- Line 726: school
  ```
  tex     & \multicolumn{3}{c}{Demographics} & \multicolumn{2}{c}{High-School Type} & \multicolumn{2}{
  ```
- Line 827: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 828: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 829: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 840: loc
  ```
  local m`m': di %6.4fc scal_m`m'bis_`2'
  ```
- Line 841: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'bissd_`2'
  ```
- Line 842: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 853: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 855: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 858: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 860: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 863: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 865: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 868: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 870: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 873: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 875: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 926: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 997: loc
  ```
  local m`m': di %6.4fc scal_m`m'
  ```
- Line 998: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd
  ```
- Line 999: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 1013: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 1016: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 1020: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 1023: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 1027: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 1030: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 1034: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 1037: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 1041: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 1044: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 1048: loc
  ```
  local mean_m6: di %6.4fc r(mean)
  ```
- Line 1051: loc
  ```
  local N_m6: di %15.0fc r(N)
  ```
- Line 1084: lat
  ```
  tex \item \scriptsize \textsc{Notes.} The sample considers all students who answered the questions r
  ```

**/replication-package/replication_package/Stata/analysis_rct_replication.do**

- Line 38: name
  ```
  rename income_below_median lowinc
  ```
- Line 42: name
  ```
  rename entered_enroll_same_prog ent_enroll_sameprog
  ```
- Line 84: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 87: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 90: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 93: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 96: sex
  ```
  i.strata_sexo i.general_message, robust), ///
  ```
- Line 113: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 122: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 132: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 141: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 150: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 159: loc
  ```
  local n = 10  // number of scalars
  ```
- Line 181: loc
  ```
  local row = 1
  ```
- Line 187: loc
  ```
  local row = `row' + 1
  ```
- Line 195: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 196: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 197: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 198: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 199: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 215: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 217: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 220: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 222: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 225: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 227: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 230: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 232: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 235: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 237: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 281: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 310: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 313: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 316: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 319: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 322: sex
  ```
  i.strata_sexo i.general_message, robust), ///
  ```
- Line 339: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 348: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 358: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 367: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 377: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 386: loc
  ```
  local n = 10  // number of scalars
  ```
- Line 407: loc
  ```
  local row = 1
  ```
- Line 413: loc
  ```
  local row = `row' + 1
  ```
- Line 453: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 463: name
  ```
  rename overall_prob_ratex_inc ovprob_ratex_inc
  ```
- Line 465: loc
  ```
  local varlist changed ovprob_ratex_inc improved entered $persist
  ```
- Line 466: loc
  ```
  foreach var of local varlist{
  ```
- Line 468: loc
  ```
  local scal_`var'=r(mean)
  ```
- Line 469: loc
  ```
  local scal_`var'_sd=r(sd)
  ```
- Line 470: loc
  ```
  local scal_`var'_N=r(N)
  ```
- Line 473: loc
  ```
  local scal_`var'_N_T3=r(N)
  ```
- Line 477: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 478: loc
  ```
  local scal_`var'_treat3=_b[treat3]
  ```
- Line 493: loc
  ```
  local varlist changed ovprob_ratex_inc improved entered $persist
  ```
- Line 494: loc
  ```
  foreach var of local varlist{
  ```
- Line 496: loc
  ```
  local m_`var': di %6.3fc scal_`var'_`2'
  ```
- Line 571: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 574: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 577: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 580: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 583: sex
  ```
  i.strata_sexo i.general_message, robust), ///
  ```
- Line 600: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 607: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 615: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 622: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 629: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 635: loc
  ```
  local n = 5  // number of scalars
  ```
- Line 651: loc
  ```
  local row = 1
  ```
- Line 652: loc
  ```
  local varlist treat4
  ```
- Line 655: loc
  ```
  foreach t of local varlist {
  ```
- Line 658: loc
  ```
  local row = `row' + 1
  ```
- Line 663: son
  ```
  texdoc init "tables/rct/main_comparison_t1t4_$persist_table.tex", replace force
  ```
- Line 698: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 730: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 733: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 736: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 739: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 742: sex
  ```
  i.strata_sexo i.general_message, robust), ///
  ```
- Line 760: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 769: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 779: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 788: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 797: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 806: loc
  ```
  local n = 15  // number of scalars
  ```
- Line 832: loc
  ```
  local row = 1
  ```
- Line 838: loc
  ```
  local row = `row' + 1
  ```
- Line 879: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 912: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 915: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 918: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 921: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 924: sex
  ```
  i.strata_sexo i.general_message, robust), ///
  ```
- Line 942: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 951: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 961: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 970: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 979: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 988: loc
  ```
  local n = 10  // number of scalars
  ```
- Line 1009: loc
  ```
  local row = 1
  ```
- Line 1015: loc
  ```
  local row = `row' + 1
  ```
- Line 1055: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 1086: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 1089: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 1092: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 1095: sex
  ```
  i.strata_sexo i.general_message, robust), ///
  ```
- Line 1115: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1124: sex
  ```
  i.strata_sexo ///
  ```
- Line 1134: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1143: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1151: loc
  ```
  local n = 8  // number of scalars
  ```
- Line 1170: loc
  ```
  local row = 1
  ```
- Line 1176: loc
  ```
  local row = `row' + 1
  ```
- Line 1185: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 1186: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 1187: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 1188: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 1189: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 1204: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 1206: loc
  ```
  local N_m1: di  %15.0fc r(N)
  ```
- Line 1209: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 1211: loc
  ```
  local N_m2: di %15.0fc  r(N)
  ```
- Line 1214: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 1216: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 1219: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 1221: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 1266: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 1299: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1302: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1305: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1308: sex
  ```
  i.strata_sexo, robust), ///
  ```
- Line 1325: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1334: sex
  ```
  i.strata_sexo ///
  ```
- Line 1344: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1353: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1361: loc
  ```
  local n = 8  // number of scalars
  ```
- Line 1380: loc
  ```
  local row = 1
  ```
- Line 1386: loc
  ```
  local row = `row' + 1
  ```
- Line 1395: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 1396: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 1397: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 1398: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 1399: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 1414: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 1416: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 1419: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 1421: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 1424: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 1426: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 1429: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 1431: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 1463: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 1495: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1498: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1501: sex
  ```
  i.strata_sexo, robust) , ///
  ```
- Line 1517: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1526: sex
  ```
  i.strata_sexo ///
  ```
- Line 1536: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1545: loc
  ```
  local n = 6  // number of scalars
  ```
- Line 1562: loc
  ```
  local row = 1
  ```
- Line 1568: loc
  ```
  local row = `row' + 1
  ```
- Line 1577: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 1578: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 1579: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 1580: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 1581: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 1596: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 1598: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 1601: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 1603: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 1606: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 1608: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 1640: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 1674: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1677: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1680: sex
  ```
  i.strata_sexo, robust) , ///
  ```
- Line 1696: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1705: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1714: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1723: loc
  ```
  local n = 6 // number of scalars
  ```
- Line 1741: loc
  ```
  local row = 1
  ```
- Line 1747: loc
  ```
  local row = `row' + 1
  ```
- Line 1756: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 1757: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 1758: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 1759: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 1760: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 1775: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 1777: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 1780: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 1782: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 1785: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 1787: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 1819: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 1853: sex
  ```
  i.strata_sexo, robust) ///
  ```
- Line 1856: sex
  ```
  i.strata_sexo, robust) , ///
  ```
- Line 1871: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1880: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 1889: loc
  ```
  local n = 4 // number of scalars
  ```
- Line 1905: loc
  ```
  local row = 1
  ```
- Line 1911: loc
  ```
  local row = `row' + 1
  ```
- Line 1920: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 1921: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 1922: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 1923: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 1924: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 1939: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 1941: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 1944: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 1946: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 1978: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 2032: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 2035: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 2038: sex
  ```
  i.strata_sexo i.general_message, robust) ///
  ```
- Line 2041: sex
  ```
  i.strata_sexo if general_message==1, robust) ///
  ```
- Line 2044: sex
  ```
  i.strata_sexo if general_message==2, robust), ///
  ```
- Line 2062: sex
  ```
  i.strata_sexo i.general_message, ///
  ```
- Line 2072: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2082: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 2091: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 2100: sex
  ```
  i.strata_sexo, vce(robust)
  ```
- Line 2109: loc
  ```
  local n = 10  // number of scalars
  ```
- Line 2131: loc
  ```
  local row = 1
  ```
- Line 2137: loc
  ```
  local row = `row' + 1
  ```
- Line 2146: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 2147: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 2148: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 2150: loc
  ```
  local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
  ```
- Line 2151: loc
  ```
  local m`m'_q: di %6.4fc scal_m`m'q_`2'
  ```
- Line 2167: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 2169: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 2172: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 2174: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 2177: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 2179: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 2182: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 2184: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 2187: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 2189: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 2222: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 2258: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 2267: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2277: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 2286: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 2295: sex
  ```
  i.strata_sexo i.general_message, vce(robust)
  ```
- Line 2303: loc
  ```
  local n = 10  // number of scalars
  ```
- Line 2325: loc
  ```
  local row = 1
  ```
- Line 2331: loc
  ```
  local row = `row' + 1
  ```
- Line 2340: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 2341: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 2342: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 2354: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 2356: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 2359: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 2361: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 2364: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 2366: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 2369: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 2371: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 2374: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 2376: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 2418: loc
  ```
  local varlist open  ///
  ```
- Line 2423: loc
  ```
  foreach var of local varlist{
  ```
- Line 2444: loc
  ```
  local mean_1: di %6.3fc scal_`2'_treat1
  ```
- Line 2446: loc
  ```
  local mean_`i': di %6.3fc scal_`2'_treat`i'
  ```
- Line 2447: loc
  ```
  local p_`i': di %6.3fc scal_`2'p_treat`i'
  ```
- Line 2461: loc
  ```
  local N_`i': di %15.0fc r(N)
  ```
- Line 2485: school
  ```
  add_balance "Public High school" public
  ```
- Line 2486: school
  ```
  add_balance "Voucher High school" voucher
  ```
- Line 2511: loc
  ```
  local varlist open  ///
  ```
- Line 2516: loc
  ```
  foreach var of local varlist{
  ```
- Line 2537: loc
  ```
  local mean_1: di %6.3fc scal_`2'_treat1
  ```
- Line 2539: loc
  ```
  local mean_`i': di %6.3fc scal_`2'_treat`i'
  ```
- Line 2540: loc
  ```
  local p_`i': di %6.3fc scal_`2'p_treat`i'
  ```
- Line 2554: loc
  ```
  local N_`i': di %15.0fc r(N)
  ```
- Line 2577: school
  ```
  add_balance "Public High school" public
  ```
- Line 2578: school
  ```
  add_balance "Voucher High school" voucher
  ```
- Line 2595: lat
  ```
  /*********************BALANCE Early/Late*********************/
  ```
- Line 2601: name
  ```
  rename income_below_median lowinc
  ```
- Line 2602: name
  ```
  capture rename is_from_RM is_from_rm
  ```
- Line 2606: lat
  ```
  //Use the interim GPA measure used in the original early/late balance table.
  ```
- Line 2608: name
  ```
  rename promedio_notas_int promedio_notas
  ```
- Line 2610: loc
  ```
  local varlist ///
  ```
- Line 2614: loc
  ```
  foreach var of local varlist{
  ```
- Line 2631: loc
  ```
  local t = 1
  ```
- Line 2632: loc
  ```
  local varlist female lowinc is_from_rm ///
  ```
- Line 2635: loc
  ```
  foreach var of local varlist{
  ```
- Line 2636: loc
  ```
  local mean_`t': di %6.3fc scal_`var'_inrct
  ```
- Line 2637: loc
  ```
  local sd_`t': di %6.3fc scal_`var'sd_inrct
  ```
- Line 2638: loc
  ```
  local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
  ```
- Line 2639: loc
  ```
  local cons_`t': di %6.3fc scal_`var'_outrct
  ```
- Line 2640: loc
  ```
  local sd_cons_`t': di %6.3fc scal_`var'sd_outrct
  ```
- Line 2641: loc
  ```
  local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
  ```
- Line 2642: loc
  ```
  local N_`t': dis %15.0fc scal_N_`var'
  ```
- Line 2644: loc
  ```
  local t = `t' + 1
  ```
- Line 2658: lat
  ```
  tex \caption{Balance Tests - Early \& Late Applicants}\label{tab:rct_balance_early}
  ```
- Line 2666: school
  ```
  tex     & \multicolumn{3}{c}{Demographics} & \multicolumn{2}{c}{High-School Type} & \multicolumn{2}{
  ```
- Line 2689: loc
  ```
  local varlist ///
  ```
- Line 2693: loc
  ```
  foreach var of local varlist{
  ```
- Line 2710: loc
  ```
  local t = 1
  ```
- Line 2711: loc
  ```
  local varlist female lowinc is_from_rm ///
  ```
- Line 2714: loc
  ```
  foreach var of local varlist{
  ```
- Line 2715: loc
  ```
  local mean_`t': di %6.3fc scal_`var'_open
  ```
- Line 2716: loc
  ```
  local sd_`t': di %6.3fc scal_`var'sd_open
  ```
- Line 2717: loc
  ```
  local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
  ```
- Line 2718: loc
  ```
  local cons_`t': di %6.3fc scal_`var'_dont
  ```
- Line 2719: loc
  ```
  local sd_cons_`t': di %6.3fc scal_`var'sd_dont
  ```
- Line 2720: loc
  ```
  local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
  ```
- Line 2721: loc
  ```
  local N_`t': dis %15.0fc scal_N_`var'
  ```
- Line 2723: loc
  ```
  local t = `t' + 1
  ```
- Line 2745: school
  ```
  tex     & \multicolumn{3}{c}{Demographics} & \multicolumn{2}{c}{High-School Type} & \multicolumn{2}{
  ```
- Line 2783: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2792: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2802: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2812: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2821: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2833: loc
  ```
  local m`m': di %6.4fc scal_m`m'_`2'
  ```
- Line 2834: loc
  ```
  local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
  ```
- Line 2835: loc
  ```
  local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
  ```
- Line 2846: loc
  ```
  local mean_m1: di %6.4fc r(mean)
  ```
- Line 2848: loc
  ```
  local N_m1: di %15.0fc r(N)
  ```
- Line 2851: loc
  ```
  local mean_m2: di %6.4fc r(mean)
  ```
- Line 2853: loc
  ```
  local N_m2: di %15.0fc r(N)
  ```
- Line 2856: loc
  ```
  local mean_m3: di %6.4fc r(mean)
  ```
- Line 2858: loc
  ```
  local N_m3: di %15.0fc r(N)
  ```
- Line 2861: loc
  ```
  local mean_m4: di %6.4fc r(mean)
  ```
- Line 2863: loc
  ```
  local N_m4: di %15.0fc r(N)
  ```
- Line 2866: loc
  ```
  local mean_m5: di %6.4fc r(mean)
  ```
- Line 2868: loc
  ```
  local N_m5: di %15.0fc r(N)
  ```
- Line 2911: son
  ```
  tex We report in brackets the p-values adjusted for multiple hypothesis testing following the proced
  ```
- Line 2936: sex
  ```
  i.strata_sexo i.general_message ///
  ```
- Line 2947: loc
  ```
  local m: di %6.4fc scal_`2'
  ```
- Line 2948: loc
  ```
  local m_sd: di %6.4fc scal_sd_`2'
  ```
- Line 2949: loc
  ```
  local m_sd= subinstr("(`m_sd')", " ", "", .)
  ```
- Line 2960: loc
  ```
  local mean_m: di %6.4fc r(mean)
  ```
- Line 2962: loc
  ```
  local N_m: di %15.0fc  r(N)
  ```
- Line 2964: loc
  ```
  local m_F: dis scal_F_`1'
  ```

**/replication-package/replication_package/Stata/fdr_qvalues.do**

- Line 13: name
  ```
  svmat M, names(pval)
  ```
- Line 14: name
  ```
  rename pval1 pval
  ```
- Line 24: loc
  ```
  local totalpvals = r(N)
  ```
- Line 34: loc
  ```
  local qval = 1
  ```
- Line 55: loc
  ```
  local qval = `qval' - .001
  ```

