/*Clean Memory*/

clear
cap clear
cap log close
set more off

/*Install Programs*/

cap ssc install matchit

*** REPLICATION FILE: 4_table4
*** STATA VERSION: 18/SE
*** AUTHOR: Thalia Pivert
*** EMAIL: thalia.pivert@gmail.com
*** AUTHOR: Victor Alfonso Ortega Le Hénanff
*** EMAIL: vincictor33@gmail.com
*** DATE: 2024-12-1

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

/*Table 4: Welfare Effects*/

****** Panel A: Poverty

* Controls
reghdfe offpov i.post##i.treat $covar , vce(cluster ind) absorb(i.year)
	 eststo t4m1				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe offpov i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m2				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe offpov i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year)
	 eststo t4m3			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe offpov i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m4				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe offpov i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year)
	 eststo t4m5			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe offpov i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m6				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"
			
****** Panel B: Health Perception

* Controls
reghdfe health i.post##i.treat $covar , vce(cluster ind) absorb(i.year)
	 eststo t4m7				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe health i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m8				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe health i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year)
	 eststo t4m9			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe health i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m10				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe health i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year)
	 eststo t4m11			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe health i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m12				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

****** Panel C: Out of Pocket Medical Expenses

* Controls
reghdfe lmoop i.post##i.treat $covar , vce(cluster ind) absorb(i.year)
	 eststo t4m13				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe lmoop i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m14				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe lmoop i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year)
	 eststo t4m15			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe lmoop i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m16				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe lmoop i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year)
	 eststo t4m17			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe lmoop i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m18				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

****** Panel D: Child Support Recieved

* Controls
reghdfe lcsamrec i.post##i.treat $covar , vce(cluster ind) absorb(i.year)
	 eststo t4m19				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe lcsamrec i.post##i.treat $covar , vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m20				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe lcsamrec i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year)
	 eststo t4m21			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe lcsamrec i.post##i.treat $covar if black==0, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m22				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"

* Controls
reghdfe lcsamrec i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year)
	 eststo t4m23			
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "N"
			estadd local hasindustryfe 	 "N"

* Industry Fixed Effects
reghdfe lcsamrec i.post##i.treat $covar if black==1, vce(cluster ind) absorb(i.year i.ind i.statefip)
	 eststo t4m24				
			estadd local hascontrols 	 "Y"
			estadd local hastimefe 		 "Y"
			estadd local hasstatefe 	 "Y"
			estadd local hasindustryfe 	 "Y"
			
esttab 	t4m1 t4m2 t4m3 t4m4 t4m5 t4m6 using "$tables/table_4.tex", replace ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///					
    keep(1.post#1.treat) ///
    nonotes nolines
esttab t4m7 t4m8 t4m9 t4m10 t4m11 t4m12 using "$tables/table_4.tex", append ///
    title("Panel B: Health Perception") ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///					
    keep(1.post#1.treat) ///
	stats(N, fmt(%11.0gc)) ///
    nonotes no lines
esttab t4m13 t4m14 t4m15 t4m16 t4m17 t4m18 using "$tables/table_4.tex", append ///
    title("Panel C: Out of Pocket Medical Expenses") ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///					
    keep(1.post#1.treat) ///
    nonotes no lines
esttab t4m19 t4m20 t4m21 t4m22 t4m23 t4m24 using "$tables/table_4.tex", append ///
    title("Panel D: Child Support Recieved") ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///					
    keep(1.post#1.treat) ///
	stats(hascontrols hastimefe hasstatefe hasindustryfe, ///
	fmt(%11.0gc) label("Baseline" "Time FE" "State FE"  "Industry FE"))    
	nonotes no lines
	eststo clear
	








