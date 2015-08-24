#' Matlab-Syntaxed Repmat
#'
#' This function mimics the behavior and syntax of repmat() in Matlab
#' it generates a large matrix consisting of an N-by-M tiling copies of A
#'
#' @param A original matrix to be used as copies
#' @param N the number of rows of tiling copies of A
#' @param M the number of columns of tiling copies of A
#'
#' @return matrix consisting of an N-by-M tiling copies of A
#'
#' @export
#'
repmat <- function(A, N, M) {
	kronecker(matrix(1, N, M), A)
}
#' Negative One Half Matrix Power Operator
#'
#' This function defines operation for negative one half matrix
#' power operator
#'
#' @param x the matrix we want to operate on
#' @param n the exponent
#'
#' @return the matrix after negative one half power
#'
#' @export
#'
"%^%" <- function(x, n) {
		with(eigen(as.matrix(x)), vectors %*% (values^n * t(vectors)))
}
#' Get Affinity Matrix
#'
#' This function returns an affinity matrix within knn-nearest neighbors from the distance matrix.
#'
#' @param distance2 The distance matrix for each observation
#' @param knn The number of nearest neighbors
#' @param nc The number of observations for data in this class
#'
#' @export
#'
#' @return an affinity matrix - the larger the element in the matrix, the closer two data points are
getAffinityMatrix <- function(distance2, knn, nc){
  sorted <- apply(distance2, 2, sort) # sort for each column by distance
  if(dim(sorted)[1] < knn + 1){stop("knn is too large, please try to reduce it.")}
  kNNdist2 <- t(as.matrix(sorted[knn + 1, ])) # knn-th nearest neighbor
  sigma <- sqrt(kNNdist2)

  localscale <- t(sigma) %*% sigma
  # use only non-zero entries in localscale since this will be used in the denominator
  # to calculate the affinity matrix
  flag <- (localscale != 0)

  # define affinity matrix - the larger the element in the matrix, the closer two data points are
  A <- mat.or.vec(nc, nc)
  A[flag] <- exp(-distance2[flag]/localscale[flag])
  return(A)
}
#' Get Requested Type of Transforming Metric
#'
#' This function returns the requested type of transforming metric.
#'
#' @param metric The type of metric to be requested
#' @param eigVec The eigenvectors of the problem
#' @param eigVal The eigenvalues of the problem
#' @param total The number of total rows to be used for weighting denominator
#'
#' @return The transformation metric in requested type
#' @export
getMetricOfType <- function(metric, eigVec, eigVal, total){
  return(switch(metric,
                # this weighting scheme is explained in section 3.3 in the first reference
                weighted = eigVec * repmat(t(sqrt(eigVal)), total, 1),
                orthonormalized = qr.Q(qr(eigVec)),
                plain = eigVec
  ))
}
