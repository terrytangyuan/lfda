context("Test the helper functions used in lfda implementations")

data(iris)

test_that("kmatrixGauss() calculates the Gaussian kernel correctly", {
  result <- kmatrixGauss(iris[, -5])
  expect_equal(dim(result), c(150, 150))
})

test_that("repmat() calculates the matrix after negative one half power correctly", {
  result <- repmat(matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2, byrow = TRUE), 2, 3)
  expect_equal(dim(result), c(6, 6))
})

test_that("%^% symbol generates an N-by-M tiling copies of original matrix correctly", {
  mat <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2, byrow = TRUE)
  expect_equal(dim(mat %^% 3), c(2, 2))
  mat <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2, byrow = TRUE)
  expect_error(mat %^% 3)
})
