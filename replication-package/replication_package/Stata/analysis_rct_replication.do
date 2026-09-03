// =================================================
// =================================================
// TABLES RCT
// =================================================
// =================================================

clear
* Run this file with Stata's working directory set to this Stata folder.
* All source data are read from ../Data/ and all generated files go to output/.
global project_dir "`c(pwd)'"
global data_dir "$project_dir/../Data"
global output_dir "$project_dir/output"
capture mkdir "$output_dir"
capture mkdir "$output_dir/data"
capture mkdir "$output_dir/tables"
capture mkdir "$output_dir/tables/rct"
cd "$output_dir"
global data_path_2022 "$data_dir"

capture which eststo
if _rc ssc install estout
capture which rwolf2
if _rc ssc install rwolf2
capture which texdoc
if _rc ssc install texdoc

//Load data
import delimited "$data_path_2022/data_2022.csv", clear

keep if in_rct==1
keep if misfit==1
keep if codigo_carrera_1_fin!=.
keep if codigo_carrera_1_int!=.

replace pace="1" if pace=="PACE"
destring pace, replace

rename income_below_median lowinc 
drop lowinc
gen lowinc=(ingreso_percapita_grupo_fa<= 4)
 
rename entered_enroll_same_prog ent_enroll_sameprog

gen impr_ent_persist=0
replace impr_ent_persist=( (remained_enrolled_2022_2023 ==1 & improved==1) ///
						 | (remained_enrolled_2022_2023 ==1 & entered==1 ))
replace impr_ent_persist=. if improved==. & entered==.

replace overall_prob_ratex_inc=0 if overall_ratex_fin-overall_ratex_int<0.01
replace overall_prob_ratex_inc=. if overall_ratex_int>0.99

save "data/data_rct.dta", replace

global persist_all=1
if $persist_all ==1{
	global persist="impr_ent_persist"
	global persist_table="persist_all"
}
if $persist_all ==0{
	global persist="ent_enroll_sameprog"
	global persist_table="persist_ent"	
}

/*ALL Students*/
//Use rwolf2
eststo clear
use "$output_dir/data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=0

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3
tab control if open==1
tab control 

///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress overall_prob_ratex_inc treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress improved treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress entered treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress $persist treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust), ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3, treat2 treat3, treat2 treat3) ///
holm ///
seed(9865)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m4rw_treat`i'=e(rw_entered_treat`i')
scalar scal_m5rw_treat`i'=e(rw_$persist _treat`i')
}

//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg improved treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

eststo: reg entered treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg $persist treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 10  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3
matrix M[7,1] = scal_m4p_treat2
matrix M[8,1] = scal_m4p_treat3
matrix M[9,1] = scal_m5p_treat2
matrix M[10,1] =scal_m5p_treat3
matrix list M

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}

cap program drop add
program def add

forvalues m = 1/5  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1' & `m2' & `m3' &  `m4'&  `m5' \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' & `m5_sd'\\
if $mht_corr ==1{
tex &  [`m1_rw']  \{`m1_q'\} &[`m2_rw'] \{`m2_q'\}   & [`m3_rw'] \{`m3_q'\}   &[`m4_rw']  \{`m4_q'\}  &[`m5_rw'] \{`m5_q'\}   \\
}

end


cap program drop add_bottom
program def add_bottom

quietly summ changed if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ overall_prob_ratex_inc if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc
local N_m2: di %15.0fc r(N)

quietly summ improved if control==1
local mean_m3: di %6.4fc r(mean)
quietly summ improved
local N_m3: di %15.0fc r(N)

quietly summ entered if control==1 
local mean_m4: di %6.4fc r(mean)
quietly summ entered
local N_m4: di %15.0fc r(N)

quietly summ $persist if control==1
local mean_m5: di %6.4fc r(mean)
quietly summ $persist
local N_m5: di %15.0fc r(N)

tex Mean (Control) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'&  `mean_m5' \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5'\\
tex   Strata FE &  Yes  & Yes  & Yes  & Yes  & Yes  \\

end

texdoc init "tables/rct/main_allstudents_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among All Students}\label{tab:rct_main_allstudents_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
else{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add "Treatment 2" treat2
add "Treatment 3" treat3
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
else{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*ONLY OPENERS*/

//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=1

keep if open == 1

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress overall_prob_ratex_inc treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress improved treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress entered treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress $persist treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust), ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3, treat2 treat3, treat2 treat3) ///
holm ///
seed(9865)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m4rw_treat`i'=e(rw_entered_treat`i')
scalar scal_m5rw_treat`i'=e(rw_$persist _treat`i')
}

//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg improved treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

eststo: reg entered treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
summ entered if control==1
forvalues i = 2/3  {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg $persist treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 10  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3
matrix M[7,1] = scal_m4p_treat2
matrix M[8,1] = scal_m4p_treat3
matrix M[9,1] = scal_m5p_treat2
matrix M[10,1] = scal_m5p_treat3

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}

texdoc init "tables/rct/main_openers_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers}\label{tab:rct_main_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add "Treatment 2" treat2
add "Treatment 3" treat3
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


//Only Openers - PSP Analysis

rename overall_prob_ratex_inc ovprob_ratex_inc

local varlist changed ovprob_ratex_inc improved entered $persist
foreach var of local varlist{
quietly summ `var' if control==1
local scal_`var'=r(mean)
local scal_`var'_sd=r(sd)
local scal_`var'_N=r(N)

quietly summ `var' if treatment==3
local scal_`var'_N_T3=r(N)

reg  `var' treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
local scal_`var'_treat3=_b[treat3]

power twoproportions `scal_`var'', diff(`scal_`var'_treat3')  ///
n1( `scal_`var'_N' ) n2( `scal_`var'_N_T3' )  

scalar scal_pow`var'=r(power) 
forval x= 10(10)90  {
scalar scal_`var'_`x'=(scal_pow`var'*(`x'/100))/(scal_pow`var'*(`x'/100)+0.05*(1-(`x'/100)))
dis scal_`var'_`x'
}
}

cap program drop add_psp
program def add_psp

local varlist changed ovprob_ratex_inc improved entered $persist
foreach var of local varlist{
	
local m_`var': di %6.3fc scal_`var'_`2'
}

tex `1' &  `m_changed' & `m_ovprob_ratex_inc' & `m_improved' &  `m_entered'&  `m_$persist' \\

end



texdoc init "tables/rct/psp_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Post-Study Probability}\label{tab:psp_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex   Prior  & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add_psp "0.10" 10
add_psp "0.20" 20
add_psp "0.30" 30
add_psp "0.40" 40
add_psp "0.50" 50
add_psp "0.60" 60
add_psp "0.70" 70
add_psp "0.80" 80
add_psp "0.90" 90
tex \hline
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} 
if $persist_all ==1{
tex This table shows the Post-Study Probability of the experimental results presented in Table \ref{tab:rct_main_persist_all}. Computations follow Equation (\ref{equ:psp}) for different levels of prior probability of each hypothesis.
}
if $persist_all ==0{
tex This table shows the Post-Study Probability of the experimental results presented in Table \ref{tab:rct_main_persist_ent}. Computations follow Equation (\ref{equ:psp}) for different levels of prior probability of each hypothesis.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close




//Only treatments 1 and 4
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=1

keep if open == 1
keep if treatment == 1 | treatment == 4

gen control = 0
gen treat4 = 0
replace control = 1 if treatment == 1
replace treat4 = 1 if treatment == 4


///Romano-Wolf Correction
rwolf2 (regress changed treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress overall_prob_ratex_inc treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress improved treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress entered treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress $persist treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust), ///
indepvars(treat4, treat4, treat4, treat4, treat4) ///
holm ///
seed(9865)


forvalues i = 4/4 {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m4rw_treat`i'=e(rw_entered_treat`i')
scalar scal_m5rw_treat`i'=e(rw_$persist _treat`i')
}

//Linear regressions, no MHT corrections
reg changed treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
scalar scal_m1_treat4=_b[treat4]
scalar scal_m1sd_treat4=_se[treat4]
scalar scal_m1p_treat4=2*ttail(e(df_r),abs(scal_m1_treat4/scal_m1sd_treat4))

eststo: reg overall_prob_ratex_inc treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
scalar scal_m2_treat4=_b[treat4]
scalar scal_m2sd_treat4=_se[treat4]
scalar scal_m2p_treat4=2*ttail(e(df_r),abs(scal_m2_treat4/scal_m2sd_treat4))

eststo: reg improved treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
scalar scal_m3_treat4=_b[treat4]
scalar scal_m3sd_treat4=_se[treat4]
scalar scal_m3p_treat4=2*ttail(e(df_r),abs(scal_m3_treat4/scal_m3sd_treat4))

eststo: reg entered treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
scalar scal_m4_treat4=_b[treat4]
scalar scal_m4sd_treat4=_se[treat4]
scalar scal_m4p_treat4=2*ttail(e(df_r),abs(scal_m4_treat4/scal_m4sd_treat4))

eststo: reg $persist treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
scalar scal_m5_treat4=_b[treat4]
scalar scal_m5sd_treat4=_se[treat4]
scalar scal_m5p_treat4=2*ttail(e(df_r),abs(scal_m5_treat4/scal_m5sd_treat4))

//Set the number of p-values and generate a matrix with them
local n = 5  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat4
matrix M[2,1] = scal_m2p_treat4
matrix M[3,1] = scal_m3p_treat4
matrix M[4,1] = scal_m4p_treat4
matrix M[5,1] = scal_m5p_treat4

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
local varlist treat4
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of local varlist {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}


texdoc init "tables/rct/main_comparison_t1t4_$persist_table.tex", replace force
tex \begin{table}[h]
tex \caption{Regression Results among Openers - T1 vs T4}\label{tab:rct_main_t1t4_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add "Treatment 4" treat4
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close

/*ONLY OPENERS - T1 vs T2, T3 and T4*/

//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=1

keep if open == 1

gen control = 0
gen treat2 = 0
gen treat3 = 0
gen treat4 = 0
replace control = 1 if (treatment == 1)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3
replace treat4 = 1 if treatment == 4


///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress overall_prob_ratex_inc treat2 treat3 treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress improved treat2 treat3 treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress entered treat2 treat3 treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress $persist treat2 treat3 treat4 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust), ///
indepvars(treat2 treat3 treat4, treat2 treat3 treat4, ///
treat2 treat3 treat4, treat2 treat3 treat4, treat2 treat3 treat4) ///
holm ///
seed(9865)


forvalues i = 2/4  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m4rw_treat`i'=e(rw_entered_treat`i')
scalar scal_m5rw_treat`i'=e(rw_$persist _treat`i')
}

//Linear regressions, no MHT corrections
reg changed treat2 treat3 treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/4 {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3 treat4  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
forvalues i = 2/4 {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg improved treat2 treat3 treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/4 {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

eststo: reg entered treat2 treat3 treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/4 {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg $persist treat2 treat3 treat4 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/4 {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 15  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m1p_treat4
matrix M[4,1] = scal_m2p_treat2
matrix M[5,1] = scal_m2p_treat3
matrix M[6,1] = scal_m2p_treat4
matrix M[7,1] = scal_m3p_treat2
matrix M[8,1] = scal_m3p_treat3
matrix M[9,1] = scal_m3p_treat4
matrix M[10,1]=scal_m4p_treat2
matrix M[11,1]=scal_m4p_treat3
matrix M[12,1]=scal_m4p_treat4
matrix M[13,1]=scal_m5p_treat2
matrix M[14,1]=scal_m5p_treat3
matrix M[15,1]=scal_m5p_treat4

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 treat4 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}

texdoc init "tables/rct/main_openers_t1vsall_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - All Groups}\label{tab:rct_main_t1vsall_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add "Treatment 2" treat2
add "Treatment 3" treat3
add "Treatment 4" treat4
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*ONLY OPENERS - T1 vs T2, T3*/

//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=1

keep if open == 1
drop if treatment==4

gen control = 0
gen treat2 = 0
gen treat3 = 0
gen treat4 = 0
replace control = 1 if (treatment == 1)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3
replace treat4 = 1 if treatment == 4

///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress overall_prob_ratex_inc treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress improved treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress entered treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress $persist treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust), ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3, treat2 treat3, treat2 treat3) ///
holm ///
seed(9865)


forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m4rw_treat`i'=e(rw_entered_treat`i')
scalar scal_m5rw_treat`i'=e(rw_$persist _treat`i')
}

//Linear regressions, no MHT corrections
reg changed treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3 {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
forvalues i = 2/3 {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg improved treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3 {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

eststo: reg entered treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3 {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg $persist treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3 {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 10  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3
matrix M[7,1]=scal_m4p_treat2
matrix M[8,1]=scal_m4p_treat3
matrix M[9,1]=scal_m5p_treat2
matrix M[10,1]=scal_m5p_treat3

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}

texdoc init "tables/rct/main_openers_t1vst2t3_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - T1 vs T2\&T3}\label{tab:rct_main_t1vst2t3_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add "Treatment 2" treat2
add "Treatment 3" treat3
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*ONLY OPENERS - SAFETY ONLY*/
//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=0

keep if open == 1

keep if general_message==2

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress overall_prob_ratex_inc treat2 treat3  ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress entered treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress $persist treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust), ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3, treat2 treat3) ///
holm ///
seed(9865)




forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m4rw_treat`i'=e(rw_entered_treat`i')
scalar scal_m5rw_treat`i'=e(rw_$persist _treat`i')
}


//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg entered treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg $persist treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}

//Set the number of p-values and generate a matrix with them
local n = 8  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m4p_treat2
matrix M[6,1] = scal_m4p_treat3
matrix M[7,1] = scal_m5p_treat2
matrix M[8,1] = scal_m5p_treat3

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
foreach m in 1 2 4 5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}


cap program drop add_safety
program def add_safety

foreach m in 1 2 4 5  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1' & `m2' &  `m4'&  `m5' \\
tex &    `m1_sd' &  `m2_sd'  & `m4_sd' & `m5_sd'\\
if $mht_corr ==1{
tex & [`m1_rw'] \{`m1_q'\}   & [`m2_rw'] \{`m2_q'\}   &[`m4_rw']  \{`m4_q'\}  & [`m5_rw'] \{`m5_q'\}    \\
}
end


cap program drop add_bottom_safety
program def add_bottom_safety

quietly summ changed if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di  %15.0fc r(N)

quietly summ overall_prob_ratex_inc if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc
local N_m2: di %15.0fc  r(N)

quietly summ entered  if control==1
local mean_m4: di %6.4fc r(mean)
quietly summ entered
local N_m4: di %15.0fc r(N)

quietly summ $persist if control==1
local mean_m5: di %6.4fc r(mean)
quietly summ $persist
local N_m5: di %15.0fc r(N)


tex Mean (Control) &  `mean_m1' & `mean_m2' &  `mean_m4'&  `mean_m5' \\
tex  Observations &    `N_m1' &  `N_m2'  & `N_m4' & `N_m5'\\
tex   Strata FE &  Yes  & Yes  & Yes  & Yes  \\

end

texdoc init "tables/rct/main_openers_safety_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - Safety Group}\label{tab:rct_main_safety_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lcccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{2}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-5}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) \\ 
tex \hline 
add_safety "Treatment 2" treat2
add_safety "Treatment 3" treat3
tex \hline
add_bottom_safety
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close



/*ONLY OPENERS - Explore ONLY*/
if $persist_all ==1{
	
//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=0

keep if open == 1

keep if general_message==3

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress overall_prob_ratex_inc treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress improved treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress $persist treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust), ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3, treat2 treat3) ///
holm ///
seed(1234)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m4rw_treat`i'=e(rw_$persist _treat`i')
}


//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg improved treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

eststo: reg $persist treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

//Set the number of p-values and generate a matrix with them
local n = 8  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3
matrix M[7,1] = scal_m4p_treat2
matrix M[8,1] = scal_m4p_treat3

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forval m= 1/4  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}


cap program drop add_explore
program def add_explore

forval m= 1/4  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1' & `m2' &  `m3' &  `m4' \\
tex &    `m1_sd' &  `m2_sd'  & `m3_sd' & `m4_sd' \\
if $mht_corr ==1{
tex & [`m1_rw']  \{`m1_q'\}  & [`m2_rw']  \{`m2_q'\}   & [`m3_rw']  \{`m3_q'\}   & [`m4_rw']  \{`m4_q'\} \\
}
end


cap program drop add_bottom_explore
program def add_bottom_explore

quietly summ changed if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ overall_prob_ratex_inc if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc
local N_m2: di %15.0fc r(N)

quietly summ improved if control==1
local mean_m3: di %6.4fc r(mean)
quietly summ improved
local N_m3: di %15.0fc r(N)

quietly summ $persist if control==1
local mean_m4: di %6.4fc r(mean)
quietly summ improved
local N_m4: di %15.0fc r(N)

tex Mean (Control) &  `mean_m1' & `mean_m2' &  `mean_m3'&  `mean_m4' \\
tex  Observations &    `N_m1' &  `N_m2'  & `N_m3' & `N_m4' \\
tex   Strata FE &  Yes  & Yes  & Yes  & Yes    \\

end

texdoc init "tables/rct/main_openers_explore_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - Explore Group}\label{tab:rct_main_explore_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{7pt}}lcccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{2}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-4}
tex     & Modified & Incr. Prob. &  Improved &  Benefited\&Persisted \\ 
tex     & (1) & (2) & (3) & (4) \\ 
tex \hline 
add_explore "Treatment 2" treat2
add_explore "Treatment 3" treat3
tex \hline
add_bottom_explore
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list. Benefited\&Persisted is a binary variable equal to 1 if the student either entered of improved and persists for two years in the same program, 0 otherwise. Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close
}
if $persist_all ==0{
//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=0

keep if open == 1

keep if general_message==3

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3



///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress overall_prob_ratex_inc treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress improved treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) , ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3) ///
holm ///
seed(1234)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_overall_prob_ratex_inc_treat`i')
scalar scal_m3rw_treat`i'=e(rw_improved_treat`i')
}


//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg overall_prob_ratex_inc treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg improved treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 6  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forval m= 1/3  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}


cap program drop add_explore
program def add_explore

forval m= 1/3  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1' & `m2' &  `m3' \\
tex &    `m1_sd' &  `m2_sd'  & `m3_sd'\\
if $mht_corr ==1{
tex & [`m1_rw']  \{`m1_q'\}  & [`m2_rw']  \{`m2_q'\}   & [`m3_rw']  \{`m3_q'\} \\
}
end


cap program drop add_bottom_explore
program def add_bottom_explore

quietly summ changed if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ overall_prob_ratex_inc if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc
local N_m2: di %15.0fc r(N)

quietly summ improved if control==1
local mean_m3: di %6.4fc r(mean)
quietly summ improved
local N_m3: di %15.0fc r(N)

tex Mean (Control) &  `mean_m1' & `mean_m2' &  `mean_m3' \\
tex  Observations &    `N_m1' &  `N_m2'  & `N_m3'\\
tex   Strata FE &  Yes  & Yes  & Yes   \\

end

texdoc init "tables/rct/main_openers_explore_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - Explore Group}\label{tab:rct_main_explore_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{7pt}}lccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{1}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-4}
tex     & Modified & Incr. Prob. &  Improved\\ 
tex     & (1) & (2) & (3)  \\ 
tex \hline 
add_explore "Treatment 2" treat2
add_explore "Treatment 3" treat3
tex \hline
add_bottom_explore
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list. Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close
}


/*ONLY OPENERS - Reach ONLY*/

if $persist_all ==1{
//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=0

keep if open == 1

keep if general_message==1

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress improved treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress $persist treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) , ///
indepvars(treat2 treat3, ///
treat2 treat3, treat2 treat3) ///
holm ///
seed(1234)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_improved_treat`i')
scalar scal_m3rw_treat`i'=e(rw_$persist _treat`i')
}


//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg improved treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg $persist treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 6 // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3


//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forval m= 1/3  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}


cap program drop add_reach
program def add_reach

forval m= 1/3 {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1'  &  `m2' &  `m3' \\
tex &    `m1_sd'  & `m2_sd' & `m3_sd' \\
if $mht_corr ==1{
tex & [`m1_rw']   \{`m1_q'\}   & [`m2_rw']  \{`m2_q'\}  & [`m3_rw']  \{`m3_q'\}   \\
}
end


cap program drop add_bottom_reach
program def add_bottom_reach

quietly summ changed if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ improved if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ improved
local N_m2: di %15.0fc r(N)

quietly summ $persist if control==1
local mean_m3: di %6.4fc r(mean)
quietly summ $persist
local N_m3: di %15.0fc r(N)

tex Mean (Control) &  `mean_m1'  &  `mean_m2' &  `mean_m3'  \\
tex  Observations &    `N_m1'   & `N_m2' & `N_m3'  \\
tex   Strata FE &  Yes   & Yes  & Yes  \\

end

texdoc init "tables/rct/main_openers_reach_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - Reach Group}\label{tab:rct_main_reach_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{75pt}}lccc} 
tex \toprule
tex & \multicolumn{1}{c}{Applications} & \multicolumn{2}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-2} \cmidrule(lr){3-3}
tex     & Modified &  Improved &  Benefited\&Persisted \\ 
tex     & (1) & (2) & (3)  \\ 
tex \hline 
add_reach "Treatment 2" treat2
add_reach "Treatment 3" treat3
tex \hline
add_bottom_reach
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list. Benefited\&Persisted is a binary variable equal to 1 if the student either entered of improved and persists for two years in the same program, 0 otherwise. Robust standard errors are reported in parentheses. Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


} 
if $persist_all ==0{
//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

//Set MHT correction:
global mht_corr=0

keep if open == 1

keep if general_message==1

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3



///Romano-Wolf Correction
rwolf2 (regress changed treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) ///
(regress improved treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo, robust) , ///
indepvars(treat2 treat3, ///
treat2 treat3) ///
holm ///
seed(1234)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_changed_treat`i')
scalar scal_m2rw_treat`i'=e(rw_improved_treat`i')
}


//Linear regressions, no MHT corrections
reg changed treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg improved treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 4 // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3


//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forval m= 1/2  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}


cap program drop add_reach
program def add_reach

forval m= 1/2 {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1'  &  `m2' \\
tex &    `m1_sd'  & `m2_sd'\\
if $mht_corr ==1{
tex & [`m1_rw']   \{`m1_q'\}   & [`m2_rw']  \{`m2_q'\}  \\
}
end


cap program drop add_bottom_reach
program def add_bottom_reach

quietly summ changed if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ improved if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ improved
local N_m2: di %15.0fc r(N)

tex Mean (Control) &  `mean_m1'  &  `mean_m2' \\
tex  Observations &    `N_m1'   & `N_m2' \\
tex   Strata FE &  Yes   & Yes   \\

end

texdoc init "tables/rct/main_openers_reach.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among Openers - Reach Group}\label{tab:rct_main_reach_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{75pt}}lcc} 
tex \toprule
tex & \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-2} \cmidrule(lr){3-3}
tex     & Modified &  Improved\\ 
tex     & (1)  & (2)  \\ 
tex \hline 
add_reach "Treatment 2" treat2
add_reach "Treatment 3" treat3
tex \hline
add_bottom_reach
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list. Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close
}



// +++++++++++++++++++++++++++++++++++++++
// Survey - Beliefs over Admission Chances
// +++++++++++++++++++++++++++++++++++++++
eststo clear
use "data/data_rct.dta", clear
keep if open == 1 & responded_survey == 1

//Set MHT correction:
global mht_corr=0

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

gen pbias_prob_overall_norm=abs(bias_prob_overall)
gen pbias_toprep_norm = abs(bias_prob_top_reported) if full_reg_top_reported==1
gen pbias_toptrue_norm = abs(bias_prob_top_true) if full_reg_top_true==1
gen pbias_botrep_norm = abs(bias_prob_bottom_reported) ///
if full_reg_bottom_reported == 1    
gen pbias_bottrue_norm = abs(bias_prob_bottom_true) if full_reg_bottom_true == 1
gen pbias_random_norm = abs(bias_prob_random) if full_reg_random == 1

gen bias_cutoff_top_reported_abs=abs(bias_cutoff_top_reported)
gen bias_cutoff_top_true_abs=abs(bias_cutoff_top_true)
gen bias_cutoff_bottom_reported_abs=abs(bias_cutoff_bottom_reported)
gen bias_cutoff_bottom_true_abs=abs(bias_cutoff_bottom_true)

gen pbias_toptrue_reach=pbias_toptrue_norm if general_message==1
gen pbias_toptrue_reachexp=pbias_toptrue_norm if general_message==1 | general_message==3
gen pbias_toprep_reachexp=pbias_toprep_norm if general_message==1 | general_message==3
gen pbias_toptrue_exp=pbias_toptrue_norm if general_message==3
gen pbias_toprep_exp=pbias_toprep_norm if general_message==3
gen pbias_bottrue_safety=pbias_bottrue_norm if general_message==2
gen pbias_botrep_safety=pbias_botrep_norm if general_message==2
gen pbias_overall_safety=pbias_prob_overall_norm if general_message==2

if $mht_corr ==1{
///Romano-Wolf Correction
rwolf2 (regress pbias_toptrue_norm treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress pbias_bottrue_norm treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress pbias_prob_overall_norm treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo i.general_message, robust) ///
(regress pbias_toptrue_reach treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo if general_message==1, robust) ///
(regress pbias_overall_safety treat2 treat3 ///
 i.strata_region i.strata_score ///
i.strata_sexo if general_message==2, robust), ///
indepvars(treat2 treat3, treat2 treat3, ///
treat2 treat3, treat2 treat3, treat2 treat3, treat2 treat3) ///
holm ///
seed(1234)

forvalues i = 2/3  {
scalar scal_m1rw_treat`i'=e(rw_pbias_toptrue_norm_treat`i')
scalar scal_m2rw_treat`i'=e(rw_pbias_bottrue_norm_treat`i')
scalar scal_m3rw_treat`i'=e(rw_pbias_prob_overall_norm_treat`i')
scalar scal_m4rw_treat`i'=e(rw_pbias_toptrue_reach_treat`i')
scalar scal_m5rw_treat`i'=e(rw_pbias_overall_safety_treat`i')
}
}

//Linear regressions, no MHT corrections
reg pbias_toptrue_norm treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, ///
vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

reg pbias_bottrue_norm treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

reg pbias_prob_overall_norm treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

reg pbias_toptrue_reach treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg pbias_overall_safety treat2 treat3  ///
i.strata_region i.strata_score ///
i.strata_sexo, vce(robust)
forvalues i = 2/3  {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}


//Set the number of p-values and generate a matrix with them
local n = 10  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3
matrix M[7,1] = scal_m4p_treat2
matrix M[8,1] = scal_m4p_treat3
matrix M[9,1] = scal_m5p_treat2
matrix M[10,1] =scal_m5p_treat3
matrix list M

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}
matrix list M_q

cap program drop add_beliefs
program def add_beliefs

forvalues m = 1/5  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
if $mht_corr ==1{
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}
}

tex `1' &  `m1' & `m2' & `m3' &  `m4'&  `m5' \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' & `m5_sd' \\
if $mht_corr ==1{
tex & [`m1_rw'] \{`m1_q'\}   & [`m2_rw'] \{`m2_q'\}   & [`m3_rw']  \{`m3_q'\}  & [`m4_rw'] \{`m4_q'\}   & [`m5_rw']  \{`m5_q'\}    \\
}
end


cap program drop add_bottom_beliefs
program def add_bottom_beliefs

quietly summ pbias_toptrue_norm if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ pbias_toptrue_norm
local N_m1: di %15.0fc r(N)

quietly summ pbias_bottrue_norm if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ pbias_bottrue_norm
local N_m2: di %15.0fc r(N)

quietly summ pbias_prob_overall_norm if control==1
local mean_m3: di %6.4fc r(mean)
quietly summ pbias_prob_overall_norm
local N_m3: di %15.0fc r(N)

quietly summ pbias_toptrue_reach if control==1
local mean_m4: di %6.4fc r(mean)
quietly summ pbias_toptrue_reach
local N_m4: di %15.0fc r(N)

quietly summ pbias_overall_safety if control==1
local mean_m5: di %6.4fc r(mean)
quietly summ pbias_overall_safety
local N_m5: di %15.0fc r(N)


tex Mean (Control) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'&  `mean_m5'  \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5' \\
tex   Strata FE &  Yes  & Yes  & Yes  & Yes  & Yes    \\

end

texdoc init "tables/rct/main_beliefs.tex", replace force
tex \begin{table}[]
tex \caption{Impact on Biases in Admission Probabilities}\label{tab:rct_main_beliefs}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{3}{c}{All Applicants} & \multicolumn{1}{c}{Reach Group}  & \multicolumn{1}{c}{Safety Group} \\ 
tex     \cmidrule(lr){2-4} \cmidrule(lr){5-5} \cmidrule(lr){6-6}
tex     & Top-True  & Bottom-True & Overall Prob. & Top-True & Overall Prob.  \\ 
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add_beliefs "Treatment 2" treat2
add_beliefs "Treatment 3" treat3
tex \hline
add_bottom_beliefs
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table reports results from the OLS estimation of linear regression models where the dependent variable is the absolute value of students' subjective bias in their admission probabilities for different types of programs. The sample is limited to students who responded to the survey and opened the intervention. Robust standard errors reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close

// ++++++++++++++++++++++++++++++++++++++
// Survey - Beliefs over Average Earnings
// ++++++++++++++++++++++++++++++++++++++
eststo clear
use "data/data_rct.dta", clear
keep if open == 1 & responded_survey == 1

gen control = 0
gen treat2 = 0
gen treat3 = 0
gen treat4 = 0
replace control = 1 if (treatment == 1)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3
replace treat4 = 1 if treatment == 4

drop if treat4==1

gen p_absbias_inc_toprep=abs(pct_bias_income_avg_top_reported)
gen p_absbias_inc_botrep=abs(pct_bias_income_avg_bottom_repor)
gen p_absbias_inc_toptrue=abs(pct_bias_income_avg_top_true)
gen p_absbias_inc_bottrue=abs(pct_bias_income_avg_bottom_true)
gen p_absbias_inc_random=abs(pct_bias_income_avg_random)


//Linear regressions, no MHT corrections
reg p_absbias_inc_toptrue treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m1_treat`i'=_b[treat`i']
scalar scal_m1sd_treat`i'=_se[treat`i']
scalar scal_m1p_treat`i'=2*ttail(e(df_r),abs(scal_m1_treat`i'/scal_m1sd_treat`i'))
}

eststo: reg p_absbias_inc_toprep treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
forvalues i = 2/3  {
scalar scal_m2_treat`i'=_b[treat`i']
scalar scal_m2sd_treat`i'=_se[treat`i']
scalar scal_m2p_treat`i'=2*ttail(e(df_r),abs(scal_m2_treat`i'/scal_m2sd_treat`i'))
}

eststo: reg p_absbias_inc_bottrue treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m3_treat`i'=_b[treat`i']
scalar scal_m3sd_treat`i'=_se[treat`i']
scalar scal_m3p_treat`i'=2*ttail(e(df_r),abs(scal_m3_treat`i'/scal_m3sd_treat`i'))
}

eststo: reg p_absbias_inc_botrep treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m4_treat`i'=_b[treat`i']
scalar scal_m4sd_treat`i'=_se[treat`i']
scalar scal_m4p_treat`i'=2*ttail(e(df_r),abs(scal_m4_treat`i'/scal_m4sd_treat`i'))
}

eststo: reg p_absbias_inc_random treat2 treat3 ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message, vce(robust)
forvalues i = 2/3  {
scalar scal_m5_treat`i'=_b[treat`i']
scalar scal_m5sd_treat`i'=_se[treat`i']
scalar scal_m5p_treat`i'=2*ttail(e(df_r),abs(scal_m5_treat`i'/scal_m5sd_treat`i'))
}

//Set the number of p-values and generate a matrix with them
local n = 10  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_treat2
matrix M[2,1] = scal_m1p_treat3
matrix M[3,1] = scal_m2p_treat2
matrix M[4,1] = scal_m2p_treat3
matrix M[5,1] = scal_m3p_treat2
matrix M[6,1] = scal_m3p_treat3
matrix M[7,1] = scal_m4p_treat2
matrix M[8,1] = scal_m4p_treat3
matrix M[9,1] = scal_m5p_treat2
matrix M[10,1] = scal_m5p_treat3
matrix list M

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
    // Loop over treatment variables (treat2, treat3)
    foreach t of varlist treat2 treat3 {
        // Assign the corresponding scalar to the matrix
        scalar scal_m`m'q_`t' = M_q[`row',1] 
        local row = `row' + 1
    }
}
matrix list M_q

cap program drop add_beliefsinc
program def add_beliefsinc

forvalues m = 1/5  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
}

tex `1' &  `m1' & `m2' & `m3' &  `m4'&  `m5' \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' & `m5_sd'\\
end


cap program drop add_bottom_beliefsinc
program def add_bottom_beliefsinc

quietly summ p_absbias_inc_toptrue if control==1
local mean_m1: di %6.4fc r(mean)
quietly summ p_absbias_inc_toptrue
local N_m1: di %15.0fc r(N)

quietly summ p_absbias_inc_toprep if control==1
local mean_m2: di %6.4fc r(mean)
quietly summ p_absbias_inc_toprep
local N_m2: di %15.0fc r(N)

quietly summ p_absbias_inc_bottrue if control==1
local mean_m3: di %6.4fc r(mean)
quietly summ p_absbias_inc_bottrue
local N_m3: di %15.0fc r(N)

quietly summ p_absbias_inc_botrep if control==1
local mean_m4: di %6.4fc r(mean)
quietly summ p_absbias_inc_botrep
local N_m4: di %15.0fc r(N)

quietly summ p_absbias_inc_random if control==1
local mean_m5: di %6.4fc r(mean)
quietly summ p_absbias_inc_random
local N_m5: di %15.0fc r(N)


tex Mean (Control) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'&  `mean_m5' \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5' \\
tex   Strata FE &  Yes  & Yes  & Yes  & Yes  & Yes    \\

end

texdoc init "tables/rct/main_beliefs_income.tex", replace force
tex \begin{table}[]
tex \caption{Impact on Absolute Biases in Average Earnings}\label{tab:rct_main_beliefsinc}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex     & Top-True & Top-Reported & Bottom-True & Bottom-Reported & Random \\ 
tex     & (1) & (2) & (3) & (4) & (5) \\ 
tex \hline 
add_beliefsinc "Treatment 2" treat2
add_beliefsinc "Treatment 3" treat3
tex \hline
add_bottom_beliefsinc
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table reports results from the OLS estimation of linear regression models where the dependent variable is the absolute value of students' subjective bias in average earnings for different types of programs. The sample is limited to students who responded to the survey and opened the intervention. Robust standard errors reported in parentheses.
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*********************BALANCE TABLE*********************/
eststo clear
use "data/data_rct.dta", clear



local varlist open  ///
female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm ///
assigned_int overall_ratex_int 
foreach var of local varlist{


reg `var' i.treatment, vce(robust)
test 2.treatment 3.treatment 4.treatment

forvalues i = 2/4  {
scalar scal_`var'_treat`i'=_b[`i'.treatment]
scalar scal_`var'sd_treat`i'=_se[`i'.treatment]
scalar scal_`var'p_treat`i'=2*ttail(e(df_r),abs(scal_`var'_treat`i'/scal_`var'sd_treat`i'))
}

forvalues i = 1/4  {
quietly summ `var'  if treatment==`i'
scalar scal_`var'_treat`i'=r(mean)
}
}

cap program drop add_balance
program def add_balance

local mean_1: di %6.3fc scal_`2'_treat1
forvalues i = 2/4  {
local mean_`i': di %6.3fc scal_`2'_treat`i'
local p_`i': di %6.3fc scal_`2'p_treat`i'
}

tex `1' &  `mean_1' & `mean_2' & `mean_3' &  `mean_4'  & `p_2'  & `p_3'  & `p_4' \\
end



cap program drop add_balance_bottom
program def add_balance_bottom

forvalues i = 1/4  {
	
quietly summ treatment if treatment==`i'
local N_`i': di %15.0fc r(N)
}
tex Observations &  `N_1' & `N_2' & `N_3' &  `N_4'  &  &   & \\
end

texdoc init "tables/rct/balance_all.tex", replace force
tex \begin{table}[]
tex \caption{Balance Tests}\label{tab:rct_balance_all}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccccc} 
tex \toprule
tex     &  \multicolumn{4}{c}{Mean} & \multicolumn{3}{c}{P-Value Difference} \\ 
tex       \cmidrule(lr){2-5} \cmidrule(lr){6-8}
tex     & Treatment 1 & Treatment 2 & Treatment 3 & Treatment 4 & T2-T1& T3-T1 & T4-T1\\ 
tex     & (1) & (2) & (3) & (4) & (5)& (6) & (7)\\ 
tex \hline 
add_balance "Open" open
add_balance "Female" female
add_balance "Low-Income" lowinc
add_balance "Metropolitan Region" is_from_rm
add_balance "Public High school" public
add_balance "Voucher High school" voucher
add_balance "GPA" promedio_notas
add_balance "Math-Verbal" promlm_norm
add_balance "Assigned Interim" assigned_int
add_balance "Overall Ratex Interim" overall_ratex_int
tex \hline
add_balance_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table reports results from covariate balance checks across treatment arms.  Columns (1)–(4) report the mean of the variable for treatment groups 1-4, respectively. Columns 5–7 display p-values from tests of differences in means between Treatment 1 and each of the other treatment groups (Treatment 2, Treatment 3, and Treatment 4).
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*********************BALANCE TABLE - Conditional on Opening *********************/
eststo clear
use "data/data_rct.dta", clear

keep if open==1



local varlist open  ///
female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm ///
assigned_int overall_ratex_int 
foreach var of local varlist{


reg `var' i.treatment, vce(robust)
test 2.treatment 3.treatment 4.treatment

forvalues i = 2/4  {
scalar scal_`var'_treat`i'=_b[`i'.treatment]
scalar scal_`var'sd_treat`i'=_se[`i'.treatment]
scalar scal_`var'p_treat`i'=2*ttail(e(df_r),abs(scal_`var'_treat`i'/scal_`var'sd_treat`i'))
}

forvalues i = 1/4  {
quietly summ `var'  if treatment==`i'
scalar scal_`var'_treat`i'=r(mean)
}
}

cap program drop add_balance
program def add_balance

local mean_1: di %6.3fc scal_`2'_treat1
forvalues i = 2/4  {
local mean_`i': di %6.3fc scal_`2'_treat`i'
local p_`i': di %6.3fc scal_`2'p_treat`i'
}

tex `1' &  `mean_1' & `mean_2' & `mean_3' &  `mean_4'  & `p_2'  & `p_3'  & `p_4' \\
end



cap program drop add_balance_bottom
program def add_balance_bottom

forvalues i = 1/4  {
	
quietly summ treatment if treatment==`i'
local N_`i': di %15.0fc r(N)
}
tex Observations &  `N_1' & `N_2' & `N_3' &  `N_4'  &  &   & \\
end

texdoc init "tables/rct/balance_all_condopen.tex", replace force
tex \begin{table}[]
tex \caption{Balance Tests}\label{tab:rct_balance_all_condopen}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccccc} 
tex \toprule
tex     &  \multicolumn{4}{c}{Mean} & \multicolumn{3}{c}{P-Value Difference} \\ 
tex       \cmidrule(lr){2-5} \cmidrule(lr){6-8}
tex     & Treatment 1 & Treatment 2 & Treatment 3 & Treatment 4 & T2-T1& T3-T1 & T4-T1\\ 
tex     & (1) & (2) & (3) & (4) & (5)& (6) & (7)\\ 
tex \hline 
add_balance "Female" female
add_balance "Low-Income" lowinc
add_balance "Metropolitan Region" is_from_rm
add_balance "Public High school" public
add_balance "Voucher High school" voucher
add_balance "GPA" promedio_notas
add_balance "Math-Verbal" promlm_norm
add_balance "Assigned Interim" assigned_int
add_balance "Overall Ratex Interim" overall_ratex_int
tex \hline
add_balance_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table reports results from covariate balance checks across treatment arms, conditional on students opening their personalized websites.  Columns (1)–(4) report the mean of the variable for treatment groups 1-4, respectively. Columns 5–7 display p-values from tests of differences in means between Treatment 1 and each of the other treatment groups (Treatment 2, Treatment 3, and Treatment 4).
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*********************BALANCE Early/Late*********************/
eststo clear
import delimited "$data_path_2022/data_2022.csv", clear

keep if codigo_carrera_1_fin!=.

rename income_below_median lowinc
capture rename is_from_RM is_from_rm
//Redefine low income
drop lowinc
gen lowinc=(ingreso_percapita_grupo_fa<= 4)
//Use the interim GPA measure used in the original early/late balance table.
drop promedio_notas
rename promedio_notas_int promedio_notas

local varlist ///
female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm 
foreach var of local varlist{

reg `var' i.in_rct, vce(robust)

scalar scal_`var'_inrct=_b[1.in_rct]
scalar scal_`var'sd_inrct=_se[1.in_rct]

scalar scal_`var'_outrct=_b[_cons]
scalar scal_`var'sd_outrct=_se[_cons]
scalar scal_N_`var'=e(N)

}


cap program drop add_balance
program def add_balance

local t = 1
local varlist female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm 
foreach var of local varlist{
local mean_`t': di %6.3fc scal_`var'_inrct
local sd_`t': di %6.3fc scal_`var'sd_inrct
local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
local cons_`t': di %6.3fc scal_`var'_outrct
local sd_cons_`t': di %6.3fc scal_`var'sd_outrct
local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
local N_`t': dis %15.0fc scal_N_`var'

local t = `t' + 1

}

tex RCT Participant &  `mean_1' & `mean_2' & `mean_3' &  `mean_4'  & `mean_5' & `mean_6' & `mean_7' \\
tex  &  `sd_1' & `sd_2' & `sd_3' &  `sd_4'  & `sd_5' & `sd_6' & `sd_7'  \\
tex Constant &  `cons_1' & `cons_2' & `cons_3' &  `cons_4'  & `cons_5' & `cons_6' & `cons_7'  \\
tex  &  `sd_cons_1' & `sd_cons_2' & `sd_cons_3' &  `sd_cons_4'  & `sd_cons_5' & `sd_cons_6' & `sd_cons_7' \\
tex \hline
tex Observations &  `N_1' & `N_2' & `N_3' &  `N_4'  & `N_5' & `N_6' & `N_7'  \\
end

texdoc init "tables/rct/balance_early.tex", replace force
tex \begin{table}[]
tex \caption{Balance Tests - Early \& Late Applicants}\label{tab:rct_balance_early}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccccc} 
tex \toprule
tex     & \multicolumn{3}{c}{Demographics} & \multicolumn{2}{c}{High-School Type} & \multicolumn{2}{c}{Scores} \\ 
tex   \cmidrule(lr){2-4} \cmidrule(lr){5-6} \cmidrule(lr){7-8}    
tex  & Female & Low-Income & Metrop. Region & Public & Voucher  & GPA & Math-Verbal \\
tex   & (1) & (2) & (3) & (4) & (5) & (6) & (7)  \\ 
tex \hline 
add_balance
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table compares the characteristics of early applicants, selected to participate in the RCT, and late applicants, who were not participating in the experiment. Each column reports results from the OLS estimation of a linear regression model, considering different students' characteristics as the outcome variable. Robust standard errors are reported in parentheses.
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*********************BALANCE Open/Don't Open*********************/
eststo clear
use "data/data_rct.dta", clear




local varlist ///
female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm 
foreach var of local varlist{

reg `var' i.open, vce(robust)

scalar scal_`var'_open=_b[1.open]
scalar scal_`var'sd_open=_se[1.open]

scalar scal_`var'_dont=_b[_cons]
scalar scal_`var'sd_dont=_se[_cons]
scalar scal_N_`var'=e(N)

}


cap program drop add_balance
program def add_balance

local t = 1
local varlist female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm 
foreach var of local varlist{
local mean_`t': di %6.3fc scal_`var'_open
local sd_`t': di %6.3fc scal_`var'sd_open
local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
local cons_`t': di %6.3fc scal_`var'_dont
local sd_cons_`t': di %6.3fc scal_`var'sd_dont
local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
local N_`t': dis %15.0fc scal_N_`var'

local t = `t' + 1

}

tex Open &  `mean_1' & `mean_2' & `mean_3' &  `mean_4'  & `mean_5' & `mean_6' & `mean_7' \\
tex  &  `sd_1' & `sd_2' & `sd_3' &  `sd_4'  & `sd_5' & `sd_6' & `sd_7'  \\
tex Constant &  `cons_1' & `cons_2' & `cons_3' &  `cons_4'  & `cons_5' & `cons_6' & `cons_7'  \\
tex  &  `sd_cons_1' & `sd_cons_2' & `sd_cons_3' &  `sd_cons_4'  & `sd_cons_5' & `sd_cons_6' & `sd_cons_7' \\
tex \hline
tex Observations &  `N_1' & `N_2' & `N_3' &  `N_4'  & `N_5' & `N_6' & `N_7'  \\
end

texdoc init "tables/rct/balance_open.tex", replace force
tex \begin{table}[]
tex \caption{Balance Tests - Open}\label{tab:rct_balance_open}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccccc} 
tex \toprule
tex     & \multicolumn{3}{c}{Demographics} & \multicolumn{2}{c}{High-School Type} & \multicolumn{2}{c}{Scores} \\ 
tex   \cmidrule(lr){2-4} \cmidrule(lr){5-6} \cmidrule(lr){7-8}    
tex  & Female & Low-Income & Metrop. Region & Public & Voucher  & GPA & Math-Verbal \\
tex   & (1) & (2) & (3) & (4) & (5) & (6) & (7)  \\ 
tex \hline 
add_balance
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table compares the characteristics of applicants who opened their personalized website against those who did not. Each column reports results from the OLS estimation of a linear regression model, considering different students' characteristics as the outcome variable. Robust standard errors are reported in parentheses.
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/**********************RCT - IV Strategy********************/
/*ALL Students*/
//Use rwolf2
eststo clear
use "data/data_rct.dta", clear

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

reg open gets_sms, vce(robust)

//Restrict to T2 and T3*/
keep if treat2==1 | treat3==1
tab gets_sms

//Linear regressions, no MHT corrections
ivregress 2sls changed ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
(open = gets_sms), ///
vce(robust)
scalar scal_m1_open=_b[open]
scalar scal_m1sd_open=_se[open]
scalar scal_m1p_open=r(table)[4,1] 

ivregress 2sls overall_prob_ratex_inc ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
(open = gets_sms), ///
vce(robust)
scalar scal_m2_open=_b[open]
scalar scal_m2sd_open=_se[open]
scalar scal_m2p_open=r(table)[4,1] 


ivregress 2sls improved ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
(open = gets_sms), ///
vce(robust)
scalar scal_m3_open=_b[open]
scalar scal_m3sd_open=_se[open]
scalar scal_m3p_open=r(table)[4,1] 


ivregress 2sls entered ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
(open = gets_sms), ///
vce(robust)
scalar scal_m4_open=_b[open]
scalar scal_m4sd_open=_se[open]
scalar scal_m4p_open=r(table)[4,1] 

ivregress 2sls $persist ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
(open = gets_sms), ///
vce(robust)
scalar scal_m5_open=_b[open]
scalar scal_m5sd_open=_se[open]
scalar scal_m5p_open=r(table)[4,1] 


cap program drop add
program def add

forvalues m = 1/5  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
}

tex `1' &  `m1' & `m2' & `m3' &  `m4'&  `m5' \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' & `m5_sd'\\
end

cap program drop add_bottom
program def add_bottom

quietly summ changed if gets_sms==0
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ overall_prob_ratex_inc if gets_sms==0
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc
local N_m2: di %15.0fc r(N)

quietly summ improved if gets_sms==0 
local mean_m3: di %6.4fc r(mean)
quietly summ improved
local N_m3: di %15.0fc r(N)

quietly summ entered if gets_sms==0 
local mean_m4: di %6.4fc r(mean)
quietly summ entered
local N_m4: di %15.0fc r(N)

quietly summ $persist if gets_sms==0
local mean_m5: di %6.4fc r(mean)
quietly summ $persist
local N_m5: di %15.0fc r(N)

tex Mean (No Text) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'&  `mean_m5' \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5'\\
tex   Strata FE &  Yes  & Yes  & Yes  & Yes  & Yes  \\

end

texdoc init "tables/rct/main_rctiv_t2t3_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results among All Students}\label{tab:rct_main_iv_t2t3_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lccccc} 
tex \toprule
tex & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-6}
if $persist_all ==1{
tex     & Modified & Incr. Prob. & Improved & Entered & Benefited\&Persisted \\ 
}
if $persist_all ==0{
tex     & Modified & Incr. Prob. & Improved & Entered & Entered\&Persisted \\ 	
}
tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
add "Open" open
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Persisted is a binary variable equal to 1 if the student either entered or improved and persisted for two years in the same program, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Persisted are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Persisted is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent and persists for two years in this same program, 0 otherwise.
}
tex Robust standard errors are reported in parentheses. 
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


// First Stage
eststo clear
use "data/data_rct.dta", clear

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3


//Restrict to T2 and T3*/
keep if treat2==1 | treat3==1

reg open gets_sms  ///
i.strata_region i.strata_score ///
i.strata_sexo i.general_message ///
, vce(robust)
scalar scal_gets_sms=_b[gets_sms]
scalar scal_sd_gets_sms=_se[gets_sms]
scalar scal_p_gets_sms=r(table)[4,1] 
scalar scal_F_gets_sms=e(F)
dis scal_F_gets_sms

cap program drop add
program def add

local m: di %6.4fc scal_`2'
local m_sd: di %6.4fc scal_sd_`2'
local m_sd= subinstr("(`m_sd')", " ", "", .)

tex `1' &  `m'  \\
tex &    `m_sd' \\
end


cap program drop add_bottom
program def add_bottom

quietly summ open if gets_sms==0 
local mean_m: di %6.4fc r(mean)
quietly summ open
local N_m: di %15.0fc  r(N)

local m_F: dis scal_F_`1'
tex Strata FE & Yes \\
tex Mean (No Reminder) &  `mean_m' \\
tex  Observations &    `N_m' \\
tex  F-statistic &    `m_F' \\

end


texdoc init "tables/rct/rct_iv_firststage.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results: First Stage}\label{tab:rct_iv_firststage}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lc} 
tex \toprule
tex & \multicolumn{1}{c}{Open Website}  \\ 
tex     & (1) \\ 
tex \hline 
add "Receive SMS" gets_sms
tex \hline
add_bottom gets_sms
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table shows results from the first-stage regression of the instrumental variable strategy.
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close
