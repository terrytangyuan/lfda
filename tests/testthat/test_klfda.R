context('Test klfda functionalities')

data(iris)

test_that('klfda works correctly for different metrics on the data transformed by kmatrixGauss()', {
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  result <- klfda(k, y, r, metric = "plain")
  expect_equal(dim(result$T), c(150, 3))
  expect_equal(dim(result$Z), c(150, 3))
  
  result <- klfda(k, y, r, metric = "weighted")
  expect_equal(dim(result$T), c(150, 3))
  expect_equal(dim(result$Z), c(150, 3))
  
  result <- klfda(k, y, r, metric = "orthonormalized")
  expect_equal(dim(result$T), c(150, 3))
  expect_equal(dim(result$Z), c(150, 3))
})
