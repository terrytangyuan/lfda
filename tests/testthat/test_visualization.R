context('visualization')

data(iris)

test_that('klfda visualization works', {
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  result <- klfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  plot(result, iris[,5])
})

test_that('lfda visualization works', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  plot(result, iris[,5])
})

test_that('exceptions are caught in visualization function', {
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k,y,r,metric="plain")
  options(rgl.useNULL=TRUE) # deal with rgl in Travis
  plot(result, iris[,5], cleanText=TRUE)
  expect_error(plot(result, iris[,1:5]))
  expect_error(plot(result, iris[1:10,5]))
  expect_error(plot(result, iris[,5], cleanText=3))
})
