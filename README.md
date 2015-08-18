[![Travis-CI Build Status](https://travis-ci.org/terrytangyuan/lfda.svg?branch=master)](https://travis-ci.org/terrytangyuan/lfda)
[![Coverage Status](https://coveralls.io/repos/terrytangyuan/lfda/badge.svg?branch=master)](https://coveralls.io/r/terrytangyuan/lfda?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/lfda)](http://cran.r-project.org/web/packages/lfda)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat)](http://badges.mit-license.org)

# lfda
R package for performing and visualizing *Local Fisher Discriminant Analysis*, *Kernel Local Fisher Discriminant Analysis*, and *Semi-supervised Local Fisher Discriminant Analysis*.
Introduction to the algorithms and their application can be found [here](https://gastrograph.com/resources/whitepapers/local-fisher-discriminant-analysis-on-beer-style-clustering.html) and [here](http://www.ms.k.u-tokyo.ac.jp/software.html#LFDA). 

## Install the current release from CRAN:
```{R}
install.packages('lfda')
```

## Install the latest development version from github:
```{R}
devtools::install_github('terrytangyuan/lfda')
```

## Examples
### Local Fisher Discriminant Analysis(LFDA)
Suppose we want to reduce the dimensionality of the original data set (we are using `iris` data set here) to 3, then we can run the following:
```{R}
k <- iris[,-5] # this matrix contains all the predictors to be transformed
y <- iris[,5] # this should be a vector that represents different classes
r <- 3 # dimensionality of the resulting matrix

# run the model, note that two other kinds metrics we can use: 'weighted' and 'orthonormalized'
model <- lfda(k, y, r, metric = "plain") 

plot(model, y) # 3D visualization of the resulting transformed data set

predict(model, iris[,-5]) # transform new data set using predict

```
### Kernel Local Fisher Discriminant Analysis(KLFDA)
The main usage is the same except for an additional `kmatrixGauss` call to the original data set to perform a kernel trick: 
```{R}
k <- kmatrixGauss(iris[,-5])
y <- iris[,5]
r <- 3
model <- klfda(k, y, r, metric = "plain")

```
Note that the `predict` method for klfda is still under development. The `plot` method works the same way as in `lfda`.

### Semi-supervised Local Fisher Discriminant Analysis(SELF)
This algorithm requires one additional argument such as `beta` that represents the degree of semi-supervisedness. Let's assume we ignore 10% of the labels in `iris` data set:
```{R}
k <- iris[,-5]
y <- iris[,5]
r <- 3
model <- self(k, y, beta = 0.1, r = 3, metric = "plain")

```
The methods `predict` and `plot` work the same way as in `lfda`. 
