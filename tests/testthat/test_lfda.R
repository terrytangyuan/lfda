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
