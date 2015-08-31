[![Travis-CI Build Status](https://travis-ci.org/terrytangyuan/lfda.svg?branch=master)](https://travis-ci.org/terrytangyuan/lfda)
[![Coverage Status](https://coveralls.io/repos/terrytangyuan/lfda/badge.svg?branch=master)](https://coveralls.io/r/terrytangyuan/lfda?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/lfda)](http://cran.r-project.org/web/packages/lfda)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat)](http://badges.mit-license.org)

# lfda
R package for performing and visualizing *Local Fisher Discriminant Analysis*, *Kernel Local Fisher Discriminant Analysis*, and *Semi-supervised Local Fisher Discriminant Analysis*.

Introduction to the algorithms and their application can be found [here](https://gastrograph.com/resources/whitepapers/local-fisher-discriminant-analysis-on-beer-style-clustering.html) and [here](http://www.ms.k.u-tokyo.ac.jp/software.html#LFDA). These methods are widely applied in feature extraction, dimensionality reduction, clustering, classification, information retrieval, and computer vision problems.

Welcome any [feedback](https://github.com/terrytangyuan/lfda/issues) and [pull request](https://github.com/terrytangyuan/lfda/pulls).  

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
### Integration with {ggplot2::autoplot}
`{ggplot2::autoplot}` has been integrated with this package. Now `{lfda}` can be plotted in 2D easily and beautifully using `{ggfortify}` package. Go to [this link](http://rpubs.com/sinhrks/plot_pca) and scroll down to the last section for an example. 

# lfda R包的使用方法以及算法的简要说明
# 作者： 唐源（Yuan Tang）

局部Fisher判别分析(Local Fisher Discriminant Analysis)是许多度量学习（Metric Learning）方法中效果最好的其中一种，它是一种线性监督降维方法，它可以自动找到合适的距离转换矩阵(transformation matrix)来抓住数据的不同类(class)的特征，通过加大不同类之间的距离(between-class distance)以及缩小同类里面每个样本的距离(within-class distance)，让不同类之间的界限更明显，从而使可视化效果更清晰。它同时也保持了多模(multimodality)的特征，这在处理一个类有多个的集群的时候有非常大的作用，比如说对于一种有多种可能症状的疾病来说，那些可能的症状都是同一类里面不同的集群，lfda可以把这种病的局部结构和特征(local structure)保持下来从而不会影响到之后的机器学习算法的效果。更细节一点的英文的理论介绍和应用可以点击[这里](https://gastrograph.com/resources/whitepapers/local-fisher-discriminant-analysis-on-beer-style-clustering.html)和[这里](http://www.ms.k.u-tokyo.ac.jp/software.html#LFDA)。lfda对特征提取，降维，集群，分类，信息恢复，以及计算机视觉方面起到非常大的作用。

核局部Fisher判别分析(Kernel Local Fisher Discriminant Analysis)是局部Fisher判别分析的非线性化版本，它通过对原来的数据进行核转换技巧（kernel trick）从而能在高维的特征空间里面进行局部Fisher判别分析，它可以使不同类之间的非线性界限更明显，从而使之后的分类，集群等机器学习的方法效果更好。

半监督局部Fisher判别分析(Semi-supervised Local Fisher Discriminant Analysis)是局部Fisher判别分析的延伸版，它是线性的半监督降维方法。它充分的结合了非监督型主成分分析(Principal Component Analysis)和监督型局部Fisher判别分析的优点，使之能够将一部分的类标识（class label）忽略，来表达更多整体上类和类之间的特征，这对缺少标识的数据以及部分标识不正确的数据来说有非常大的作用。

以下是一些lfda包的简单用法，以上的三种分析方法目前都已经实现：

## 从CRAN上下载和安装最新的发布:
```{R}
install.packages('lfda')
```

## 从Github上下载和安装最新的发展版本：
```{R}
devtools::install_github('terrytangyuan/lfda')
```
### 局部Fisher判别分析 - Local Fisher Discriminant Analysis(LFDA)
假设我们想要将原数据降维到3个维度，我们可以运行以下代码：
```{R}
k <- iris[,-5] 	#　这个矩阵包含了所有将要被转换的自变量(predictors)
y <- iris[,5] 	# 这是一个代表类标识(class labels)的向量
r <- 3 			# 将要降到的维度数

# 运行`lfda`模型，注意`metric`这个参数可以选择'plain', 'weighted', 和'orthonormalized'来分别代表转换矩阵的类型： 普通，加权，和正交
model <- lfda(k, y, r, metric = "plain") 

plot(model, y) # 对转换之后的数据进行三维可视化

predict(model, iris[,-5]) # predict的方法来用之前得到的lfda模型对新数据进行转换

```
### 核局部Fisher判别分析 - Kernel Local Fisher Discriminant Analysis(KLFDA)
`klfda`的主要使用方法和`lfda`的使用方法基本一样，只是在使用lfda之前先要用`kmatrixGauss`对原数据进行核转换:
```{R}
k <- kmatrixGauss(iris[,-5])
y <- iris[,5]
r <- 3
model <- klfda(k, y, r, metric = "plain")

```
注意klfda的`predict`方法还在实现当中，`plot`三维可视化的方法和`lfda`的一样已经实现。

### 半监督局部Fisher判别分析- Semi-supervised Local Fisher Discriminant Analysis(SELF)
这个算法要求另外一项参数`beta`来代表半监督的程度： 如果beta=0， 即代表完全监督； 如果beta=0， 则完全不监督（不使用任何类标识信息）。假设我们想要忽略`iris`数据里10%的类标识：
```{R}
k <- iris[,-5]
y <- iris[,5]
r <- 3
model <- self(k, y, beta = 0.1, r = 3, metric = "plain")

```
`predict`和`plot`的使用方法和`lfda`的完全一样

欢迎大家使用以及将任何的反馈意见提交到[这里](https://github.com/terrytangyuan/lfda/issues)或者发到我的邮箱terrytangyuan@gmail.com，也欢迎大家的[Pull Request](https://github.com/terrytangyuan/lfda/pulls)。  
