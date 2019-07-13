[![Travis-CI Build Status](https://travis-ci.org/terrytangyuan/lfda.svg?branch=master)](https://travis-ci.org/terrytangyuan/lfda)
[![Coverage Status](https://coveralls.io/repos/terrytangyuan/lfda/badge.svg?branch=master)](https://coveralls.io/r/terrytangyuan/lfda?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/lfda)](https://cran.r-project.org/package=lfda)
[![Downloads from the RStudio CRAN mirror](https://cranlogs.r-pkg.org/badges/grand-total/lfda)](https://cran.r-project.org/package=lfda)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat)](http://badges.mit-license.org)

# lfda
R package for performing and visualizing *Local Fisher Discriminant Analysis*, *Kernel Local Fisher Discriminant Analysis*, and *Semi-supervised Local Fisher Discriminant Analysis*.

Introduction to the algorithms and their application can be found [here](https://gastrograph.com/resources/whitepapers/local-fisher-discriminant-analysis-on-beer-style-clustering.html) and [here](http://www.ms.k.u-tokyo.ac.jp/software.html#LFDA). These methods are widely applied in feature extraction, dimensionality reduction, clustering, classification, information retrieval, and computer vision problems. An introduction to the package is also available in Chinese [here](https://cosx.org/2015/08/a-brief-description-of-the-method-and-the-algorithm-of-the-lfda-package/).

Welcome any [feedback](https://github.com/terrytangyuan/lfda/issues) and [pull request](https://github.com/terrytangyuan/lfda/pulls).  

## Install the current release from CRAN:
```{R}
install.packages('lfda')
```

## Install the latest development version from github:
```{R}
devtools::install_github('terrytangyuan/lfda')
```

## Citation

Please call `citation("lfda")` in R to properly cite this software. A white paper is available on [arXiv](https://arxiv.org/abs/1612.09219). 

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
### Integration with {ggplot2::autoplot}
`{ggplot2::autoplot}` has been integrated with this package. Now `{lfda}` can be plotted in 2D easily and beautifully using `{ggfortify}` package. Go to [this link](http://rpubs.com/sinhrks/plot_pca) and scroll down to the last section for an example. 

## Contribute & Code of Conduct

To contribute to this project, please take a look at the [Contributing Guidelines](CONTRIBUTING.md) first. Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

## Contact

Contact the maintainer of this package:
Yuan Tang <terrytangyuan@gmail.com>
