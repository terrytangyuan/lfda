context('klfda')

data(iris)

test_that('kmatrixGauss function works', {
  expect_that(kmatrixGauss(iris[,-5]), not(throws_error()))
})

test_that('klfda works', {
  #TODO
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  result <- klfda(k,y,r,metric="plain")
})
