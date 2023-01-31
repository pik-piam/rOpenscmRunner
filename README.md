# Run different simple climate models from R using a unified interface

R package **rOpenscmRunner**, version **0.3.3**

[![CRAN status](https://www.r-pkg.org/badges/version/rOpenscmRunner)](https://cran.r-project.org/package=rOpenscmRunner)  [![R build status](https://github.com/pik-piam/rOpenscmRunner/workflows/check/badge.svg)](https://github.com/pik-piam/rOpenscmRunner/actions) [![codecov](https://codecov.io/gh/pik-piam/rOpenscmRunner/branch/master/graph/badge.svg)](https://app.codecov.io/gh/pik-piam/rOpenscmRunner) [![r-universe](https://pik-piam.r-universe.dev/badges/rOpenscmRunner)](https://pik-piam.r-universe.dev/builds)

## Purpose and Functionality

Using openscm-runner, you can run different simple climate models using a unified API. It supports emissions-driven runs only. rOpenscmRunner is a wrapper to easily use openscm-runner from R.


## Installation

For installation of the most recent package version an additional repository has to be added in R:

```r
options(repos = c(CRAN = "@CRAN@", pik = "https://rse.pik-potsdam.de/r/packages"))
```
The additional repository can be made available permanently by adding the line above to a file called `.Rprofile` stored in the home folder of your system (`Sys.glob("~")` in R returns the home directory).

After that the most recent version of the package can be installed using `install.packages`:

```r 
install.packages("rOpenscmRunner")
```

Package updates can be installed using `update.packages` (make sure that the additional repository has been added before running that command):

```r 
update.packages()
```

## Tutorial

The package comes with a vignette describing the basic functionality of the package and how to use it. You can load it with the following command (the package needs to be installed):

```r
vignette("rOpenscmRunner") # rOpenscmRunner
```

## Questions / Problems

In case of questions / problems please contact Mika Pflüger <mika.pflueger@pik-potsdam.de>.

## Citation

To cite package **rOpenscmRunner** in publications use:

Pflüger M (2023). _rOpenscmRunner: Run different simple climate models from R using a unified interface_. R package version 0.3.3, <https://github.com/pik-piam/rOpenscmRunner>.

A BibTeX entry for LaTeX users is

 ```latex
@Manual{,
  title = {rOpenscmRunner: Run different simple climate models from R using a unified interface},
  author = {Mika Pflüger},
  year = {2023},
  note = {R package version 0.3.3},
  url = {https://github.com/pik-piam/rOpenscmRunner},
}
```
