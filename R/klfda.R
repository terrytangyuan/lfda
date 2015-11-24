#' Kernel Local Fisher Discriminant Analysis for
#' Supervised Dimensionality Reduction
#'
#' Performs kernel local fisher discriminant analysis on the given data,
#' which is the non-linear version of LFDA (see details \code{\link{lfda}}).
#'
#' @param k n x n kernel matrix. Result of the \code{\link{kmatrixGauss}} function.
#'          n is the number of samples
#' @param y n dimensional vector of class labels
#' @param r dimensionality of reduced space (default: d)
#' @param metric type of metric in the embedding space (default: 'weighted')
#'               'weighted'        --- weighted eigenvectors
#'               'orthonormalized' --- orthonormalized
#'               'plain'           --- raw eigenvectors
#' @param knn parameter used in local scaling method (default: 6)
#' @param reg regularization parameter (default: 0.001)
#'
#' @return list of the LFDA results:
#' \item{T}{d x r transformation matrix (Z = t(T) * X)}
#' \item{Z}{r x n matrix of dimensionality reduced samples}
#'
#' @keywords klfda local fisher discriminant transformation mahalanobis metric
#'
#' @aliases klfda
#'
#' @author Yuan Tang
#'
#' @seealso See \code{\link{lfda}} for the linear version.
#'
#' @import rARPACK
#'
#' @export klfda
#'
#' @references
#' Sugiyama, M (2007). - contain implementation
#' Dimensionality reduction of multimodal labeled data by
#' local Fisher discriminant analysis.
#' \emph{Journal of Machine Learning Research}, vol.\bold{8}, 1027--1061.
#'
#' Sugiyama, M (2006).
#' Local Fisher discriminant analysis for supervised dimensionality reduction.
#' In W. W. Cohen and A. Moore (Eds.), \emph{Proceedings of 23rd International
#' Conference on Machine Learning (ICML2006)}, 905--912.
#'
#' Original Matlab Implementation: http://www.ms.k.u-tokyo.ac.jp/software.html#LFDA
#'
#' @examples
#' \dontrun{
#' ## example without dimension reduction
#' k <- kmatrixGauss(x = trainData[,-1])
#' y <- trainData[,1]
#' r <- 26 # dimensionality of reduced space. Here no dimension reduction is performed
#' result <- klfda(k,y,r,metric="plain")
#' transformedMat <- result$Z # transformed training data
#' metric.train <- as.data.frame(cbind(trainData[,1],transformedMat))
#' colnames(metric.train)=colnames(trainData)
#'
#' ## example with dimension reduction
#' k <- kmatrixGauss(x = trainData[,-1])
#' y <- trainData[,1]
#' r <- 3 # dimensionality of reduced space
#' result <- klfda(k,y,r,metric="plain")
#' transformMat  <- result$T # transforming matrix - distance metric
#'
#' # transformed training data with Style
#' transformedMat <- result$Z # transformed training data
#' metric.train <- as.data.frame(cbind(trainData[,1],transformedMat))
#' colnames(metric.train)[1] <- "Style"
#'
#' # transformed testing data with Style (unfinished)
#' metric.test <- kmatrixGauss(x = testData[,-1])
#' metric.test <- as.matrix(testData[,-1]) %*% transformMat
#' metric.test <- as.data.frame(cbind(testData[,1],metric.test))
#' colnames(metric.test)[1] <- "Style"
#'
#' }
#'
klfda <- function (k, y, r, metric = c('weighted', 'orthonormalized', 'plain'),
                   knn = 6, reg = 0.001) {

	metric <- match.arg(metric) # the type of the transforming matrix (metric)
	y <- t(as.matrix(y)) # transpose of original class labels
	n <- nrow(k) # number of samples
	if(is.null(r)) r <- n # if no dimension reduction requested, set r to n

	tSb <- mat.or.vec(n, n) # initialize between-class scatter matrix (to be maximized)
	tSw <- mat.or.vec(n, n) # initialize within-class scatter matrix (to be minimized)

	# compute the optimal scatter matrices in a classwise manner
	for (i in unique(as.vector(t(y)))) {

		Kcc <- k[y == i, y == i] # data for this class
		Kc <- k[, y == i]
		nc <- nrow(Kcc)

		# Define classwise affinity matrix
		Kccdiag <- diag(Kcc) # diagonals of the class-specific data
		distance2 <- repmat(Kccdiag, 1, nc) + repmat(t(Kccdiag), nc, 1) - 2 * Kcc

		# Get affinity matrix
		A <- getAffinityMatrix(distance2, knn, nc)

		Kc1 <- as.matrix(rowSums(Kc))
		Z <- Kc %*% (repmat(as.matrix(colSums(A)), 1, n) * t(Kc)) - Kc %*% A %*% t(Kc)
		tSb <- tSb + (Z/n) + Kc %*% t(Kc) * (1 - nc/n) + Kc1 %*% (t(Kc1)/n)
		tSw <- tSw + Z/nc
	}

	K1 <- as.matrix(rowSums(k))
	tSb <- tSb - K1 %*% t(K1)/n - tSw

	tSb <- (tSb + t(tSb))/2 # final between-class cluster matrix
	tSw <- (tSw + t(tSw))/2 # final within-class cluster matrix

	# find generalized eigenvalues and normalized eigenvectors of the problem
	eigTmp <- suppressWarnings(rARPACK::eigs(A = solve(tSw + reg * diag(1, nrow(tSw), ncol(tSw))) %*% tSb,
	                                         k = r,which ='LM')) # r largest magnitude eigenvalues
	eigVec <- Re(eigTmp$vectors) # the raw transforming matrix
	eigVal <- as.matrix(Re(eigTmp$values))

	# options to require a particular type of returned transform matrix
	# transforming matrix (do not change the "=" in the switch statement)
	Tr <- getMetricOfType(metric, eigVec, eigVal, n)

	Z <- t(t(Tr) %*% k) # transformed data
	out <- list("T" = Tr, "Z" = Z)
	class(out) <- 'lfda'
	return(out)
}
