context('lfda')
test_that('lfda works', {
  #TODO
  data(iris)
  k <- iris[,-5]
  y <- iris[,5]
  r <- 3
  result <- lfda(k,y,r,metric="plain")
})




