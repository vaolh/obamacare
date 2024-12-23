/*Clean Memory*/

clear
cap clear
cap log close
set more off

*** REPLICATION FILE: 0_database
*** STATA VERSION: 18/SE
*** AUTHOR: Thalia Pivert
*** EMAIL: thalia.pivert@gmail.com
*** AUTHOR: Victor Alfonso Ortega Le Hénanff
*** EMAIL: vincictor33@gmail.com
*** DATE: 2024-11-20

/*Base Directory and Set Subdirectories*/

global project="/Users/Thalia/Dropbox/obamacare"

gl data="$project/data"
gl graphs="$project/graphs"
gl tables="$project/tables"
gl pgm="$project/pgm"
gl sets="$project/sets"

/*Load Data*/

use "$data/cps_00005.dta"

/*Merge to get Expanse Variable*/

merge m:1 statefip using "$data/statefip_expand.dta"

gl variables group medicaid private medicare education emp female black health inctot incwage ind occ marst csamdue csamrec

/*Generate Variables and Clean Data*/

summarize
estpost summarize
esttab using "$tables/appendix/table_a1.tex", ///
    cells("mean sd min max") ///
    label ///
    title("Raw Data - Summary Statistics") ///
    alignment(lcccc) ///
    obslast ///
replace

keep if age>26 & age<65

gen black = .
replace black = 1 if race==200
replace black=0 if race != 200  

gen female=.
replace female=1 if sex==2 
replace female=0 if sex==1 

recode health (1=5) (2=4) (4=2) (5=1)

gen emp=.
replace emp=1 if empstat==01|empstat==10|empstat==12
replace emp=0 if empstat==20|empstat==21|empstat==22

gen education=educ
recode education (002 = 0) (010=1) (020=5) (030=7) (040=9) (050=10) (060=11) (071 073 081 091 092 =12) (111 =16) (123 124 =18) (125=20) 

gen medicare =. 
replace medicare = 1 if himcarely==2
replace medicare =0 if himcarely==1 

gen private =. 
replace private = 1 if coverpi==2
replace private =0 if coverpi==1 

gen medicaid =. 
replace medicaid = 1 if himcaidly==2
replace medicaid =0 if himcaidly==1 

gen group=.
replace group=1 if covergh==2
replace group=0 if covergh==1

replace offpov=0 if offpov==2

replace paidgh=. if paidgh==0
replace paidgh=0 if paidgh==10
replace paidgh=1 if paidgh==21 | paidgh==22
label define paidgh_lbl 00 `"No"', replace
label define paidgh_lbl 10 `"Yes"', replace
label values paidgh paidgh_lbl

gen paidall = paidgh
replace paidall=0 if paidall==21
replace paidall=1 if paidall==22

replace csamdue=. if csamdue==99999|csamdue==99998|csamdue==99997
replace csamrec=. if csamrec==99999|csamrec==99998|csamrec==99997

gen lmoop = ln(moop)
gen lcsamdue = ln(csamdue)
gen lcsamrec = ln(csamrec)

drop if expand == 2

save "$sets/estimation.dta", replace

summarize
