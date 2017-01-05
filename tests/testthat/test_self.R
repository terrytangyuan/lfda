context('self')

data(iris)

test_that('self works', {
  X <- iris[,-5]
  Y <- iris[,5]
  r <- 3
  self(X,Y,beta = 0.1, r = 3, metric = "plain")
  suppressWarnings(self(X,Y,beta = 0.1, r = 3, metric = "weighted"))
  self(X,Y,beta = 0.1, r = 3, metric = "orthonormalized")

  # case when r=d
  self(X,Y,beta = 0.1, r = 4, metric = "plain")

  # case when one label only has 4 obs, which is less than the default minObsPerLabel = 5
  expect_error(capture.output(
    self(iris[c(1:4, 51:dim(iris)[1]), -5], iris[c(1:4, 51:dim(iris)[1]), 5],
         beta = 0.1, r = 3, metric = "plain")))

  model <- self(X,Y,beta = 0.1, r = 3, metric = "plain")
  predict(model, iris[,-5])
  expect_error(predict(model, iris[,-5], "wrongType"))
  expect_error(predict(model))
  capture.output(print(model))
})
