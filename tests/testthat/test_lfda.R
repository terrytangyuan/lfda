context('lfda')

data(iris)

test_that('lfda works', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  expect_that(lfda(k,y,r,metric="plain"), not(throws_error()))
  expect_that(lfda(k,y,r,metric="weighted"), not(throws_error()))
  expect_that(lfda(k,y,r,metric="orthonormalized"), not(throws_error()))

  expect_error(lfda(k,y,r,metric="plain", knn=10000))

  # case when r=d
  expect_that(lfda(k,y,r=4,metric="plain"), not(throws_error()))

  model <- lfda(k,y,r=4,metric="plain")
  expect_that(predict(model, iris[,-5]), not(throws_error()))
  expect_error(predict(model, iris[,-5], "wrongType"))
  expect_error(predict(model))
  expect_that(capture.output(print(model)), not(throws_error())) # suppress printing
})
