/*Clean Memory*/

clear
cap clear
cap log close
set more off

/*Install Programs*/

cap ssc install matchit

*** REPLICATION FILE: 3_table3
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

gl covar age agesq i.female i.educ i.marst


/*Table 2: Private Insurance*/

****** Panel A: Private

* Controls
reghdfe private i.post##i.treat $covar linc, vce(cluster ind) absorb(i.year)
	 eststo t3m1				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"
			
* State Fixed Effects
reghdfe private i.post##i.treat $covar linc, vce(cluster ind) absorb(i.year i.statefip)
	 eststo t3m2				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "N"

* Industry + State Fixed Effects
reghdfe private i.post##i.treat $covar linc, vce(cluster ind) absorb(i.year i.statefip i.ind)
	 eststo t3m3				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Sanity Check Using didreg Command
didregress ( private $covar ) (postbytreat), group(expand) t(year) vce(cluster ind)
didregress (private $covar i.statefip) (postbytreat), group(expand) t(year) vce(cluster ind)
didregress (private $covar i.statefip i.ind) (postbytreat), group(expand) t(year) vce(cluster ind)

* Sanity Check Using reg Command
reg private i.post##i.treat $covar i.year, vce(cluster ind)
reg private i.post##i.treat $covar i.statefip i.year, vce(cluster ind)
reg private i.post##i.treat $covar i.statefip i.year i.ind, vce(cluster ind)

****** Panel B: Group

* Controls
reghdfe group i.post##i.treat $covar , vce(cluster ind) absorb(i.year)
	 eststo t3m4				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"
			
* State Fixed Effects
reghdfe group i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.statefip)
	 eststo t3m5				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "N"

* Industry + State Fixed Effects
reghdfe group i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.statefip i.ind)
	 eststo t3m6				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"


esttab 	t3m1 t3m2 t3m3 t3m4 t3m5 t3m6 ///
			using "$tables/table_3",  replace label fragment ///
			nolines  posthead(\cmidrule{2-7}) prefoot(\midrule) postfoot(\bottomrule \bottomrule) booktabs ///
			nonumbers mtitle("(1)" "(2)" "(3)" "(1)" "(2)" "(3)") collabels(none)    ///
			cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///						
			keep(1.post#1.treat)   ///
			coeflabel(1.post#1.treat "{ACA $\times$ 2012-2016}") ///
			stats(N hascontrols hastimefe hasstatefe hasindustryfe, ///
			fmt(%11.0gc) label("Observations" "Controls" "Time FE" "State FE" "Industry FE")) onecell 
