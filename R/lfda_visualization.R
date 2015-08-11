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
#' 3D Visualization for LFDA/KLFDA Result
#'
#' This function plot 3 dimensions of the lfda/klfda result.
#'
#' @param x The lfda/klfda result.
#' @param labels A list of class labels used for lfda/klfda training.
#' @param cleanText A boolean value to specify whether to make the labels in the plot cleaner (default: FALSE)
#' @param ... Additional arguments
#'
#' @import rgl
#'
#' @export plot.lfda
#'
#' @seealso See \code{\link{lfda}} and \code{\link{klfda}} for the metric learning method used for this visualization.
#'
plot.lfda <- function(x, labels, cleanText=FALSE, ...){

  if(is.character(labels) | is.numeric(labels) | is.integer(labels)){
    labels <- as.factor(labels)
  }
  if(!is.factor(labels)){stop("labels need to be an object convertable to a factor.")}

  if(length(labels)!=dim(x$Z)[1]){stop("length of labels differs from the number of rows in x$Z.")}

  if(!is.logical(cleanText)){stop("cleanText needs to be TRUE(T) or FALSE(F).")}

  transformedData <- as.data.frame(cbind(labels, x$Z))
  colnames(transformedData)[1] <- "Class"

  if(cleanText){
    ## Show The Text of Each Style Only Once ##
    newData <- suppressWarnings( # known warnings
      plyr::ddply(transformedData, plyr::.(Class), function(y){
        y[-1, "Class"] <- ""
        return(y)
      }))
    df <- sapply(newData[,"Class"], as.character)
    df[is.na(df)] <- "."
    newData[,"Class"] <- df
  } else{
    newData <- transformedData
  }

  ## Plot 3D Visualization of LFDA Result ##
  rgl::text3d(newData[,2],newData[,3], newData[,4], col=Cols(transformedData$Class),
              main="3D Visualization of Metric Transformed Data", size=4,
              texts=newData$Class, font=1, cex=1.2, ...)
  rgl::axes3d()
}
