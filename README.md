
This repository contains the Stata code to replicate the results from "[Insurance and Welfare:
Causal Effects of the Affordable Care Act](https://vaolh.github.io/obamacare.pdf)" by Victor Ortega (me) and Thalia Pivert.
This is not a complete replication package, as it only includes the code. You can download the full replication package with all data from [my website](https://vaolh.github.io/research#:~:text=ECN190.%20UC%20Davis.-,Replication.,-Slides.).


## Code

All data is in the folder /data. To access this data you must download the full replication from the link above. All data transformed and used for estimation is in the folder /sets.  The do files are in the folder /pgm. They export all tables and graphs individually to folders /tables and /graphs. The code to run the tex document is in the folder /tex, also available in the link above. All of the figures and data from the Appendix are in the same folders in a subfolder /appendix.

```
obamacare
├─data
├─graphs
├─pgm
├─sets
├─tables
└─tex
```

## Software requirements

We use [Stata](http://www.stata.com) 18.5 SE on macOS Sequoia (version 15).

## Notes

This was the final project for the ECN190 class at UC Davis by professor [A. Colin Cameron](https://cameron.econ.ucdavis.edu). We thank him for his guidance.

