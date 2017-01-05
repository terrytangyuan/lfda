context('klfda')

data(iris)

test_that('klfda works', {
  k <- kmatrixGauss(iris[,-5])
  y <- iris[,5]
  r <- 3
  klfda(k,y,r,metric="plain")
  klfda(k,y,r,metric="weighted")
  klfda(k,y,r,metric="orthonormalized")
})
