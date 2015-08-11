context('helper functions')

data(iris)

test_that('kmatrixGauss function works', {
  expect_that(kmatrixGauss(iris[,-5]), not(throws_error()))
})

test_that('repmat works', {
  expect_that(newMat <- repmat(matrix(c(1,2,3,4,5,6), nrow=3, ncol=2, byrow=TRUE), 2, 3), not(throws_error()))
  expect_equal(dim(newMat), c(6,6))
})

test_that('%^% works', {
  mat <- matrix(c(1,2,3,4), nrow=2, ncol=2, byrow=TRUE)
  expect_that(mat%^%3, not(throws_error()))
  mat <- matrix(c(1,2,3,4,5,6), nrow=3, ncol=2, byrow=TRUE)
  expect_error(mat%^%3)
})
