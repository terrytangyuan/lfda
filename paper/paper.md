---
title: '`lfda`: Local Fisher Discriminant Analysis in `R`'
authors:
- affiliation: 1
  name: Yuan Tang
  orcid: 0000-0001-5243-233X
- affiliation: 2
  name: Wenxuan Li
date: "13 July 2019"
output:
  pdf_document: default
  html_document:
    df_print: paged
bibliography: paper.bib
tags:
- R
- distance metric learning
- statistics
- clustering
- machine learning
- dimensionality reduction
- local fisher discriminant analysis
affiliations:
- index: 1
  name: Ant Financial Services Group, San Mateo, CA 94402, USA
- index: 2
  name: Purdue University, West Lafayette, IN 47907, USA
---

# Summary

*Fisher discriminant analysis* [@fdapaper] is a popular choice to reduce the dimensionality of the original dataset. It maximizes between-class scatter and minimizes within-class scatter. It works really well in practice but lacks some considerations for multimodality. Multimodality exists within many applications, such as disease diagnosis, where there may be multiple causes for a particular disease. In this situation, *Fisher discriminant analysis* cannot capture the multimodal characteristics of the clusters. To deal with multimodality, *local-preserving projection* [@lpppaper] preserves the local structure of the data in that it keeps nearby data pairs in the original data space close in the embedding space. As a result, multimodal data could be embedded and its local structure will not be lost.

Later on, a new dimensionality reduction method called *local Fisher discriminant analysis (LFDA)* [@lfdaoriginalpaper] was proposed to combine both advantages of Fisher discriminant analysis and those of local-preserving projection in a way that between-class separability is maximized while within-class separability is minimized and its local structure is preserved. Furthermore, with the help of kernel trick, local Fisher discriminant analysis can also be extended to deal with non-linear dimensionality reduction situations.

*Principal components analysis (PCA)* [@pcapaper] is another popular choice for performing dimension reduction. However, in practice sometimes principal components analysis generates bad principal components that cannot explain a great amount of variance in the original dataset. For example, if the original dataset has six dimensions and we reduce the dimension into three using *PCA*, the three principal components might not capture some important characteristics and variance in the original dataset. Using this result from *PCA* sometimes misleads the analysis due to the poor pre-processing that losses a lot of the essential information in the original dataset. On the other hand, metric learning methods such as *LFDA* in particular can, surprisingly, enhance the distinctive characteristics of the original dataset and pull data points that have similar characteristics close to each other. However, both *PCA* and *LFDA* have their own shortcomings and a combined approach called *semi-supervised local Fisher discriminant analysis* [@semilfdapaper] mix the supervised and unsupervised approaches to provide a more stable result.

The `lfda` [@lfdapaper; @lfdapkg] package is an R package for performing *local Fisher discriminant analysis*, *kernel local Fisher discriminant analysis*, and *semi-supervised local Fisher discriminant analysis*. It also provides visualization functions to easily visualize the dimension reduction results by using `rgl` [@rgl] for 3D visualization, `ggfortify` [@rjggfortify; @ggfortify] for 2D visualization in `ggplot2` [@wickham2009ggplot2] style, or `autoplotly` [@autoplotlypkg; @autoplotly2018joss] for interactive visualizations in `plotly` [@plotly] style. `lfda` is also included in `dml` [@dmlpkg; @dmljoss] package together with implementations of other *distance metric learning* algorithms.

# References
