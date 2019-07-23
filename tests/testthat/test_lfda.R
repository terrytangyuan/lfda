context('Test lfda functionalities')

data(iris)

test_that('lfda works correctly on different metrics', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k, y, r, metric = "plain")
  expect_equal(dim(result$T), c(4, 3))
  expect_equal(dim(result$Z), c(150, 3))
  
  result <- lfda(k, y, r, metric = "weighted")
  expect_equal(dim(result$T), c(4, 3))
  expect_equal(dim(result$Z), c(150, 3))
  
  result <- lfda(k, y, r, metric = "orthonormalized")
  expect_equal(dim(result$T), c(4, 3))
  expect_equal(dim(result$Z), c(150, 3))

  expect_error(lfda(k, y, r, metric = "plain", knn = 10000))

  # case when r = d
  result <- lfda(k, y, r = 4, metric = "plain")
  expect_equal(dim(result$T), c(4, 4))
  expect_equal(dim(result$Z), c(150, 4))
})

test_that('S3 methods on produced lfda model have the correct behaviors', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3

  model <- lfda(k, y, r = 4,metric = "plain")
  expect_equal(dim(predict(model, iris[,-5])), c(150, 4))
  expect_error(predict(model, iris[,-5], "wrongType"))
  expect_error(predict(model))
  
  expect_equal(length(capture.output(print(model))), 20)
})
