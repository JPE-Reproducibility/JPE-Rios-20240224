# Replication package for Information Frictions and Application Mistakes

## Software requirements

The code uses relative paths and is driven by the `Makefile` at the root of this
package; see **Scripts** below.

This package was verified end to end on Linux with **Stata 19 SE**, **R 4.5.2**,
**pandoc 3.10.2** and **TinyTeX (TeX Live 2026)**. `make all` completed successfully
and every generated table matched the paper.

Three external requirements are worth calling out because they are easy to miss:

- **pandoc** is required by `rmarkdown::render`. RStudio bundles its own copy, so this
  is invisible when working interactively and only surfaces when the package is run
  headless on a server, which is exactly what a replication check does.
- **`xelatex`** is required for the PDF render (the R Markdown header requests it).
  An HTML-only render does not need LaTeX.
- **Stata edition.** On a machine with several Stata editions installed, the licence may
  cover only one of them. A working `stata-se` can sit next to an unlicensed `stata-mp`,
  and naive auto-detection picks the wrong one. Pass `STATA=/path/to/stata-se` to `make`
  if the auto-detected binary fails.

### Stata

The Stata scripts use built-in commands (`regress`, `ivregress`, `import delimited`, and standard data-management commands) and the following user-written packages:

```stata
ssc install estout, replace
ssc install rwolf2, replace
ssc install texdoc, replace
```

`estout` provides `eststo`; `rwolf2` provides Romano–Wolf multiple-hypothesis-testing corrections; and `texdoc` writes the regression tables to LaTeX. The scripts install these packages automatically if they are missing, but installing them in advance is recommended. Internet access may be required the first time they are installed.

### R

Install the packages used by `R/replication.Rmd` with:

```r
install.packages(c(
  "dplyr", "tidyr", "magrittr", "stargazer", "ggplot2",
  "kableExtra", "stringr", "RColorBrewer", "AER",
  "rmarkdown", "knitr", "data.table"
))
```

The R Markdown header additionally requires the LaTeX packages `floatrow`, `booktabs`,
`array`, `caption`, `multirow` and `threeparttable`, normally installed through the TeX
distribution. The header also defines the `L`, `C` and `R` column types used by the
generated tables; these definitions match the paper's own preamble. The R workflow was
verified rendering to both HTML and PDF.

The package list above is sufficient to render `R/replication.Rmd`.

## Data

All data required by the runnable replication scripts are included in this package. The files are organized as follows:

### Removal of identifying information

Columns carrying identifying information were removed from the survey data. **None of them is read by any script in this package**, so no result depends on
them and the analysis is unaffected.

Removed from `data_2020.csv` (518 columns to 506):

- Qualtrics response metadata: `ipaddress`, `locationlatitude`, `locationlongitude`,
  `recordeddate`, `startdate`, `enddate`, `X_recordid`, `distributionchannel`. IP address
  combined with GPS coordinates and a response timestamp is directly identifying.
- Open-ended written answers: `reason_strategic_other`, `reason_error_yes_other`,
  `reason_error_other`, `DESC_OTRO_TIPO_CREDITO`. These ran to nearly 2,000 characters and
  many named a specific university, school or family member; combined with the school
  name, commune, sex and birth year that remain in the file they are plausibly
  re-identifying.

Removed from `data_2022.csv` (545 columns to 541): `QID87_8_TEXT`, `QID125_7_TEXT`,
`QID26_4_TEXT`, `QID27_5_TEXT`, the equivalent open-ended answers in that wave.

Nothing was removed from `data_2023.csv` or from the programme-level files.

Closed-ended survey items were **kept**, including those whose answer text is a long
sentence: `reason_strategic_1` to `_8`, `reason_mistake`, and the `QID87_*`/`QID125_*`
option columns each carry only a handful of distinct values, because they record which
fixed option a respondent selected rather than anything they typed. Short typed answers
that cannot identify anyone were also kept, including `mp_other` (a programme name),
`mp_prob_other` (a number), `OCUPACION`, `DESC_OTRO_IDIOMA` and `OTRO_JEFE_FAMILIA`.

Columns were spliced out of the source files without re-serialising them: every retained
field is byte-identical to the original, quoting included. (This matters because
`data.table::fread` distinguishes a quoted empty string from an unquoted empty field when
`""` is among its `na.strings`, and the analysis relies on that distinction.)

Student identifiers in the data are pseudonymised.

### Data

All source data are stored directly in the top-level `Data/` directory. Filenames identify the relevant application year where appropriate, and the structure keeps data independent of the software used to analyze them. The 2022 and 2023 annual files are shared by R and Stata, avoiding separate language-specific copies of the same student-level data:

- `data_2020.csv`: processed 2020 applicant/survey data used for the paper's baseline and truth-telling analyses. Missing values are encoded as `__REPLICATION_MISSING__`; `R/replication.Rmd` supplies this value through `na.strings` when importing the file.
- `carreras_2019.csv` and `carreras_2020.csv`: program-level admissions and cutoff data used in the 2020 comparisons.
- `data_2022.csv`: processed 2022 applicant, experiment, survey, application, and admissions data. It is the single annual person-level input for `R/replication.Rmd`, `Stata/analysis_rct_replication.do`, and `Stata/analysis_displacement_replication.do`.
- `data_2023.csv`: processed 2023 applicant, intervention, survey, application, and admissions data. It is the single annual person-level input for `R/replication.Rmd` and `Stata/analysis_policy_replication.do`.
- `carreras_2022.csv`: 2022 program-level capacities, admissions, cutoffs, and program characteristics used in the displacement analysis.
- `cutoffs_and_extras_intnonecompfin.dta` and `cutoffs_and_extras_intt2t3compfin.dta`: program-level cutoff and capacity information under the two assignment counterfactuals.
- `carreras_2023.csv`: 2023 program-level admissions and program-characteristics data.

These nine files are the complete processed-data inputs for the runnable replication workflow. They are supplied as processed inputs. The preprocessing scripts that construct them from the raw administrative and survey sources are not distributed: they refer to restricted source data and machine-specific locations, and they are not needed to reproduce any result in the paper.

The three 2022 displacement program-level files cannot be combined with `data_2022.csv` without mixing student-level and program-level units of observation. The Stata scripts create working `.dta` files, temporary files, and LaTeX tables under `Stata/output`; those generated files are not source data.


## Scripts

The main analysis files are `R/replication.Rmd` and the three Stata do-files in `Stata/`.

### Running everything

From the root of this package:

```sh
make all
```

That is the whole replication. It runs the three Stata do-files in the required order,
then renders the R Markdown workflow to HTML and PDF. Other targets:

| Target | Effect |
|---|---|
| `make all` | run everything (Stata, then R) |
| `make stata` | the three Stata do-files only |
| `make r` | the R Markdown workflow and the benefit-cost calculation |
| `make clean` | delete every generated file, restoring the package to inputs only |
| `make help` | usage, plus the Stata and Rscript binaries that were detected |

Stata is auto-detected. If the wrong binary is picked, or none is found, pass the path
explicitly:

```sh
make all STATA=/usr/local/stata19/stata-se
```

Two details the `Makefile` handles that are easy to get wrong by hand. First, the order
is not arbitrary: `analysis_displacement_replication.do` reads
`Stata/output/data/data_rct.dta`, which only `analysis_rct_replication.do` produces, so
running them out of order fails in a confusing way. Second, Stata's batch mode exits `0`
even after an error, so the `Makefile` inspects each log for `r(###);` and stops the
build if it finds one. A silent Stata failure would otherwise look like success.

### Running the steps by hand

If you would rather not use `make`, open Stata, change the working directory to the
`Stata` folder, and run the scripts in this order:

1. `analysis_rct_replication.do`
2. `analysis_policy_replication.do`
3. `analysis_displacement_replication.do`

The scripts read all source data from the top-level `Data/` directory and write generated
datasets and LaTeX tables to `Stata/output`.

Then run the R workflow from the root of this package:

```sh
cd R
Rscript -e 'rmarkdown::render("replication.Rmd", output_format="html_document", output_dir="outputs", knit_root_dir=getwd())'
Rscript -e 'rmarkdown::render("replication.Rmd", output_format="pdf_document",  output_dir="outputs", knit_root_dir=getwd())'
```

The Rmd resolves its paths with `normalizePath("..")`, so it must be knitted from the
`R/` directory. The rendered documents and the standalone LaTeX tables are written to
`R/outputs`. Finally, still from the `R/` directory:

```sh
Rscript analysis_bcr.R
```

prints the benefit-cost ratios quoted in the paper (under `make` this output is saved to
`R/outputs/bcr.txt`).

## Reproducibility notes

- Run the Stata files in the order listed above. The R Markdown workflow is separate and can be rendered independently.
- Run each Stata file with the working directory set to `Stata`; otherwise its relative input and `output/` paths will not resolve correctly.
- The package's subdirectories are `R/`, `Stata/` and `Data/`. Source data belong only in `Data/`; generated files are written to `R/outputs` and `Stata/output` and can be removed at any time with `make clean`.
- The scripts may overwrite generated files in `Stata/output` and `R/outputs`. Keep a copy of prior results if you want to compare runs.
- The package includes processed data rather than the complete raw administrative and survey-data acquisition pipeline. If the package is redistributed, document any access restrictions, anonymization, transformations, and provenance for those source data.
- Environment used for the last full verification: Linux, **Stata 19 SE**, **R 4.5.2**,
  **pandoc 3.10.2**, **TinyTeX (TeX Live 2026)**, with the Stata packages `estout`,
  `rwolf2` and `texdoc` installed from SSC. `make all` exited `0`; every generated table
  matches the paper.
- The workflow is deterministic. Every `rwolf2` call sets an explicit `seed()`, and the R
  code performs no random sampling, so a rerun reproduces the tables byte for byte. This
  was checked by rerunning the whole package from a clean state on a different machine
  and diffing every generated `.tex` file.
- The PDF cited in the table map is the paper version supplied in this package: `Information_Frictions_and_Application_Mistakes.pdf`.


## Replication of Tables and Figures

The table below maps every exhibit in the paper to the file it comes from. It is
generated from the compiled paper's `.aux` file, which is what actually assigns the
numbers, so it cannot drift from the paper by being edited out of step. The same mapping
is available as `exhibit_map.csv` at the root of this package, for anyone who would
rather read it programmatically.

Table and figure paths are relative to this package and appear after `make all`. Only
Figure 2 has code behind it; for the other figures the File column gives the paper's own
source file.

Every table the paper `\input`s is produced by one of the scripts here, so the tables in
the PDF and the tables produced by the code are the same artefact rather than two copies
kept in step by hand.

### Tables

| Exhibit | Produced by | File | Notes |
|---|---|---|---|
| Table 1 | `R/replication.Rmd` | `R/outputs/tables/prevalence_mistakes.tex` |  |
| Table 2 | `R/replication.Rmd` | `R/outputs/tables/effect_bias_mistakes.tex` |  |
| Table 3 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/main_openers_persist_all.tex` |  |
| Table 4 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/main_beliefs.tex` |  |
| Table 5 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/psp_persist_all.tex` |  |
| Table 6 | — | — | not distributed: requires the proprietary allocation algorithm |
| Table 7 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/main_policy_enroll_all.tex` |  |
| Table A.1 | `R/replication.Rmd` | `R/outputs/tables/summary_stats_applicants_survey.tex` |  |
| Table A.2 | `R/replication.Rmd` | `R/outputs/tables/reg_bias_knowledge.tex` |  |
| Table A.3 | `R/replication.Rmd` | `R/outputs/tables/bias_abs_income.tex` |  |
| Table A.4 | `R/replication.Rmd` | `R/outputs/tables/mistakes_truthtelling.tex` |  |
| Table B.1 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/balance_all.tex` |  |
| Table B.2 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/balance_open.tex` |  |
| Table B.3 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/balance_early.tex` |  |
| Table B.4 | `R/replication.Rmd` | `R/outputs/tables/placebo.tex` |  |
| Table B.5 | `R/replication.Rmd` | `R/outputs/tables/withdraw.tex` |  |
| Table B.6 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/main_comparison_t1t4_persist_all.tex` |  |
| Table B.7 | `Stata/analysis_rct_replication.do` | `Stata/output/tables/rct/main_beliefs_income.tex` |  |
| Table C.1 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/iv_firststage.tex` |  |
| Table C.2 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/balance_whatsapp.tex` |  |
| Table C.3 | `R/replication.Rmd` | `R/outputs/tables/summary_stats_rct_vs_compliers.tex` |  |
| Table C.4 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/desc_policy_byrisk_enroll_all.tex` |  |
| Table C.5 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/main_policy_byrisk.tex` |  |
| Table C.6 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/policy_anysearch_enroll_all.tex` |  |
| Table C.7 | `Stata/analysis_policy_replication.do` | `Stata/output/tables/policy/main_policybias.tex` |  |
| Table D.1 | — | — | not distributed: requires restricted RIS microdata |
| Table D.2 | — | — | not distributed: requires restricted RIS microdata |

### Figures

| Exhibit | Produced by | File | Notes |
|---|---|---|---|
| Figure 1 | — | `figures/timeline.png` | static image of the intervention materials, not analysis output |
| Figure 2 | `R/replication.Rmd` | `R/outputs/figures/knowledge_avg_income.pdf` | the file the paper includes as `figures/knowledge_avg_income.pdf` |
| Figure 3 | — | `figures/Graficas_feedback/1.png` | static image of the intervention materials, not analysis output |
| Figure 4 | — | `figures/Graficas_feedback/2.png` | static image of the intervention materials, not analysis output |
| Figure 5 | — | `figures/Graficas_feedback/7.png` | static image of the intervention materials, not analysis output |
| Figure 6 | — | `figures/Graficas_feedback/8.PNG` | static image of the intervention materials, not analysis output |
| Figure 7 | — | `figures/Graficas_feedback/10b.PNG` | static image of the intervention materials, not analysis output |
| Figure B.1 | — | `figures/Graficas_feedback/5.png` | static image of the intervention materials, not analysis output |
| Figure B.2 | — | `figures/Graficas_feedback/3.png` | static image of the intervention materials, not analysis output |
| Figure B.3 | — | `figures/Graficas_feedback/4.png` | static image of the intervention materials, not analysis output |
| Figure B.4 | — | `figures/Graficas_feedback/6.png` | static image of the intervention materials, not analysis output |
| Figure C.1 | — | `figures/Graficas_feedback/9.PNG` | static image of the intervention materials, not analysis output |

Figure 2 is the one figure derived from analysis. `R/replication.Rmd` computes it and
writes it to `R/outputs/figures/knowledge_avg_income.pdf`; the paper includes that file
unchanged. Every other figure is a screenshot or diagram of the intervention materials and
has no code behind it.

### In-text numbers

The benefit-cost ratios quoted in Section 5.3 of the paper, derived in Appendix D.2 and
reported in the "Implied BCR" row of Table D.1, are computed by `R/analysis_bcr.R` from
estimates already published in the paper (the IV estimate from Table D.1, the first stage from Table C.1,
and the stated cost assumptions). The script reads no data, so it runs anywhere even
though Table D.1 itself cannot be re-estimated outside the RIS secure environment;
`make all` writes its output to `R/outputs/bcr.txt`.

## Numerical validation against the paper

The package was run from a clean state and every generated `.tex` file was compared with
the file the paper `\input`s for the same table. All 34 are byte-identical, so every
coefficient, standard error, mean, sample size and summary statistic in
`Information_Frictions_and_Application_Mistakes.pdf` is exactly what the code produces.

## Why Tables 6, D.1, and D.2 cannot be replicated from this archive

The inability to reproduce these three tables from the public replication package is due to documented external access restrictions, rather than an omission in the analysis code. The code used to produce them is not included in this archive; it can be supplied to the data editor on request.

### Table 6: proprietary allocation algorithm

Table 6 reports scale-up simulations that require the allocation algorithm used by the Chilean college-admissions authority. The algorithm is proprietary software covered by contractual agreements and cannot be shared or redistributed in a replication archive. The simulation therefore cannot be rerun externally using the public files alone. In particular, providing the public inputs without the allocation engine would not reproduce the analysis: the allocation mechanism is a necessary computational component of the simulation.

### Tables D.1 and D.2: restricted RIS administrative data

Tables D.1 and D.2 use data from RIS (Registro de Información Social), which contain individual level income and household information from Chilean administrative records, matched with other administrative data sources such as college enrollment and admission process data. The data are not publicly available, and the access agreement does not permit the microdata to be removed from the secure offices of the Ministerio de Desarrollo Social. Consequently, no researcher outside the authorized premises can legally or practically run the analysis on the underlying records. The tables were generated by a research assistant working within the Ministry's secure environment; this was the only permitted setting in which the analysis could be performed. The derived "Implied BCR" row of Table D.1 is the exception: it is reproduced by `R/analysis_bcr.R` from the published estimates (see **In-text numbers** above).
