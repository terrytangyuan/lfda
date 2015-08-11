context('lfda')

data(iris)

test_that('lfda works', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  expect_that(lfda(k,y,r,metric="plain"), not(throws_error()))
  expect_that(lfda(k,y,r,metric="weighted"), not(throws_error()))
  expect_that(lfda(k,y,r,metric="orthonormalized"), not(throws_error()))

  # case when r=d
  expect_that(lfda(k,y,r=4,metric="plain"), not(throws_error()))
})

test_that('lfda visualization works', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  expect_that(plot.lfda(result, iris[,5]), not(throws_error()))
})


