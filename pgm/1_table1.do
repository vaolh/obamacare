/*Clean Memory*/

clear
cap clear
cap log close
set more off

*** REPLICATION FILE: 1_table1
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

/*Set Global Variables*/
gen linc = ln(inctot)
gen lwage = ln(incwage)

gl variables black female emp education health marst medicare medicaid private group linc lwage lmoop lcsamdue lcsamrec 

/*Table 1: Difference in means table */

eststo allunits: quietly estpost summarize $variables
eststo treat: quietly estpost summarize $variables if expand == 0                                              
eststo control: quietly estpost summarize $variables if expand == 1
eststo diff: quietly estpost ttest $variables, by(expand) unequal
	
esttab allunits treat control diff using "$tables/table_1.tex", ///
cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))" "sd(pattern(1 1 1 0) par fmt(2)) t(pattern(0 0 0 1) par fmt(2))") ///
label replace

*** We clean up this tex file manually
