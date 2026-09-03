## ---------------------------------------------------------
## Benefit-cost ratio (BCR) of the intervention:
## BCR = PV(predicted earnings gains) / direct implementation cost.
## Reproduces the benefit-cost figures derived in Appendix D.2, quoted in
## Section 5.3, and reported in the "Implied BCR" row of Table D.1.
##
## All inputs are estimates already reported in the paper:
##  - LATE on predicted yearly income at h = 13: $86.74
##    (Table D.1, iv_predicted_income_13y, col. 1, N = 132,964)
##  - First stage (WhatsApp -> Open): 0.1782. Table C.1 (iv_firststage)
##    reports this with risk-group FE only (N = 132,893);
##    re-estimating on the risk 1-3 sample with the income-regression
##    controls (gender, region, test-score strata) gives 0.178176,
##    identical at the reported rounding.
##  - Direct implementation cost: $20,000 - $50,000 (fixed)
##
## The BCR is for a full-coverage policy: every student in the
## experimental sample receives the reminder (in the RCT, 27.1% did).
## Ratios are based on point estimates.
## ---------------------------------------------------------

late_h13    <- 86.74     # USD per year, per induced opener, at h = 13
first_stage <- 0.1782    # effect of reminder on P(open)
N           <- 132964    # experimental sample (risk groups 1-3)
costs       <- c(low = 20000, high = 50000)
disc_rates  <- c(0.03, 0.05)

# Per-student ITT gain in yearly income at h = 13 (reminder-induced only;
# gains for the ~52% of students who open the platform without a reminder
# are not counted, so this understates total benefits)
itt_h13 <- first_stage * late_h13

# Benefit horizons (years after HS graduation):
#  - "single year": gain accrues only at h = 13, the horizon we estimate
#  - "working life": h = 13 gain persists flat through h = 47
#    (HS graduation at ~18, retirement at ~65), no real wage growth,
#    and zero gains before h = 13
horizons <- list(single_year = 13:13, working_life = 13:47)

pv_factor <- function(hs, r) sum(1 / (1 + r)^hs)

results <- expand.grid(horizon = names(horizons),
                       disc_rate = disc_rates,
                       cost = names(costs))
results$pv_per_student <- mapply(
  function(h, r) itt_h13 * pv_factor(horizons[[h]], r),
  as.character(results$horizon), results$disc_rate)
results$pv_total <- results$pv_per_student * N
results$bcr <- results$pv_total / costs[as.character(results$cost)]

cat(sprintf("ITT gain in yearly income at h = 13: $%.2f per student\n", itt_h13))
cat(sprintf("Cost per student: $%.3f - $%.3f\n\n", costs["low"]/N, costs["high"]/N))
print(format(results, digits = 4), row.names = FALSE)

# Headline numbers quoted in the paper (discount rate held at 5% in both)
worklife <- subset(results, horizon == "working_life" & disc_rate == 0.05 & cost == "high")
conserv  <- subset(results, horizon == "single_year" & disc_rate == 0.05 & cost == "high")
cat(sprintf("\nConservative BCR (h = 13 only, 5%%, $50k cost): %.0f\n", conserv$bcr))
cat(sprintf("Working-life BCR (5%%, $50k cost): %.0f\n", worklife$bcr))
