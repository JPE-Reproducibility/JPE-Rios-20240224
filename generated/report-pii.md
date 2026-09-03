## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**
- Data files with PII indicators: 7
- Variables flagged in data: 36
- Code files with PII references: 7
- PII references in code: 565

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `carreras_2019.csv` | 1 | sex |
| Data | `carreras_2020.csv` | 1 | sex |
| Data | `carreras_2022.csv` | 1 | sex |
| Data | `carreras_2023.csv` | 1 | sex |
| Data | `data_2020.csv` | 20 | loc, social, sex, son |
| Data | `data_2022.csv` | 7 | sex, son, loc |
| Data | `data_2023.csv` | 5 | sex, loc |
| Code | `Makefile` | 3 | loc, second |
| Code | `analysis_bcr.R` | 9 | lat, gender, name |
| Code | `analysis_displacement_replication.do` | 20 | name, lon |
| Code | `analysis_policy_replication.do` | 108 | name, loc, son, school, lat |
| Code | `analysis_rct_replication.do` | 337 | name, sex, loc, son, school, lat |
| Code | `fdr_qvalues.do` | 5 | name, loc |
| Code | `replication.Rmd` | 83 | lat, name, lon, sex, block, loc, school, son |

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
