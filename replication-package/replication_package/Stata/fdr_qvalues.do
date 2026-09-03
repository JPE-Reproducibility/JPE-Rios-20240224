

set more off

if _N > 0 {
	display "Please clear data set before proceeding"
	display "After clearing, type 'q' to resume"
	clear
	}	
	
// Convert matrix to a variable in the dataset
matrix list M
svmat M, names(pval)
rename pval1 pval

display "***********************************"
display "Please paste the vector of p-values that you wish to test into the variable 'pval'"
display	"After pasting, type 'q' to resume"
display "***********************************"

* Collect the total number of p-values tested

quietly sum pval
local totalpvals = r(N)

* Sort the p-values in ascending order and generate a variable that codes each p-value's rank

quietly gen int original_sorting_order = _n
quietly sort pval
quietly gen int rank = _n if pval != .

* Set the initial counter to 1 

local qval = 1

* Generate the variable that will contain the BH (1995) q-values

gen bh95_qval = 1 if pval != .

* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.

while `qval' > 0 {
	* Generate value qr/M
	quietly gen fdr_temp = `qval' * rank / `totalpvals'
	* Generate binary variable checking condition p(r) <= qr/M
	quietly gen reject_temp = ( fdr_temp >= pval ) if fdr_temp != .
	* Generate variable containing p-value ranks for all p-values that meet above condition
	quietly gen reject_rank = reject_temp * rank
	* Record the rank of the largest p-value that meets above condition
	quietly egen total_rejected = max( reject_rank )
	* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
	replace bh95_qval = `qval' if rank <= total_rejected & rank != .
	* Reduce q by 0.001 and repeat loop
	quietly drop fdr_temp reject_temp reject_rank total_rejected
	local qval = `qval' - .001
}

quietly sort original_sorting_order

// Convert myvar into a one-column matrix
mkmat bh95_qval, matrix(M_q)

set more on

display "Code has completed."
display "Benjamini Hochberg (1995) q-vals are in variable 'bh95_qval'"
display	"Sorting order is the same as the original vector of p-values"
