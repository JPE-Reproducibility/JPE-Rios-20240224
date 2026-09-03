// =================================================
// =================================================
// Analysis - Displacement Effects
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
capture mkdir "$output_dir/tempfile"
capture mkdir "$output_dir/tables"
cd "$output_dir"
global data_path_cart "$data_dir"
global data_path_2022 "$data_dir"

//Import the csv file with program details in 2022
import delimited "$data_path_cart/carreras_2022.csv", clear

///Clean some variables
replace min_score_reg="." if min_score_reg=="NA"
replace min_score_bea="." if min_score_bea=="NA"
replace min_score_pace="." if min_score_pace=="NA"
replace cutoffs_bea="." if cutoffs_bea=="NA"
replace cutoffs_pace="." if cutoffs_pace=="NA"
destring min_score_reg min_score_bea min_score_pace ///
cutoffs_pace cutoffs_bea, replace

///Generate number regular empty seats
gen seats_empty_reg=vacantes_reg-num_admitted_reg

///Drop some variables
keep codigo_demre vacantes_bea vacantes_pace vacantes_reg ///
full_reg full_bea full_pace full_reg_wo_sobrecupo ///
num_admitted_* cutoffs_bea cutoffs_pace cutoffs_reg seats_empty_reg
 
save "$output_dir/data/carreras_v2_2022.dta", replace

///Descriptive stat

////Clean variables
replace full_bea="" if full_bea=="NA" 
replace full_pace="" if full_pace=="NA"
destring full_bea full_pace, replace

////Generate dummy if program is full
gen full_all=(full_reg==1 & full_bea==1 & full_pace==1)
tab full_reg
tab full_all

////Generate total number of empty seats
egen tot_emptyseats_reg=total(seats_empty_reg)
egen tot_seats_reg=total(vacantes_reg)

gen seats_empty_pace=vacantes_pace-num_admitted_pace
egen tot_emptyseats_pace=total(seats_empty_pace)
egen tot_seats_pace=total(vacantes_pace)

gen seats_empty_bea=vacantes_bea-num_admitted_bea
egen tot_emptyseats_bea=total(seats_empty_bea)
egen tot_seats_bea=total(vacantes_bea)

////Descriptives: regular empty seats
summ tot_emptyseats_reg
scalar scal_tot_emptyseats_reg=r(mean)
summ tot_seats_reg
scalar scal_tot_seats_reg=r(mean)
dis scal_tot_emptyseats_reg/scal_tot_seats_reg

////Descriptives: PACE empty seats
summ tot_emptyseats_pace
scalar scal_tot_emptyseats_pace=r(mean)
summ tot_seats_pace
scalar scal_tot_seats_pace=r(mean)
dis scal_tot_emptyseats_pace/scal_tot_seats_pace

////Descriptives: BEA empty seats
summ tot_emptyseats_bea
scalar scal_tot_emptyseats_bea=r(mean)
summ tot_seats_bea
scalar scal_tot_seats_bea=r(mean)
dis scal_tot_emptyseats_bea/scal_tot_seats_bea

////Descriptives: total empty seats
gen tot_vacant=tot_emptyseats_bea+ tot_emptyseats_pace+ tot_emptyseats_reg
gen tot_seats=tot_seats_bea +tot_seats_pace +tot_seats_reg
summ tot_vacant
scalar scal_tot_vacant=r(mean)
summ tot_seats
scalar scal_tot_seats=r(mean)
dis scal_tot_vacant/scal_tot_seats



/******************************************************************************/

//Load dataset 2022
import delimited "$data_path_2022/data_2022.csv", clear

//Stata's CSV import normalizes case, so raw BEA and processed bea collide.
//Keep the processed intervention variable, imported as v221 (label: bea).
capture confirm variable v221
if !_rc {
	drop bea
	rename v221 bea
}
rename codigo_carrera_assigned_int_t2t3 codcarr_assigned_intt2t3compfin
rename codigo_carrera_assigned_int_none codcarr_assigned_intnonecompfin

//Keep students who did apply
keep if codigo_carrera_1_fin!=.

//Generate some variables

///Scalars for number of control and out of RCT students
gen control=(treatment==1 | treatment==4)
summ control if control==1
scalar scal_ncontrol=r(N)
summ in_rct if in_rct==0
scalar scal_nout=r(N)
summ in_rct if in_rct==1 & control==0
scalar scal_nt2t3=r(N)
summ in_rct if treatment==3
scalar scal_nt3=r(N)

///Modify variables for PACE/BEA
gen prom_above450=(prom_mat_leng_pmax>=450)
replace pace="1" if pace=="PACE"
replace pace="0" if pace==""
destring pace, replace
replace bea="1" if bea=="BEA"
replace bea="0" if bea==""
destring bea, replace

///Generate the rank of the program in the final ROL
///regarding the program where the student would have been assigned
///in the counterfactual where we generate assignment with interim ROL T2/T3
gen prefassigned_intt23compfin_atfin=.
forval i= 1/10{
	replace prefassigned_intt23compfin_atfin=`i' ///
	if codcarr_assigned_intt2t3compfin==codigo_carrera_`i'_fin
}

///Generate the rank of the program in the final ROL
///regarding the program where the student would have been assigned
///in the counterfactual where we generate assignment with final ROL only
gen prefassigned_intnoncompfin_atfin=.
forval i= 1/10{
	replace prefassigned_intnoncompfin_atfin=`i' ///
	if codcarr_assigned_intnonecompfin==codigo_carrera_`i'_fin
}

///Replace by missing if unassigned
replace pref_assigned_fin=. if pref_assigned_fin==0
replace pref_assigned_int=. if pref_assigned_int==0
replace prefassigned_intnoncompfin_atfin=. if codcarr_assigned_intnonecompfin==0
replace prefassigned_intt23compfin_atfin=. if codcarr_assigned_intt2t3compfin==0

///Generate dummy for students who improved with all final ROL vs the 
///counterfactual where we generate assignment with interim ROL T2/T3
gen enter_impr= ///
((prefassigned_intnoncompfin_atfin < prefassigned_intt23compfin_atfin & ///
assigned_int_none_comp_fin==1 &  assigned_int_t2t3_comp_fin==1 & ///
prefassigned_intt23compfin_atfin!=.) | ///
(assigned_int_none_comp_fin==1 & assigned_int_t2t3_comp_fin==0))
///Replace enter_impr by missing for students in T2/T3 assigned to a program they
///did not rank in final ROL
replace enter_impr=. if ///
assigned_int_t2t3_comp_fin==1 & prefassigned_intt23compfin_atfin==.
//Generate a dummy for enter
gen enter=(assigned_int_none_comp_fin==1 & assigned_int_t2t3_comp_fin==0)

///Generate dummy for students who exited/worsen
gen worsen= ///
((prefassigned_intnoncompfin_atfin > prefassigned_intt23compfin_atfin  ///
& assigned_int_none_comp_fin==1 ///
& assigned_int_t2t3_comp_fin==1 & prefassigned_intt23compfin_atfin!=.) | ///
(assigned_int_none_comp_fin==0 & assigned_int_t2t3_comp_fin==1 ///
& prefassigned_intt23compfin_atfin!=.))
///Replace worsen by missing for students in T2/T3 assigned to a program they
///did not rank in final ROL
replace worsen=. if ///
assigned_int_t2t3_comp_fin==1 & prefassigned_intt23compfin_atfin==.
///Generate dummy for students who exited
gen leave=(assigned_int_none_comp_fin==0 & ///
assigned_int_t2t3_comp_fin==1)

//Analysis of gains
preserve

	//Merge with seat information - interim congestion of the final admission
	rename codcarr_assigned_intnonecompfin codigo_demre
	merge m:1 codigo_demre ///
	using "$data_path_cart/cutoffs_and_extras_intt2t3compfin.dta", ///
	keepusing(vacantes_* full* last* cutoff_reg seleccionados_reg)
	drop if _m==2
	drop _m
	
	tab full_reg if enter==1 & in_rct==1 & control==0 & open==1
	tab full_reg if enter_impr==1 & in_rct==1 & control==0 & open==1
	
restore

//Generate a dataset at the program level for assignment using final ROL
preserve

	//Count the number of students assigned to each program, final
	bys codcarr_assigned_intnonecompfin: egen n_assignedfin=count(mrun)

	//Merge with seat information - Final
	rename codcarr_assigned_intnonecompfin codigo_demre
	merge m:1 codigo_demre ///
	using "$data_path_cart/cutoffs_and_extras_intnonecompfin.dta", ///
	keepusing(vacantes_* full* last* cutoff_reg seleccionados_reg)
	drop _m

	///Get, by program of assignment final, the number of
	///students gaining admission there
	bys codigo_demre: ///
	egen nber_gainedadm_treat=total(enter_impr==1 & control==0 & in_rct==1)
	bys codigo_demre: ///
	egen nber_gainedadm_t3=total(enter_impr==1 & treatment==3 & in_rct==1)
	bys codigo_demre: ///
	egen nber_enter_treat=total(enter==1 & control==0 & in_rct==1)
	bys codigo_demre: ///
	egen nber_gainedadm_treatchanged=total(enter_impr==1 & control==0 ///
	& in_rct==1 & changed==1)	
	bys codigo_demre: ///
	egen nber_gainedadm_all=total(enter_impr==1)
	bys codigo_demre: ///
	egen nber_gainedadm_control=total(enter_impr==1 & control==1)
	bys codigo_demre: ///
	egen nber_gainedadm_out=total(enter_impr==1 & in_rct==0)
	bys codigo_demre: ///
	egen nber_gainedadm_open=total(enter_impr==1 & control==0 & in_rct==1 & open==1)
	bys codigo_demre: ///
	egen nber_gainedadm_open_chgd=total(enter_impr==1 & control==0 & in_rct==1 & open==1 & changed==1)
	bys codigo_demre: ///
	egen nber_enter_all=total(enter==1)
	bys codigo_demre: ///
	egen nber_enter_open=total(enter==1 & control==0 & in_rct==1 & open==1)
	bys codigo_demre: ///
	egen nber_enter_controlout=total(enter==1 & (in_rct==0 | control==1))
		
	replace n_assignedfin=0 if n_assignedfin==.
	gen seats_empty_all_fin=vacantes_reg+vacantes_bea+vacantes_pace- ///
	n_assignedfin
	gen seats_empty_reg_fin=vacantes_reg-seleccionados_reg
	
	keep codigo_demre ///
	nber_gainedadm* nber_enter_* n_assignedfin ///
	seats_empty_all_fin seats_empty_reg_* ///
	full_reg full_bea full_pace ///
	cutoff_reg ///
	last_from_t0 last_from_t1 last_from_t2 last_from_t3 last_from_t4 last_control

	duplicates drop 
	
	save "tempfile/progr_assign_fin.dta", replace

restore	

//Generate a dataset at the program level for assignment using final ROL of T1,
//T4 and out of RCT students, but interim ROL of T2/T3
preserve

	//Count the number of students assigned to each program
	bys codcarr_assigned_intt2t3compfin: egen n_assigned_intt2t3compfin=count(mrun)

	//Merge with seat information - Final
	rename codcarr_assigned_intt2t3compfin codigo_demre
	merge m:1 codigo_demre ///
	using "$data_path_cart/cutoffs_and_extras_intt2t3compfin.dta", ///
	keepusing(vacantes_* full* last* seleccionados_reg cutoff_reg)
	drop _m	

	
	///Get, by program of assignment final, the number of
	///students loosing admission from this program
	bys codigo_demre: ///
	egen nber_looseadm_control=total(worsen==1 & control==1)
	bys codigo_demre: ///
	egen nber_leave_control=total(leave==1 & control==1)
	bys codigo_demre: ///
	egen nber_looseadm_all=total(worsen==1)
	bys codigo_demre: ///
	egen nber_looseadm_control_unch=total(worsen==1 & control==1 & changed==0)
	bys codigo_demre: ///
	egen nber_looseadm_outrct=total(worsen==1 & in_rct==0)
	bys codigo_demre: ///
	egen nber_looseadm_treat=total(worsen==1 & in_rct==1 & control==0)
	bys codigo_demre: ///
	egen nber_looseadm_contout=total(worsen==1 & (in_rct==0 | control==1))
	bys codigo_demre: ///
	egen nber_leave_contout=total(leave==1 & (in_rct==0 | control==1))
	bys codigo_demre: ///
	egen nber_leave_treat=total(leave==1 & in_rct==1 & control==0)
	bys codigo_demre: ///
	egen nber_leave_out=total(leave==1 & in_rct==0 )	
	bys codigo_demre: ///
	egen nber_leave_all=total(leave==1)

	replace n_assigned_intt2t3compfin=0 if n_assigned_intt2t3compfin==.
	gen seats_empty_all_intt2t3compfin= ///
	vacantes_reg+vacantes_bea+vacantes_pace- ///
	n_assigned_intt2t3compfin
	gen seats_empty_reg_intt2t3compfin=vacantes_reg-seleccionados_reg
	
	rename full_reg      full_reg_intt2t3compfin
	rename full_pace     full_pace_intt2t3compfin  
	rename full_bea      full_bea_intt2t3compfin
	rename last_from_t0  last_from_t0_intt2t3compfin
	rename last_from_t1  last_from_t1_intt2t3compfin
	rename last_from_t2  last_from_t2_intt2t3compfin
	rename last_from_t3  last_from_t3_intt2t3compfin
	rename last_from_t4  last_from_t4_intt2t3compfin
	rename last_control  last_control_intt2t3compfin
	rename cutoff_reg    cutoff_reg_intt2t3compfin
	
	keep codigo_demre ///
	nber_loose* nber_leave* n_assigned_intt2t3compfin ///
	seats_empty_* ///
	cutoff_reg ///
	full_reg_intt2t3compfin  ///
	full_reg_intt2t3compfin ///
	full_pace_intt2t3compfin  ///
	full_bea_intt2t3compfin ///
	last_from_t0_intt2t3compfin ///
	last_from_t1_intt2t3compfin ///
	last_from_t2_intt2t3compfin ///
	last_from_t3_intt2t3compfin ///
	last_from_t4_intt2t3compfin ///
	last_control_intt2t3compfin 
	
	duplicates drop
	
	save "tempfile/progr_assign_intt2t3compfin.dta", replace

restore


//Analysis at the program level
use "tempfile/progr_assign_intt2t3compfin.dta", clear

//Merge the assignment info of the match using all final ROL
	merge 1:1 codigo_demre using "tempfile/progr_assign_fin.dta"
	drop _m

//Drop the outside option	
	drop if codigo_demre==0
	
//Check how much room for displacement of control student
	gen progr_lastc_intt2t3compfin=(last_control_intt2t3compfin==1 & ///
	seats_empty_all_intt2t3compfin<=0)
	tab progr_lastc_intt2t3compfin
		
	gen progr_lastc_gaint_t2t3int=(last_control_intt2t3compfin==1 ///
	& seats_empty_all_intt2t3compfin<=0 ///
	& nber_gainedadm_treat>0)
	tab progr_lastc_gaint_t2t3int

	gen cutoff_inc=cutoff_reg-cutoff_reg_intt2t3compfin
	summ cutoff_inc if cutoff_inc>0 & seats_empty_reg_intt2t3compfin<=0
	summ cutoff_inc if cutoff_inc<0 & seats_empty_reg_intt2t3compfin<=0	

//Generate some variables	
///Number winners, by group
	egen total_gain_all=total(nber_gainedadm_all)
	egen total_gain_t3=total(nber_gainedadm_t3)
	egen total_gain_treat=total(nber_gainedadm_treat)	
	egen total_gain_open=total(nber_gainedadm_open)
	egen total_gain_open_chgd=total(nber_gainedadm_open_chgd)	
	egen total_gain_control=total(nber_gainedadm_control)
	egen total_gain_out=total(nber_gainedadm_out)
	egen total_gain_treatchanged=total(nber_gainedadm_treatchanged)
	
	egen total_enter_treat=total(nber_enter_treat)
	egen total_enter_open=total(nber_enter_open)
	egen total_enter_controlout=total(nber_enter_controlout)
	egen total_enter_all=total(nber_enter_all)
	
///Number loosers, by group	
	egen total_losscontrol=total(nber_looseadm_control)
	egen total_lossall=total(nber_looseadm_all)
	egen total_losscontrol_unch=total(nber_looseadm_control_unch)
	egen total_losscontrol_out=total(nber_looseadm_contout)
	egen total_loss_out=total(nber_looseadm_outrct)
	egen total_loss_treat=total(nber_looseadm_treat)
	
	egen total_leave_control=total(nber_leave_control)
	egen total_leave_control_out=total(nber_leave_contout)	
	egen total_leave_treat=total(nber_leave_treat)
	egen total_leave_out=total(nber_leave_out)
	egen total_leave_all=total(nber_leave_all)

//Descriptives on displacements
	summ total_gain_all
	scal scal_total_gain_all=r(mean)	
	summ total_gain_treat
	scal scal_total_gain_treat=r(mean)		
	summ total_gain_t3
	scal scal_total_gain_t3=r(mean)	
	summ total_gain_open
	summ total_gain_control	
	scal scal_total_gain_control=r(mean)
	summ total_gain_out
	summ total_gain_treatchanged
	summ total_gain_open_chgd
	summ total_enter_open
	summ total_enter_treat
	summ total_enter_controlout
	summ total_enter_all
	scalar scal_tot_enter_all=r(mean)
	
	summ total_lossall
	summ total_losscontrol_unch
	summ total_loss_out
	scal scal_total_loss_out=r(mean)
	summ total_loss_treat	
	scal scal_total_loss_treat=r(mean)
	summ total_leave_control
	scal scal_tot_leave_cont=r(mean)
	summ total_leave_all
	scal scal_tot_leave_all=r(mean)	
	summ total_leave_out
	scal scal_tot_leave_out=r(mean)			
	summ total_losscontrol
	scal scal_total_loss_control=r(mean)
	summ total_leave_treat
	scal scal_tot_leave_treat=r(mean)		
	
	egen tot_seatsempty_intt2t3compfin=total(seats_empty_all_intt2t3compfin)
	summ tot_seatsempty_intt2t3compfin
	scalar scal_seatsempty_intt2t3compfin=r(mean)
	egen tot_seatsempty_fin=total(seats_empty_all_fin)
	summ tot_seatsempty_fin
	scalar scal_seatsempty_fin=r(mean)
		
		
//Decomposition of students entering
	///Filled empty seats:
	dis (tot_seatsempty_intt2t3compfin-scal_seatsempty_fin)
	dis (scal_seatsempty_fin-tot_seatsempty_intt2t3compfin)/tot_seatsempty_intt2t3compfin
	dis (tot_seatsempty_intt2t3compfin-scal_seatsempty_fin)/scal_tot_enter_all
	///Students leaving (displacement effect)
	dis scal_tot_leave_all/scal_tot_enter_all
	dis scal_tot_leave_treat/scal_tot_enter_all
	dis scal_tot_leave_cont/scal_tot_enter_all	
	dis scal_tot_leave_out/scal_tot_enter_all		
	///Shares sum to one
	dis ((tot_seatsempty_intt2t3compfin-scal_seatsempty_fin)+scal_tot_leave_all)/scal_tot_enter_all
	
//Students in control group loosing
	dis scal_total_loss_control
	dis scal_total_loss_control/scal_ncontrol
//Students in out of RCT loosing
	dis scal_total_loss_out
	dis scal_total_loss_out/scal_nout
//Students in T2/T3 RCT gaining
	dis scal_total_gain_treat
	dis scal_total_gain_treat/scal_nt2t3
//Students in T2/T3 RCT gaining
	dis scal_total_gain_t3/scal_nt3
		
//Descriptives on characteristics of programs where treated gain admission
	///Empty seats
	gen any_gainedadm=(nber_gainedadm_treat!=0)
	summ seats_empty_reg_intt2t3compfin if any_gainedadm==1, detail
	summ seats_empty_reg_fin if any_gainedadm==1, detail
	tab full_reg if any_gainedadm==1 
	tab full_reg_intt2t3compfin if any_gainedadm==1 

	
	//Heterogeneity in pref
	tab any_gainedadm
	tab nber_gainedadm_treat
	summ nber_gainedadm_treat if any_gainedadm==1, detail
	summ nber_gainedadm_treat, detail

//Check whether programs that students add to their list are over-subscribed 
//Using official cutoff
use "data/data_rct.dta", clear

///Keep a few variables only
keep mrun treatment codigo_carrera_*_int codigo_carrera_*_fin open ///
strata* general_message

gen any_new=0
forval i= 1/10{
	gen new_`i'=0
	replace new_`i'=codigo_carrera_`i'_fin if ///
	codigo_carrera_`i'_fin!=codigo_carrera_1_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_2_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_3_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_4_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_5_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_6_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_7_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_8_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_9_int & ///
	codigo_carrera_`i'_fin!=codigo_carrera_10_int
	replace any_new=1 if new_`i'!=0
}
drop codigo*

reshape long new_, i(mrun) j(rank)

rename new_ codigo_demre 
merge m:1 codigo_demre using "data/carreras_v2_2022.dta", keepusing(full*)
drop if _m==2

tab full_reg if (treatment==2 | treatment==3) & open==1

bys mrun: egen add_fullregmin=min(full_reg)

duplicates drop mrun, force

gen control = 0
gen treat2 = 0
gen treat3 = 0
replace control = 1 if (treatment == 1 | treatment == 4)
replace treat2 = 1 if treatment == 2
replace treat3 = 1 if treatment == 3

replace add_fullregmin=0 if add_fullregmin==.

drop if any_new==0

tab add_fullregmin
tab add_fullregmin if (treatment==2 | treatment==3)

//Check whether programs they gain assignment to are over-subscribed
//Using official cutoff
use "data/data_rct.dta", clear

//keep a few var only	
keep mrun treatment entered improved open ///
codigo_carrera_assigned_int codigo_carrera_assigned_fin ///
strata* general*

rename codigo_carrera_assigned_fin codigo_demre 
merge m:1 codigo_demre using "data/carreras_v2_2022.dta", keepusing(full*)
drop if _m==2

tab full_reg if (treatment==2 | treatment==3) & open==1 & entered==1
tab full_reg if (treatment==2 | treatment==3) & open==1 & improved==1

//Check whether programs gain assignment to are over-subscribed
//Using interim cutoff
use "data/data_rct.dta", clear

//keep a few var only	
keep mrun assigned_fin  assigned_int treatment entered improved open ///
codigo_carrera_assigned_int codigo_carrera_assigned_fin strata* general_mess

tab assigned_int
tab assigned_fin

rename codigo_carrera_assigned_fin codigo_demre 
merge m:1 codigo_demre using "$data_path_cart/cutoffs_and_extras_intt2t3compfin.dta", keepusing(full*)
drop if _m==2

tab full_reg if entered==1
tab full_reg if (treatment==2 | treatment==3) & open==1 & entered==1
tab full_reg if (treatment==2 | treatment==3) & open==1 & improved==1
tab full_reg if (treatment==2 | treatment==3) & open==1 ///
& (improved==1 |  entered==1)
tab full_reg if  (improved==1 |  entered==1)
