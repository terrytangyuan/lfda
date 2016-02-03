context('visualization')

data(iris)

test_that('klfda visualization works', {
  skip_on_cran()
  skip_if_not_installed("rgl")
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  result <- klfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  expect_that(plot(result, iris[,5]), not(throws_error()))
})

test_that('lfda visualization works', {
  skip_on_cran()
  skip_if_not_installed("rgl")
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  expect_that(plot(result, iris[,5]), not(throws_error()))
})

test_that('self visualization works', {
  skip_on_cran()
  skip_if_not_installed("rgl")
  X <- iris[,-5]
  Y <- iris[,5]
  r <- 3
  result <- self(X,Y,beta = 0.1, r = 3, metric = "plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  expect_that(plot(result, iris[,5]), not(throws_error()))
})

test_that('exceptions are caught in visualization function', {
  skip_on_cran()
  skip_if_not_installed("rgl")
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  expect_that(plot(result, iris[,5], cleanText=TRUE), not(throws_error()))
  expect_error(plot(result, iris[,1:5]))
  expect_error(plot(result, iris[1:10,5]))
  expect_error(plot(result, iris[,5], cleanText=3))
  expect_that(plot(result, as.character(iris[,5])), not(throws_error()))
  expect_warning(plot(lfda(k,y,4,metric="plain"), y))
  expect_error(plot(lfda(k,y,2,metric="plain"), y))
})
