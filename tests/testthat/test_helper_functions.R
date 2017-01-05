context('helper functions')

data(iris)

test_that('kmatrixGauss function works', {
  kmatrixGauss(iris[,-5])
})

test_that('repmat works', {
  repmat(matrix(c(1,2,3,4,5,6), nrow=3, ncol=2, byrow=TRUE), 2, 3)
})

test_that('%^% works', {
  mat <- matrix(c(1,2,3,4), nrow=2, ncol=2, byrow=TRUE)
  mat%^%3
  mat <- matrix(c(1,2,3,4,5,6), nrow=3, ncol=2, byrow=TRUE)
  expect_error(mat%^%3)
})
