/*Clean Memory*/

clear
cap clear
cap log close
set more off

/*Install Programs*/

cap ssc install matchit

*** REPLICATION FILE: 2_table2
*** STATA VERSION: 18/SE
*** AUTHOR: Thalia Pivert
*** EMAIL: thalia.pivert@gmail.com
*** AUTHOR: Victor Alfonso Ortega Le Hénanff
*** EMAIL: vincictor33@gmail.com
*** DATE: 2024-11-20

/*Base Directory and Set Subdirectories*/

global project="/Users/victorortega/Dropbox/obamacare"

gl data="$project/data"
gl graphs="$project/graphs"
gl tables="$project/tables"
gl pgm="$project/pgm"
gl sets="$project/sets"

/*Load Data*/

use "$sets/estimation.dta", clear

/*Interaction Variables and Covariates*/

gen post = (year == 2016)
gen treat = (expand == 1)
by treat post, sort: summarize private

 
gen postbytreat = post*treat
gen agesq = age*age
gen lwage = ln(incwage)
gen linc = ln(inctot)

gl covar age agesq i.female i.educ i.marst linc


/*Table 1: Medicaid Access*/

****** Panel A: Medicaid All

* Controls
reghdfe medicaid i.post##i.treat $covar , vce(cluster ind) absorb(i.year)
	 eststo t1m1				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hascountyfe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe medicaid i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.ind i.county i.statefip)
	 eststo t1m2				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hascountyfe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Sanity Check Using didreg Command
didregress ( private $covar ) (postbytreat), group(expand) t(year) vce(cluster ind)
didregress (private $covar i.statefip i.ind) (postbytreat), group(expand) t(year) vce(cluster ind)

* Sanity Check Using reg Command
reg private i.post##i.treat $covar i.year, vce(cluster ind)
reg private i.post##i.treat $covar i.statefip i.year i.ind, vce(cluster ind)


****** Panel B: Medicaid White

* Controls
reghdfe medicaid i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year)
	 eststo t1m3			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hascountyfe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe medicaid i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year i.ind i.county i.statefip)
	 eststo t1m4				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hascountyfe 	 "Y"
			estadd local hasindustryfe 	 "Y"
			
			
****** Panel C: Medicaid AA

* Controls
reghdfe medicaid i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year)
	 eststo t1m5			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hascountyfe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe medicaid i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t1m6				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hascountyfe 	 "Y"
			estadd local hasindustryfe 	 "Y"


esttab 	t1m1 t1m2 t1m3 t1m4 t1m5 t1m6 ///
			using "$tables/table_2",  replace label fragment ///
			nolines  posthead(\cmidrule{2-7}) prefoot(\midrule) postfoot(\bottomrule \bottomrule) booktabs ///
			nonumbers mtitle("(1)" "(2)" "(1)" "(2)" "(1)" "(2)") collabels(none)    ///
			cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///						
			keep(1.post#1.treat)   ///
			coeflabel(1.post#1.treat "{ACA $\times$ 2012-2016}") ///
			stats(N hascontrols hastimefe hasstatefe hascountyfe hasindustryfe, ///
			fmt(%11.0gc) label("Observations" "Controls" "Time FE" "State FE" "County FE" "Industry FE")) onecell 
