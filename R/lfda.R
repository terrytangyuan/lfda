#' Local Fisher Discriminant Analysis for
#' Supervised Dimensionality Reduction
#'
#' Performs local fisher discriminant analysis (LFDA) on the given data.
#'
#' LFDA is a method for linear dimensionality reduction that maximizes
#' between-class scatter and minimizes within-class scatter while at the
#' same time maintain the local structure of the data so that multimodal
#' data can be embedded appropriately. Its limitation is that it only
#' looks for linear boundaries between clusters. In this case, a non-linear
#' version called kernel LFDA will be used instead. Three metric types can
#' be used if needed.
#'
#' @import rARPACK
#'
#' @export  lfda
#'
#' @param x n x d matrix of original samples.
#'          n is the number of samples.
#' @param y length n vector of class labels
#' @param r dimensionality of reduced space (default: d)
#' @param metric type of metric in the embedding space (no default)
#'               'weighted'        --- weighted eigenvectors
#'               'orthonormalized' --- orthonormalized
#'               'plain'           --- raw eigenvectors
#' @param knn parameter used in local scaling method (default: 5)
#'
#' @return list of the LFDA results:
#' \item{T}{d x r transformation matrix (Z = x * T)}
#' \item{Z}{n x r matrix of dimensionality reduced samples}
#'
#' @keywords lfda local fisher discriminant transformation mahalanobis metric
#'
#' @author Yuan Tang
#'
#' @seealso See \code{\link{klfda}} for the kernelized variant of
#'          LFDA (Kernel LFDA).
#'
#' @references
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
#' ## example without dimension reduction
#' k <- trainData[,-1]
#' y <- trainData[,1]
#' r <- 26 # dimensionality of reduced space. Here no dimension reduction is performed
#' result <- lfda(k,y,r,metric="plain")
#' transformedMat <- result$Z # transformed training data
#' metric.train <- as.data.frame(cbind(trainData[,1],transformedMat))
#' colnames(metric.train)=colnames(trainData)
#'
#' ## example with dimension reduction
#' k <- trainData[,-1]
#' y <- trainData[,1]
#' r <- 3 # dimensionality of reduced space
#'
#' result <- lfda(k,y,r,metric="weighted")
#' transformMat  <- result$T # transforming matrix - distance metric
#'
#' # transformed training data with Style
#' transformedMat <- result$Z # transformed training data
#' metric.train <- as.data.frame(cbind(trainData[,1],transformedMat))
#' colnames(metric.train)[1] <- "Style"
#'
#' # transformed testing data with Style
#' metric.test <- as.matrix(testData[,-1]) %*% transformMat
#' metric.test <- as.data.frame(cbind(testData[,1],metric.test))
#' colnames(metric.test)[1] <- "Style"
#' }
#'
#'
lfda <- function(x, y, r, metric = c("orthonormalized","plain","weighted"),knn = 5) {

  metric <- match.arg(metric) # the type of the transforming matrix (metric)
  x <- t(as.matrix(x)) # transpose of original samples
  y <- t(as.matrix(y)) # transpose of original class labels
  d <- nrow(x) # number of predictors
  n <- ncol(x) # number of samples
  if(is.null(r)) r <- d # if no dimension reduction requested, set r to d

  tSb <- mat.or.vec(d, d) # initialize between-class scatter matrix (to be maximized)
  tSw <- mat.or.vec(d, d) # initialize within-class scatter matrix (to be minimized)

  # compute the optimal scatter matrices in a classwise manner
  for (i in unique(as.vector(t(y)))) {

    Xc <- x[, y == i] # data for this class
    nc <- ncol(Xc)

    # determine local scaling for locality-preserving projection
    Xc2 <- t(as.matrix(colSums(Xc^2)))
    # calculate the distance, using a self-defined repmat function that's the same
    # as repmat() in Matlab
    distance2 <- repmat(Xc2, nc, 1) + repmat(t(Xc2), 1, nc) - 2 * t(Xc) %*% Xc

    # Get affinity matrix
    A <- getAffinityMatrix(distance2, knn, nc)

    Xc1 <- as.matrix(rowSums(Xc))
    G <- Xc %*% (repmat(as.matrix(colSums(A)), 1, d) * t(Xc)) - Xc %*% A %*% t(Xc)
    tSb <- tSb + (G/n) + Xc %*% t(Xc) * (1 - nc/n) + Xc1 %*% (t(Xc1)/n)
    tSw <- tSw + G/nc
  }

  X1 <- as.matrix(rowSums(x))
  tSb <- tSb - X1 %*% t(X1)/n - tSw

  tSb <- (tSb + t(tSb))/2 # final between-class cluster matrix
  tSw <- (tSw + t(tSw))/2 # final within-class cluster matrix

  # find generalized eigenvalues and normalized eigenvectors of the problem
  if (r == d) {
    # without dimensionality reduction
    eigTmp <- eigen(solve(tSw) %*% tSb)  # eigenvectors here are normalized
  } else {
    # dimensionality reduction (select only the r largest eigenvalues of the problem)
    eigTmp <- suppressWarnings(rARPACK::eigs(A = solve(tSw) %*% tSb, k = r, which = 'LM')) # r largest magnitude eigenvalues
  }
  eigVec <- Re(eigTmp$vectors) # the raw transforming matrix
  eigVal <- as.matrix(Re(eigTmp$values))

  # options to require a particular type of returned transform matrix
  # transforming matrix (do not change the "=" in the switch statement)
  Tr <- getMetricOfType(metric, eigVec, eigVal, d)

  Z <- t(t(Tr) %*% x) # transformed data
  out <- list("T" = Tr, "Z" = Z)
  class(out) <- 'lfda'
  return(out)
}
#' LFDA Transformation/Prediction on New Data
#'
#' This function transforms a data set, usually a testing set, using the trained LFDA metric
#' @param object The result from lfda function, which contains a transformed data and a transforming
#'        matrix that can be used for transforming testing set
#' @param newdata The data to be transformed
#' @param type The output type, in this case it defaults to "raw" since the output is a matrix
#' @param ... Additional arguments
#' @export
#' @method predict lfda
#' @return the transformed matrix
#' @author Yuan Tang
predict.lfda <- function(object, newdata = NULL, type = "raw", ...){

  if(is.null(newdata)){stop("You must provide data to be used for transformation. ")}
  if(type != "raw"){stop('Types other than "raw" are currently unavailable. ')}
  if(is.data.frame(newdata)) newdata <- as.matrix(newdata)

  transformMatrix <- object$T

  result <- newdata %*% transformMatrix
  result
}
#' Print an lfda object
#'
#' Print an lfda object
#' @param x The result from lfda function, which contains a transformed data and a transforming
#' @param ... ignored
#' @export
#' @importFrom stats cov
#' @importFrom utils head
#' @method print lfda
print.lfda <- function(x, ...){
  cat("Results for Local Fisher Discriminant Analysis \n\n")
  cat("The trained transforming matric is: \n")
  print(head(x$T))

  cat("\n\n The original data set after applying this metric transformation is:  \n")
  print(head(x$Z))

  cat("\n")
  cat("Only partial output is shown above. Please see the model output for more details. \n")
  invisible(x)
}
