## Potentially Hardcoded Numeric Constants


We found the following set of hard coded numbers. This may be completely legitimate (parameter input, thresholds for computations, etc), and is hence only for information.

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20240224-1/replication-package/replication_package/R/analysis_bcr.R**

- Line 10, : ##  - First stage (WhatsApp -> Open): 0.1782. Table C.1 (iv_firststage)
- Line 13, : ##    controls (gender, region, test-score strata) gives 0.178176,
- Line 23, : first_stage <- 0.1782    # effect of reminder on P(open)

**/var/folders/5q/yhcyv3z55wvg6lhgc3h22kk00000gq/T/20240224-1/replication-package/replication_package/Stata/fdr_qvalues.do**

- Line 40, : * Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.
- Line 53, : * Reduce q by 0.001 and repeat loop

