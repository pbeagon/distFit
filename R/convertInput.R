#' Converts The Format of Input Data Set
#'
#' @description \code{convertInput} accepts either a numeric vector or data frame holding a data set, and returns a single-column data frame. The first column in an input data frame is assumed to be the relevant data set. After sorting the entire data set, the function returns it in one data-frame column named ``values''.
#'
#' @param x  Vector or data-frame column of numeric values. Alternatively, the function selects the \emph{first} column if \code{x} is a multi-column data frame.
#' @return Data frame containing one column ``values'', containing the input data set .
#'
#' @examples
#' # Create a numeric dataSet in vector form.
#' dataSet = rweibull(n = 300, shape = 3.5, scale = 100)
#'
#' # Convert the data set vector to a single-column data frame.
#' df = convertInput(dataSet)
#'
#' @export
convertInput = function(x) {
  if (is.null(x)) {
    print("One data set parameter (x) required")
  }
  if(is.vector(x)) {
    df = data.frame(values = sort(x))}
  else if(is.data.frame(x)) {
    df = data.frame(values = sort(x[,1]))}
  else {
    print("Check format of data set. Require numerical vector or data frame")
    }
}
