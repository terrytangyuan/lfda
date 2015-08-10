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