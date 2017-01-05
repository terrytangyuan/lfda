context('lfda')

data(iris)

test_that('lfda works', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  lfda(k,y,r,metric="plain")
  lfda(k,y,r,metric="weighted")
  lfda(k,y,r,metric="orthonormalized")

  expect_error(lfda(k,y,r,metric="plain", knn=10000))

  # case when r=d
  lfda(k,y,r=4,metric="plain")

  model <- lfda(k,y,r=4,metric="plain")
  predict(model, iris[,-5])
  expect_error(predict(model, iris[,-5], "wrongType"))
  expect_error(predict(model))
  capture.output(print(model))
})
