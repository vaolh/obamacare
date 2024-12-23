
set more off

clear
cap clear
cap log close
set more off

/*Install Programs*/

cap ssc install matchit

*** REPLICATION FILE: Table 2
*** STATA VERSION: 18/SE
*** AUTHOR: Thalia Pivert
*** EMAIL: @ucdavis.edu
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

use "$sets/database.dta", clear 

//Graph 
collapse (mean) medicare medicaid private group, by(year expand)

graph twoway ///
    (line medicare year if expand == 1, lcolor(blue) lpattern(solid)) ///
    (line medicaid year if expand == 1, lcolor(green) lpattern(solid)) ///
    (line private year if expand == 1, lcolor(red) lpattern(solid)) ///
    (line group year if expand == 1, lcolor(orange) lpattern(solid)), ///
    title("States with Expansion") ///
    xlabel(2014(1)2016) xtitle("Année") ///
    ylabel(, angle(horizontal)) ytitle("Coverage (%)") ///
    legend(order(1 "Private insurance" 2 "Medicaid" 3 "Medicare" 4 "Group insurance") col(1)) ///
    name(expansion_graph, replace)
	
graph twoway ///
    (line medicare year if expand == 0, lcolor(blue) lpattern(solid)) ///
    (line medicaid year if expand == 0, lcolor(green) lpattern(solid)) ///
    (line private year if expand == 0, lcolor(red) lpattern(solid)) ///
    (line group year if expand == 0, lcolor(orange) lpattern(solid)), ///
    title("States without Expansion") ///
    xlabel(2014(1)2016) xtitle("Année") ///
    ylabel(, angle(horizontal)) ytitle("Coverage (%)") ///
    legend(order(1 "Private insurance" 2 "Medicaid" 3 "Medicare" 4 "Group insurance") col(1)) ///
    name(non_expansion_graph, replace)

graph combine expansion_graph non_expansion_graph, ///
    title("Comparison of Coverage : Expansion vs Non-Expansion")

	graph export "$graphs/fig_1.png", replace
