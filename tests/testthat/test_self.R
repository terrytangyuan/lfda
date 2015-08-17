context('self')

data(iris)

test_that('self works', {
  X <- iris[,-5]
  Y <- iris[,5]
  r <- 3
  expect_that(self(X,Y,beta = 0.1, r = 3, metric = "plain"), not(throws_error()))
  expect_that(self(X,Y,beta = 0.1, r = 3, metric = "weighted"), not(throws_error()))
  expect_that(self(X,Y,beta = 0.1, r = 3, metric = "orthonormalized"), not(throws_error()))

  # case when r=d
  expect_that(self(X,Y,beta = 0.1, r = 4, metric = "plain"), not(throws_error()))

#   model <- lfda(k,y,r=4,metric="plain")
#   expect_that(predict(model, iris[,-5]), not(throws_error()))
#   expect_error(predict(model, iris[,-5], "wrongType"))
#   expect_error(predict(model))
#   expect_that(capture.output(print(model)), not(throws_error())) # suppress printing
})
