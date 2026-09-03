// =================================================
// =================================================
// TABLES Policy
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
capture mkdir "$output_dir/tables/policy"
cd "$output_dir"
global data_path_2023 "$data_dir"

//Load data
import delimited "$data_path_2023/data_2023.csv", clear

keep if codigo_carrera_1_fin!=.
keep if codigo_carrera_1_int!=.
keep if in_policy==1

replace pace="1" if pace=="PACE"
destring pace, replace

replace bea = "1" if bea == "BEA"
destring bea, replace

rename any_opening open
replace overall_prob_ratex_inc=0 if overall_fin-overall_int<0.01
replace overall_prob_ratex_inc=. if overall_int>0.99


gen lowinc=(ingreso_percapita_grupo_fa<= 4)

gen impr_ent_enroll=0
replace impr_ent_enroll= ( (codigo_demre_2023 !=0 & codigo_demre_2023 !=. & improved==1) ///
						 | (codigo_demre_2023 !=0 & codigo_demre_2023 !=. & entered==1 ))
replace impr_ent_enroll=. if improved==. & entered==.

save "data_policy.dta", replace

global persist_all=1
if $persist_all ==1{
	global persist="impr_ent_enroll"
	global persist_table="enroll_all"
}
else{
	global persist="enter_and_enroll"
	global persist_table="enroll_ent"	
}

use "data_policy.dta", clear

tab open
tab recibe_whatsapp

//Set MHT correction:
global mht_corr=1

///Romano-Wolf Correction
rwolf2 (ivregress 2sls changed i.risk_label ///
(open = recibe_whatsapp), vce(robust)) ///
(ivregress 2sls overall_prob_ratex_inc i.risk_label ///
(open = recibe_whatsapp), vce(robust)) ///
(ivregress 2sls improved i.risk_label ///
(open = recibe_whatsapp) ///
if assigned_int == 1, vce(robust)) ///
(ivregress 2sls entered i.risk_label ///
(open = recibe_whatsapp) ///
if assigned_int == 0, vce(robust)) ///
(ivregress 2sls $persist i.risk_label ///
(open = recibe_whatsapp), vce(robust)), ///
indepvars(open, open, open,  ///
open, open) ///
holm ///
seed(1234)

scalar scal_m1rw_open=e(rw_changed_open)
scalar scal_m2rw_open=e(rw_overall_prob_ratex_inc_open)
scalar scal_m3rw_open=e(rw_improved_open)
scalar scal_m4rw_open=e(rw_entered_open)
scalar scal_m5rw_open=e(rw_$persist _open)

//Linear regressions, no MHT corrections
ivregress 2sls changed i.risk_label ///
(open = recibe_whatsapp), ///
 vce(robust)
scalar scal_m1_open=_b[open]
scalar scal_m1sd_open=_se[open]
scalar scal_m1p_open=r(table)[4,1] 

ivregress 2sls overall_prob_ratex_inc i.risk_label ///
(open = recibe_whatsapp), ///
vce(robust)
scalar scal_m2_open=_b[open]
scalar scal_m2sd_open=_se[open]
scalar scal_m2p_open=r(table)[4,1] 

ivregress 2sls improved i.risk_label ///
(open = recibe_whatsapp) ///
if assigned_int == 1, ///
vce(robust)
scalar scal_m3_open=_b[open]
scalar scal_m3sd_open=_se[open]
scalar scal_m3p_open=r(table)[4,1] 

eststo: ivregress 2sls entered i.risk_label ///
(open = recibe_whatsapp) ///
if assigned_int == 0, ///
vce(robust)
scalar scal_m4_open=_b[open]
scalar scal_m4sd_open=_se[open]
scalar scal_m4p_open=r(table)[4,1] 
dis scal_m4p_open

eststo: ivregress 2sls $persist i.risk_label ///
(open = recibe_whatsapp), ///
vce(robust)
scalar scal_m5_open=_b[open]
scalar scal_m5sd_open=_se[open]
scalar scal_m5p_open=r(table)[4,1] 

//Set the number of p-values and generate a matrix with them
local n = 5  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_open
matrix M[2,1] = scal_m2p_open
matrix M[3,1] = scal_m3p_open
matrix M[4,1] = scal_m4p_open
matrix M[5,1] = scal_m5p_open
matrix list M

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/5  {
        scalar scal_m`m'q_open = M_q[`m',1] 
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

quietly summ changed if recibe_whatsapp==0
local mean_m1: di %6.4fc r(mean)
quietly summ changed
local N_m1: di %15.0fc r(N)

quietly summ overall_prob_ratex_inc if recibe_whatsapp==0
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc
local N_m2: di %15.0fc r(N)

quietly summ improved if recibe_whatsapp==0 & assigned_int == 1
local mean_m3: di %6.4fc r(mean)
quietly summ improved if assigned_int == 1
local N_m3: di %15.0fc r(N)

quietly summ entered if recibe_whatsapp==0 & assigned_int == 0
local mean_m4: di %6.4fc r(mean)
quietly summ entered if assigned_int == 0
local N_m4: di %15.0fc r(N)

quietly summ $persist if recibe_whatsapp==0
local mean_m5: di %6.4fc r(mean)
quietly summ $persist
local N_m5: di %15.0fc r(N)

tex Mean (No Text) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'&  `mean_m5' \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5'\\
tex   Risk Group &  Yes  & Yes  & Yes  & Yes  & Yes  \\

end

texdoc init "tables/policy/main_policy_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results: Instrumental Variables}\label{tab:policy_main_$persist_table}
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
tex     & Modified & Incr.  & Improved & Entered & Benefited \\ 
}
if $persist_all ==0{
tex     & Modified & Incr.  & Improved & Entered & Entered \\ 
}
tex     & & Prob. &  &  & \& Enrolled \\ 
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
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Enrolled is a binary variable equal to 1 if the student either entered or improved and enrolled, 0 otherwise. 
}
if $persist_all ==0{
tex Entered and Entered\&Enrolled are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Enrolled is a binary variable equal to 1 if the student enters and enrolls in this program, 0 otherwise. 
}
tex Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close



/*************************************************************************/
/******************************By Risk Group******************************/
/*************************************************************************/

//Summary statistics
use "data_policy.dta", clear

cap program drop add_desc
program def add_desc

summ mrun if  open==`2' & risk_label==`3'
local N: di %15.0fc r(N)

summ changed	if  open==`2' & risk_label==`3'
local mean_v1: di %6.3fc r(mean)

summ overall_prob_ratex_inc if  open==`2'
local mean_v2: di %6.3fc r(mean)

summ improved if   open==`2' & risk_label==`3'
local mean_v3: di %6.3fc r(mean)

summ entered	if  open==`2' & risk_label==`3'
local mean_v4: di %6.3fc r(mean)

summ $persist	if   open==`2' & risk_label==`3'
local mean_v5: di %6.3fc r(mean)



tex  `1' & `N' &  `mean_v1' & `mean_v2' & `mean_v3' &  `mean_v4'&  `mean_v5' \\

end


texdoc init "tables/policy/desc_policy_byrisk_$persist_table.tex", replace force
tex \begin{table}[h]
tex \caption{Summary Statistics by Risk Group}
tex \label{tab:desc_policy_byrisk_$persist_table}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lcccccc} 
tex \toprule
tex & N & \multicolumn{2}{c}{Applications} & \multicolumn{3}{c}{Assignment} \\ 
tex       \cmidrule(lr){3-4} \cmidrule(lr){5-7}
if $persist_all ==1{
tex  &  & Modified & Incr.  & Improved & Entered & Benefited \\ 
}
if $persist_all ==0{
tex  &  & Modified & Incr.  & Improved & Entered & Entered \\ 
}
tex    & & & Prob. &  &  & \& Enrolled \\ 
tex   &  & (1) & (2) & (3) & (4) & (5) \\ 
tex \hline 
tex \textit{Panel A: Did not open} \\
tex \hline 
add_desc "High Risk"   0 1
add_desc "Medium Risk"  0 2
add_desc "Low Risk"   0 3
tex \hline 
tex \textit{Panel B: Opened} \\
tex \hline 
add_desc "High Risk"  1 1
add_desc "Medium Risk"   1 2
add_desc "Low Risk"  1 3
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} The high-risk group (low-risk, resp.) includes students with an overall admission probability below 1\% (above 99\%, resp.) given their initial rank-ordered list. Students considered as facing a medium risk have an overall admission probability between 1\% and 99\% given their initial rank-ordered list. Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Enrolled is a binary variable equal to 1 if the student either entered or improved and enrolled, 0 otherwise. 
}
if $persist_all ==0{
tex Entered and Entered\&Enrolled are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Enrolled is a binary variable equal to 1 if the student enters and enrolls in this program, 0 otherwise. 
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


//Estimates - By Risk

use "data_policy.dta", clear

global mht_corr =0

gen entered_r1=entered
gen entered_r2=entered
gen improved_r2=improved
gen improved_r3=improved

if $mht_corr ==1{
///Romano-Wolf Correction
rwolf2 (ivregress 2sls entered_r1 ///
(open = recibe_whatsapp) ///
if risk_label==1 & assigned_int==0, /// 
vce(robust)) ///
(ivregress 2sls entered_r2 ///
(open = recibe_whatsapp) ///
if risk_label==2 & assigned_int==0 , /// 
vce(robust)) ///
(ivregress 2sls improved_r2 ///
(open = recibe_whatsapp) ///
if risk_label==2 & assigned_int==1, /// 
vce(robust)) /// 
(ivregress 2sls improved_r3 ///
(open = recibe_whatsapp) ///
if risk_label==3 & assigned_int==1, /// 
vce(robust)) ///
, ///
indepvars(open, open, open,  ///
open) ///
holm ///
seed(1234)

scalar scal_m1rw_open=e(rw_entered_r1_open)
scalar scal_m2rw_open=e(rw_entered_r2_open)
scalar scal_m3rw_open=e(rw_improved_r2_open)
scalar scal_m4rw_open=e(rw_improved_r3_open)
}

//Linear regressions, no MHT corrections
ivregress 2sls entered ///
(open = recibe_whatsapp) ///
if risk_label==1 & assigned_int==0, ///
 vce(robust)
scalar scal_m1_open=_b[open]
scalar scal_m1sd_open=_se[open]
scalar scal_m1p_open=r(table)[4,1] 

ivregress 2sls entered ///
(open = recibe_whatsapp) ///
if risk_label==2 & assigned_int==0, ///
 vce(robust)
scalar scal_m2_open=_b[open]
scalar scal_m2sd_open=_se[open]
scalar scal_m2p_open=r(table)[4,1] 

ivregress 2sls improved ///
(open = recibe_whatsapp) ///
if risk_label==2 & assigned_int == 1, ///
vce(robust)
scalar scal_m3_open=_b[open]
scalar scal_m3sd_open=_se[open]
scalar scal_m3p_open=r(table)[4,1] 

ivregress 2sls improved ///
(open = recibe_whatsapp) ///
if risk_label==3 & assigned_int == 1, ///
vce(robust)
scalar scal_m4_open=_b[open]
scalar scal_m4sd_open=_se[open]
scalar scal_m4p_open=r(table)[4,1] 

//Set the number of p-values and generate a matrix with them
local n = 4  // number of scalars
// Create an empty matrix with one column
matrix M = J(`n', 1, .)
// Store scalars in the matrix
matrix M[1,1] = scal_m1p_open
matrix M[2,1] = scal_m2p_open
matrix M[3,1] = scal_m3p_open
matrix M[4,1] = scal_m4p_open
matrix list M

if $mht_corr ==1{

//Run do file to get q values
preserve
	run "$project_dir/fdr_qvalues.do"
restore

//Generate the scalars associated to the q-values:
local row = 1
forvalues m = 1/4  {
        scalar scal_m`m'q_open = M_q[`m',1] 
}
}


cap program drop add
program def add

forvalues m = 1/4  {
local m`m': di %6.4fc scal_m`m'_`2'
local m`m'_sd: di %6.4fc scal_m`m'sd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
local m`m'_rw: di %6.4fc scal_m`m'rw_`2'
local m`m'_q: di %6.4fc scal_m`m'q_`2'
}

tex `1' &  `m1' & `m2' & `m3' &  `m4' \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' \\
if $mht_corr ==1{
tex &  [`m1_rw']  \{`m1_q'\} &[`m2_rw'] \{`m2_q'\}   & [`m3_rw'] \{`m3_q'\}   &[`m4_rw']  \{`m4_q'\}  \\
}
end


cap program drop add_bottom
program def add_bottom

quietly summ entered if recibe_whatsapp==0 ///
& assigned_int == 0 & risk_label==1 
local mean_m1: di %6.4fc r(mean)
quietly summ entered if assigned_int == 0 & risk_label==1
local N_m1: di %15.0fc r(N)

quietly summ entered if recibe_whatsapp==0 ///
& assigned_int == 0 & risk_label==2
local mean_m2: di %6.4fc r(mean)
quietly summ entered if assigned_int == 0 & risk_label==2
local N_m2: di %15.0fc r(N)

quietly summ improved if recibe_whatsapp==0 ///
& assigned_int == 1 & risk_label==2
local mean_m3: di %6.4fc r(mean)
quietly summ improved if assigned_int == 1 & risk_label==2
local N_m3: di %15.0fc r(N)

quietly summ improved if recibe_whatsapp==0 ///
& assigned_int == 1 & risk_label==3
local mean_m4: di %6.4fc r(mean)
quietly summ improved if assigned_int == 1 & risk_label==3
local N_m4: di %15.0fc r(N)


tex Mean (No Reminder) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'\\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4'\\
end


texdoc init "tables/policy/main_policy_byrisk.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results: Instrumental Variables - By Risk Level}\label{tab:main_policy_byrisk}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lcccc} 
tex \toprule
tex & \multicolumn{2}{c}{Entered} & \multicolumn{2}{c}{Improved} \\ 
tex       \cmidrule(lr){2-3} \cmidrule(lr){4-5}
tex     & High & Medium & Medium & Low \\ 
tex     & (1) & (2) & (3) & (4) \\ 
tex \hline 
add "Open" open
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} The high-risk group (low-risk, resp.) includes students with an overall admission probability below 1\% (above 99\%, resp.) given their initial rank-ordered list. Students considered as facing a medium risk have an overall admission probability between 1\% and 99\% given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list. Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. It is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close



// -----------------------------------------------------------------------------
// APPENDIX
// -----------------------------------------------------------------------------

// First Stage
eststo clear
use "data_policy.dta", clear

reg open recibe_whatsapp i.risk_label, vce(robust)
scalar scal_recibe_whatsapp=_b[recibe_whatsapp]
scalar scal_sd_recibe_whatsapp=_se[recibe_whatsapp]
scalar scal_p_recibe_whatsapp=r(table)[4,1] 
scalar scal_F_recibe_whatsapp=e(F)
dis scal_F_recibe_whatsapp

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

quietly summ open if recibe_whatsapp==0 
local mean_m: di %6.4fc r(mean)
quietly summ open
local N_m: di %15.0fc  r(N)

local m_F: dis scal_F_`1'
tex Risk Group & Yes \\
tex Mean (No Reminder) &  `mean_m' \\
tex  Observations &    `N_m' \\
tex  F-statistic &    `m_F' \\

end


texdoc init "tables/policy/iv_firststage.tex", replace force
tex \begin{table}[h]
tex \caption{Regression Results: First Stage}\label{tab:iv_firststage}
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
add "Receive WhatsApp" recibe_whatsapp
tex \hline
add_bottom recibe_whatsapp
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} This table shows results from the first-stage regression of the instrumental variable strategy.
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


//Whatsapp - Balance

eststo clear
use "data_policy.dta", clear

tab recibe_whatsapp

local varlist ///
female lowinc is_from_rm ///
public voucher ///
promedio_notas promlm_norm
foreach var of local varlist{

reg `var' i.recibe_whatsapp, vce(robust)

scalar scal_`var'_what=_b[1.recibe_whatsapp]
scalar scal_`var'sd_what=_se[1.recibe_whatsapp]

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
local mean_`t': di %6.3fc scal_`var'_what
local sd_`t': di %6.3fc scal_`var'sd_what
local sd_`t'= subinstr("(`sd_`t'')", " ", "", .)
local cons_`t': di %6.3fc scal_`var'_dont
local sd_cons_`t': di %6.3fc scal_`var'sd_dont
local sd_cons_`t'= subinstr("(`sd_cons_`t'')", " ", "", .)
local N_`t': dis %15.0fc scal_N_`var'

local t = `t' + 1

}

tex Received WhatsApp &  `mean_1' & `mean_2' & `mean_3' &  `mean_4'  & `mean_5' & `mean_6' & `mean_7' \\
tex  &  `sd_1' & `sd_2' & `sd_3' &  `sd_4'  & `sd_5' & `sd_6' & `sd_7'  \\
tex Constant &  `cons_1' & `cons_2' & `cons_3' &  `cons_4'  & `cons_5' & `cons_6' & `cons_7'  \\
tex  &  `sd_cons_1' & `sd_cons_2' & `sd_cons_3' &  `sd_cons_4'  & `sd_cons_5' & `sd_cons_6' & `sd_cons_7' \\
tex \hline
tex Observations &  `N_1' & `N_2' & `N_3' &  `N_4'  & `N_5' & `N_6' & `N_7'  \\
end

texdoc init "tables/policy/balance_whatsapp.tex", replace force
tex \begin{table}[h]
tex \caption{Balance Tests - Received WhatsApp Reminder}\label{tab:policy_balance_whatsapp}
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
tex \item \scriptsize \textsc{Notes.} This table compares the characteristics of applicants who received the WhatsApp reminder to open their personalized website against those who did not. Each column reports results from the OLS estimation of a linear regression model, considering different students' characteristics as the outcome variable. Robust standard errors are reported in parentheses.
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close



/*********************BALANCE TABLE - Opening *********************/
eststo clear
use "data_policy.dta", clear

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

tex  Open &  `mean_1' & `mean_2' & `mean_3' &  `mean_4'  & `mean_5' & `mean_6' & `mean_7' \\
tex  &  `sd_1' & `sd_2' & `sd_3' &  `sd_4'  & `sd_5' & `sd_6' & `sd_7'  \\
tex Constant &  `cons_1' & `cons_2' & `cons_3' &  `cons_4'  & `cons_5' & `cons_6' & `cons_7'  \\
tex  &  `sd_cons_1' & `sd_cons_2' & `sd_cons_3' &  `sd_cons_4'  & `sd_cons_5' & `sd_cons_6' & `sd_cons_7' \\
tex \hline
tex Observations &  `N_1' & `N_2' & `N_3' &  `N_4'  & `N_5' & `N_6' & `N_7'  \\
end

texdoc init "tables/policy/policy_balance_open.tex", replace force
tex \begin{table}[]
tex \caption{Balance Tests - Open Website}\label{tab:policy_balance_open}
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



///Search outcomes (Table C.6)
use "data_policy.dta", clear

//Set MHT correction:
global mht_corr=0

//Linear regressions, no MHT corrections

reg changed i.risk_label any_search ///
if open==1, ///
vce(robust)
scalar scal_m1_any_search=_b[any_search]
scalar scal_m1sd_any_search=_se[any_search]
scalar scal_m1p_any_search=r(table)[4,1] 

reg changed i.risk_label any_search i.apps_fin ///
if open==1, ///
vce(robust)
scalar scal_m1bis_any_search=_b[any_search]
scalar scal_m1bissd_any_search=_se[any_search]
scalar scal_m1bisp_any_search=r(table)[4,1] 

 
reg overall_prob_ratex_inc i.risk_label any_search ///
if open==1, ///
vce(robust)
scalar scal_m2_any_search=_b[any_search]
scalar scal_m2sd_any_search=_se[any_search]
scalar scal_m2p_any_search=r(table)[4,1] 

reg overall_prob_ratex_inc i.risk_label any_search i.apps_fin ///
if open==1, ///
vce(robust)
scalar scal_m2bis_any_search=_b[any_search]
scalar scal_m2bissd_any_search=_se[any_search]
scalar scal_m2bisp_any_search=r(table)[4,1] 

reg improved i.risk_label any_search ///
if assigned_int == 1 & open==1, ///
vce(robust)
scalar scal_m3_any_search=_b[any_search]
scalar scal_m3sd_any_search=_se[any_search]
scalar scal_m3p_any_search=r(table)[4,1] 

reg improved i.risk_label any_search i.apps_fin ///
if assigned_int == 1 & open==1, ///
vce(robust)
scalar scal_m3bis_any_search=_b[any_search]
scalar scal_m3bissd_any_search=_se[any_search]
scalar scal_m3bisp_any_search=r(table)[4,1] 

reg entered i.risk_label any_search ///
if assigned_int == 0 & open==1, ///
vce(robust)
scalar scal_m4_any_search=_b[any_search]
scalar scal_m4sd_any_search=_se[any_search]
scalar scal_m4p_any_search=r(table)[4,1] 

reg entered i.risk_label any_search i.apps_fin ///
if assigned_int == 0 & open==1, ///
vce(robust)
scalar scal_m4bis_any_search=_b[any_search]
scalar scal_m4bissd_any_search=_se[any_search]
scalar scal_m4bisp_any_search=r(table)[4,1] 

reg $persist i.risk_label any_search ///
if open==1, ///
vce(robust)
scalar scal_m5_any_search=_b[any_search]
scalar scal_m5sd_any_search=_se[any_search]
scalar scal_m5p_any_search=r(table)[4,1] 

reg $persist i.risk_label any_search i.apps_fin ///
if open==1, ///
vce(robust)
scalar scal_m5bis_any_search=_b[any_search]
scalar scal_m5bissd_any_search=_se[any_search]
scalar scal_m5bisp_any_search=r(table)[4,1] 


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

cap program drop add_bis
program def add_bis

forvalues m = 1/5  {
local m`m': di %6.4fc scal_m`m'bis_`2'
local m`m'_sd: di %6.4fc scal_m`m'bissd_`2'
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
}

tex `1' &  `m1' & `m2' & `m3' &  `m4'&  `m5' \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' & `m5_sd'\\
end

cap program drop add_bottom
program def add_bottom

quietly summ changed if open==1
local mean_m1: di %6.4fc r(mean)
quietly summ changed if open==1
local N_m1: di %15.0fc r(N)

quietly summ overall_prob_ratex_inc if open==1
local mean_m2: di %6.4fc r(mean)
quietly summ overall_prob_ratex_inc if open==1
local N_m2: di %15.0fc r(N)

quietly summ improved if assigned_int == 1 & open==1
local mean_m3: di %6.4fc r(mean)
quietly summ improved if assigned_int == 1 & open==1
local N_m3: di %15.0fc r(N)

quietly summ entered if assigned_int == 0 & open==1
local mean_m4: di %6.4fc r(mean)
quietly summ entered if assigned_int == 0 & open==1
local N_m4: di %15.0fc r(N)

quietly summ $persist if open==1
local mean_m5: di %6.4fc r(mean)
quietly summ $persist if open==1
local N_m5: di %15.0fc r(N)

tex Mean (No Text) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4'&  `mean_m5' \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5'\\
tex   Risk Group &  Yes  & Yes  & Yes  & Yes  & Yes  \\

end

texdoc init "tables/policy/policy_anysearch_$persist_table.tex", replace force
tex \begin{table}[]
tex \caption{Regression Results: Search Engine}\label{tab:policy_anysearch_$persist_table}
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
tex     & Modified & Incr.  & Improved & Entered & Benefited \\ 
}
if $persist_all ==0{
tex     & Modified & Incr.  & Improved & Entered & Entered \\ 
}
tex     & & Prob. &  &  & \& Enrolled \\ 

tex     & (1) & (2) & (3) & (4) & (5)\\ 
tex \hline 
tex \textit{Panel A:} \\
tex \hline 
add "Search" any_search
tex \hline 
tex \textit{Panel B: Controlling for Number of Applications} \\
tex \hline 
add_bis "Search" any_search
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} Modified is a binary variable equal to 1 if the student modified her application after the information was sent, 0 otherwise. Incr. Prob. is a binary variable equal to 1 if the admission probability associated with the initial rank-ordered list submitted is lower than the one associated with the final rank-ordered list, 0 otherwise. This variable is defined only for students with a positive admission risk given their initial rank-ordered list. Improved is a dummy variable equal to 1 if the student was assigned to a program ranked above the one where they would have been assigned given their initial rank-ordered list, 0 otherwise. It is only defined for the sample of students who would have been matched to a program given their initial rank-ordered list and who did not remove this program from their list.
if $persist_all ==1{
tex Entered is defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Benefited\&Enrolled is a binary variable equal to 1 if the student either entered or improved and enrolled, 0 otherwise.
}
if $persist_all ==0{
tex Entered and Entered\&Enrolled are defined for students who would not have been assigned to any program given the initial rank-ordered list they submitted. Entered is a binary variable equal to 1 if the student is assigned given their rank-ordered list submitted after the information was sent, 0 otherwise. Entered\&Enrolled is a binary variable equal to 1 if the student enters and enrolls in this program, 0 otherwise. 
}
tex Robust standard errors are reported in parentheses.
if $mht_corr ==1{
tex We report in brackets the p-values adjusted for multiple hypothesis testing following the procedure described in~\cite{romano2005stepwise} and in braces the q-values computed following \cite{anderson2008multiple}.
}
tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close


/*********************Change of beliefs*********************/
use "data_policy.dta", clear

//Transform in Post-Pre
replace diff_abs_bias_toptrue=-diff_abs_bias_toptrue
summ diff_abs_bias_toptrue
replace diff_abs_bias_toprep=-diff_abs_bias_toprep
summ diff_abs_bias_toprep
replace diff_abs_bias_bottomrep=-diff_abs_bias_bottomrep
summ diff_abs_bias_bottomrep
replace diff_abs_pbias_toptrue=-diff_abs_pbias_toptrue
summ diff_abs_pbias_toptrue
replace diff_abs_pbias_toprep=-diff_abs_pbias_toprep
summ diff_abs_pbias_toprep
replace diff_abs_pbias_bottomrep=-diff_abs_pbias_bottomrep
summ diff_abs_pbias_bottomrep

reg diff_abs_bias_toptrue open i.risk_label ///
ptje_lect_bl bias_mate1 bias_clec ptje_m1_bl ///
if in_survey_before_after == 1 & not_fixed!=1, ///
vce(robust)
scalar scal_m1=_b[open]
scalar scal_m1sd=_se[open]

reg diff_abs_bias_toprep open i.risk_label ///
ptje_lect_bl bias_mate1 bias_clec ptje_m1_bl ///
if in_survey_before_after == 1 & not_fixed!=1, ///
vce(robust)
scalar scal_m2=_b[open]
scalar scal_m2sd=_se[open]

reg diff_abs_bias_bottomrep open i.risk_label ///
ptje_lect_bl bias_mate1 bias_clec ptje_m1_bl ///
if in_survey_before_after == 1 & not_fixed!=1, ///
vce(robust)
scalar scal_m3=_b[open]
scalar scal_m3sd=_se[open]

reg diff_abs_pbias_toptrue open i.risk_label ///
ptje_lect_bl bias_mate1 bias_clec ptje_m1_bl ///
if in_survey_before_after == 1 & not_fixed!=1, ///
vce(robust)
scalar scal_m4=_b[open]
scalar scal_m4sd=_se[open]

reg diff_abs_pbias_toprep open i.risk_label ///
ptje_lect_bl bias_mate1 bias_clec ptje_m1_bl ///
if in_survey_before_after == 1 & not_fixed!=1, ///
vce(robust)
scalar scal_m5=_b[open]
scalar scal_m5sd=_se[open]

reg diff_abs_pbias_bottomrep open i.risk_label ///
ptje_lect_bl bias_mate1 bias_clec ptje_m1_bl ///
if in_survey_before_after == 1 & not_fixed!=1, ///
vce(robust)
scalar scal_m6=_b[open]
scalar scal_m6sd=_se[open]

cap program drop add
program def add

forvalues m = 1/6  {
local m`m': di %6.4fc scal_m`m'
local m`m'_sd: di %6.4fc scal_m`m'sd
local m`m'_sd= subinstr("(`m`m'_sd')", " ", "", .)
}

tex `1' &  `m1' & `m2' & `m3' &  `m4'&  `m5' &  `m6'  \\
tex &    `m1_sd' &  `m2_sd' &  `m3_sd' & `m4_sd' & `m5_sd' &  `m6_sd'  \\
end



cap program drop add_bottom
program def add_bottom

quietly summ diff_abs_bias_toptrue if open==0  & ///
in_survey_before_after == 1 & not_fixed!=1
local mean_m1: di %6.4fc r(mean)
quietly summ diff_abs_bias_toptrue if in_survey_before_after == 1 & ///
 not_fixed!=1
local N_m1: di %15.0fc r(N)

quietly summ diff_abs_bias_toprep if open==0  & ///
in_survey_before_after == 1 & not_fixed!=1
local mean_m2: di %6.4fc r(mean)
quietly summ diff_abs_bias_toprep if in_survey_before_after == 1 & ///
 not_fixed!=1
local N_m2: di %15.0fc r(N)

quietly summ diff_abs_bias_bottomrep if open==0  & ///
in_survey_before_after == 1 & not_fixed!=1
local mean_m3: di %6.4fc r(mean)
quietly summ diff_abs_bias_bottomrep if in_survey_before_after == 1 & ///
 not_fixed!=1
local N_m3: di %15.0fc r(N)

quietly summ diff_abs_pbias_toptrue if open==0  & ///
in_survey_before_after == 1 & not_fixed!=1
local mean_m4: di %6.4fc r(mean)
quietly summ diff_abs_pbias_toptrue if in_survey_before_after == 1 & ///
 not_fixed!=1
local N_m4: di %15.0fc r(N)

quietly summ diff_abs_pbias_toprep if open==0  & ///
in_survey_before_after == 1 & not_fixed!=1
local mean_m5: di %6.4fc r(mean)
quietly summ diff_abs_pbias_toprep if in_survey_before_after == 1 & ///
 not_fixed!=1
local N_m5: di %15.0fc r(N)

quietly summ diff_abs_pbias_bottomrep if open==0  & ///
in_survey_before_after == 1 & not_fixed!=1
local mean_m6: di %6.4fc r(mean)
quietly summ diff_abs_pbias_toprep if in_survey_before_after == 1 & ///
 not_fixed!=1
local N_m6: di %15.0fc r(N)



tex Mean (Not Opening) &  `mean_m1' & `mean_m2' & `mean_m3' &  `mean_m4' &  `mean_m5' &  `mean_m6' \\
tex  Observations &    `N_m1' &  `N_m2' &  `N_m3' & `N_m4' & `N_m5' & `N_m6' \\
tex   Risk Group &  Yes  & Yes  & Yes  & Yes  & Yes & Yes   \\
tex  Controls  &  Yes  & Yes  & Yes  & Yes  & Yes & Yes   \\

end


texdoc init "tables/policy/main_policybias.tex", replace force
tex \begin{table}[h]
tex \caption{Regression Results: Reduction in Absolute Bias}\label{tab:main_policybias}
tex \centering
tex   \footnotesize
tex  \begin{threeparttable}
tex \renewcommand{\arraystretch}{1.2}
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex \begin{tabular}{@{\extracolsep{5pt}}lcccccc} 
tex \toprule
tex & \multicolumn{3}{c}{Cutoffs} & \multicolumn{3}{c}{Adm. Probs.} \\
tex \cmidrule(lr){2-4} \cmidrule(lr){5-7}
tex & Top-true & Top-reported & Bottom-reported & Top-true & Top-reported & Bottom-reported \\
tex & (1) & (2) & (3) & (4) & (5) & (6)\\
tex \hline 
add "Open" open
tex \hline
add_bottom
tex     \bottomrule
tex     \end{tabular} 
tex     \begin{tablenotes}
tex \item \scriptsize \textsc{Notes.} The sample considers all students who answered the questions related to the expected cutoffs or admission probabilities in the 2023 baseline and endline surveys. Robust standard errors are reported in parentheses.

tex \end{tablenotes}
tex \end{threeparttable}
tex \end{table}
texdoc close
