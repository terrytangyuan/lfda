## Test environments
* local Windows 8 install, R 3.2.1
* OS X (on travis-ci), R 3.2.1
* Ubuntu 12.04 (on travis-ci), R 3.2.1
* win-builder (devel and release)

## R CMD check results
* There were no ERRORs, WARNINGs. 
* One NOTE from `checking CRAN incoming feasibility ...` can be safely ignored since this is just a note that reminds CRAN maintainers to check that the submission comes actually from his maintainer and not anybody else according to [this](https://mailman.stat.ethz.ch/pipermail/r-devel/2014-March/068497.html).  
* Another NOTE from `checking CRAN incoming feasibility ...` can be safely ignored as well since it's a note that reminds notifies CRAN that this is a new maintainer/submission. 