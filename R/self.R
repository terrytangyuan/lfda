#' Semi-Supervised Local Fisher Discriminant Analysis(SELF) for
#' Semi-Supervised Dimensionality Reduction
#'
#' Performs semi-supervised local fisher discriminant analysis (SELF) on the given data.
#' SELF is a linear semi-supervised dimensionality reduction method smoothly bridges supervised
#' LFDA and unsupervised principal component analysis, by which a natural regularization effect
#' can be obtained when only a small number of labeled samples are available.
#'
#' @import rARPACK
#'
#' @export  self
#'
#' @param X n x d matrix of original samples.
#'          n is the number of samples.
#' @param Y length n vector of class labels
#' @param beta degree of semi-supervisedness (0 <= beta <= 1; default is 0.5 )
#'        0: totally supervised (discard all unlabeled samples)
#'        1: totally unsupervised (discard all label information)
#' @param r dimensionality of reduced space (default: d)
#' @param metric type of metric in the embedding space (no default)
#'               'weighted'        --- weighted eigenvectors
#'               'orthonormalized' --- orthonormalized
#'               'plain'           --- raw eigenvectors
#' @param kNN parameter used in local scaling method (default: 5)
#' @param minObsPerLabel the minimum number observations required for each different label(default: 5)
#'
#' @return list of the SELF results:
#' \item{T}{d x r transformation matrix (Z = x * T)}
#' \item{Z}{n x r matrix of dimensionality reduced samples}
#'
#' @keywords lfda local fisher discriminant transformation mahalanobis metric semi-supervised
#'
#' @author Yuan Tang
#'
#' @seealso See \code{\link{lfda}} for LFDA and  \code{\link{klfda}} for the kernelized variant of
#'          LFDA (Kernel LFDA).
#'
#' @references
#' Sugiyama, Masashi, et al (2010).
#' Semi-supervised local Fisher discriminant analysis for dimensionality reduction.
#' \emph{Machine learning} 78.1-2: 35-61.
#'
#' Sugiyama, M (2007).
#' Dimensionality reduction of multimodal labeled data by
#' local Fisher discriminant analysis.
#' \emph{Journal of Machine Learning Research}, vol.\bold{8}, 1027--1061.
#'
#' Sugiyama, M (2006).
#' Local Fisher discriminant analysis for supervised dimensionality reduction.
#' In W. W. Cohen and A. Moore (Eds.), \emph{Proceedings of 23rd International
#' Conference on Machine Learning (ICML2006)}, 905--912.
#'
#' @import rARPACK
#'
#' @examples
#' \dontrun{
#' X <- iris[,-5]
#' Y <- iris[,5]
#' result <- self(X,Y,beta = 0.1, r = 3, metric = "plain")
#' }
self <- function(X, Y, beta = 0.5, r, metric = c("orthonormalized","plain","weighted"), kNN = 5, minObsPerLabel = 5){

  if (any(table(Y) < minObsPerLabel)) {
    stop(cat("Number of reviews per label is less than", minObsPerLabel, "\n",
             "the label(s):", unique(Y[which(table(Y) <= minObsPerLabel)]), "is/are the problem(s)!"))
  }

  X <- t(as.matrix(X))
  Y <- t(as.matrix(Y))

  d <- nrow(X) # number of predictors
  n <- ncol(X) # number of samples
  if(is.null(r)) r <- d

  tSb <- mat.or.vec(d, d)
  tSw <- mat.or.vec(d, d)

  flag_label <- !is.na(Y)
  nlabel <- sum(flag_label);
  X2 <- t(as.matrix(colSums(X^2)))
  disttmp <- (repmat(X2[,flag_label], 1, nlabel) + repmat(t(X2), 1, nlabel) - 2*t(X) %*% X[,flag_label]) # modified
  dist2 <- disttmp + abs(min(disttmp)) # modified
  A <- getAffinityMatrix(dist2, kNN, nlabel)

  Wlb <- mat.or.vec(nlabel, nlabel)
  Wlw <- mat.or.vec(nlabel, nlabel)
  Ylabel <- Y[flag_label]

  for(class in Ylabel){
    flag_class <- (Ylabel == class)
    nclass <- sum(flag_class)
    if(nclass != 0){
      tmp <- flag_class*1
      tmp2 <- (!flag_class)*1
      Wlb <- Wlb + (A*(1/nlabel-1/nclass))*as.numeric(t(tmp)%*%tmp) + as.numeric(t(tmp)%*%tmp2)/nlabel
      Wlw <- Wlw + (A/nclass)*as.numeric(t(tmp)%*%tmp)
    }
  }

  Slb <- X[,flag_label] %*% (diag(t(as.matrix(colSums(Wlb)))) - Wlb) %*% t(X[,flag_label])
  Slw <- X[,flag_label] %*% (diag(t(as.matrix(colSums(Wlw)))) - Wlw) %*% t(X[,flag_label])

  Srlb <- (1 - beta)*Slb + beta*cov(t(X))/nrow(X)
  Srlw <- (1 - beta)*Slw + beta*diag(d)

  Srlb <- (Srlb + t(Srlb))/2
  Srlw <- (Srlw + t(Srlw))/2

  if(r == d){
    eigTmp <- eigen(solve(Srlw) %*% Srlb)
  } else{
    eigTmp <- suppressWarnings(rARPACK::eigs(A = solve(Srlw) %*% Srlb,k = r,which = 'LM'))
  }
  eigVec <- Re(eigTmp$vectors)
  eigVal <- as.matrix(Re(eigTmp$values))

  Tr <- getMetricOfType(metric, eigVec, eigVal, d)

  Z <- t(t(Tr) %*% X) # transformed data
  out <- list("T" = Tr, "Z" = Z)
  class(out) <- 'lfda'
  return(out)
}




