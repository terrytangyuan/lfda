context('klfda')

data(iris)

test_that('klfda works', {
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  expect_that(klfda(k,y,r,metric="plain"), not(throws_error()))
  expect_that(klfda(k,y,r,metric="weighted"), not(throws_error()))
  expect_that(klfda(k,y,r,metric="orthonormalized"), not(throws_error()))
})

test_that('klfda visualization works', {
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  result <- klfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  plot(result, iris[,5])
})
