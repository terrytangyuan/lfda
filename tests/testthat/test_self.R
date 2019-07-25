context("self")

data(iris)

test_that("self works", {
  X <- iris[, -5]
  Y <- iris[, 5]
  r <- 3
  result <- self(X, Y, beta = 0.1, r = 3, metric = "plain")
  expect_equal(dim(result$T), c(4, 3))
  expect_equal(dim(result$Z), c(150, 3))

  suppressWarnings(self(X, Y, beta = 0.1, r = 3, metric = "weighted"))
  result <- self(X, Y, beta = 0.1, r = 3, metric = "orthonormalized")
  expect_equal(dim(result$T), c(4, 3))
  expect_equal(dim(result$Z), c(150, 3))

  # case when r = d
  result <- self(X, Y, beta = 0.1, r = 4, metric = "plain")
  expect_equal(dim(result$T), c(4, 4))
  expect_equal(dim(result$Z), c(150, 4))

  # case when one label only has 4 obs, which is less than the default minObsPerLabel = 5
  expect_error(capture.output(
    self(iris[c(1:4, 51:dim(iris)[1]), -5], iris[c(1:4, 51:dim(iris)[1]), 5],
      beta = 0.1, r = 3, metric = "plain"
    )
  ))

  model <- self(X, Y, beta = 0.1, r = 3, metric = "plain")
  predict(model, iris[, -5])
  expect_error(predict(model, iris[, -5], "wrongType"))
  expect_error(predict(model))
  capture.output(print(model))
})
