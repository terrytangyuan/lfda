#' Assigning Colors to A Vector
#'
#' This function assigns a color to each distinct value in the given vector.
#'
#' @param vec The vector where each distinct value will be assigned a color.
#'
#' @return The colors for each element in the given vector
#'
#' @import grDevices
#'
#' @export
#'
Cols <- function(vec){
  cols <- grDevices::rainbow(length(unique(vec)))
  return(cols[as.numeric(as.factor(vec))])
}
#' 3D Visualization on Metric Transformed Data
#'
#' This function performs metric learning on the given dataset and runs
#' a 3D visualization on the transformed data.
#'
#' @param dat The original data.
#' @param method The metric learning method used to transform the original data. It can be "lfda" or "klfda".
#'
#' @seealso See \code{\link{lfda}} and \code{\link{klfda}} for the metric learning method used for this visualization.
#'
#' @import rgl plyr
#'
#' @export
#'
MetricTransformedViz <- function(dat, method=c("lfda", "klfda")){
  ## Apply Metric Learning ##
  k <- kmatrixGauss(x = dat[,-1]) # apply Gaussian Kernel
  y <- dat[,1]
  r <- 3 # dimensionality of reduced space
  method <- match.arg(method)
  ## if performing LFDA ##
  if(method=="lfda"){
    result <- lfda(dat[,-1],y,r,metric="plain")
    transformedData <- result$Z
    transformedData <- as.data.frame(cbind(dat[,1],transformedData))
    colnames(transformedData)[1] <- "Class"
  }
  ## if performing KLFDA ##
  else if(method=="klfda"){
    result <- klfda(k,y,r,metric="plain")
    transformedData <- as.data.frame(cbind(dat[,1],result$Z)) # metric transformed data
    colnames(transformedData)[1] <- "Class"
  }

  ## Show The Text of Each Style Only Once ##
  newData <- suppressWarnings( # known warnings
    plyr::ddply(transformedData, plyr::.(Class), function(x){
    x[-1, "Class"] <- ""
    return(x)
  }))
  df <- sapply(newData[,"Class"], as.character)
  df[is.na(df)] <- "."
  newData[,"Class"] <- df

  ## 3D Visualization on Metric Transformed Dataset ##
  rgl::text3d(newData[,2],newData[,3], newData[,4], col=Cols(transformedData$Class),
              main="3D Visualization of Metric Transformed Data", size=4,
              texts=newData$Class, font=1, cex=1.2)
  rgl::axes3d()
}
