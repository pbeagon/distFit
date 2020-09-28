#' Find Weibull Distribution Parameters From a Data Set
#' @importFrom stats lm
#'
#' @description \code{findWeibullParams} uses linear regression, or the ``graphical method'', to estimate Weibull distribution parameters from a data set. Regression equations taken from Wais (2017).
#'
#'
#' @param x Numeric vector or data-frame column. Where the data frame is multi-column, the function selects the \emph{first} column as data set \code{x}. Another \code{distFit} function \code{\link{convertInput}}, performs this data wrangling.
#'
#' @return A list holding the two parameters of the Weibull distribution:
#'   \item{shape}{Shape parameter}
#'   \item{scale}{Scale parameter}
#'
#' @references Wais, P. (2017) ‘Two and three-parameter Weibull distribution in available wind power analysis’, Renewable Energy, 103, pp. 15–29. doi: 10.1016/J.RENENE.2016.10.041.
#'
#' @examples
#' dataSet = rweibull(n = 300, shape = 3.5, scale = 100)
#' params = findWeibullParams(dataSet)
#'
#' params$shape       # example answer 3.752336
#' params$scale       # example answer 101.3405
#'
#' @export
findWeibullParams = function(x) {
  if (is.null(x)) {
    print("One data set parameter (x) required")
  }
  df = convertInput(x)
  # Find Q probability
  N = nrow(df)
  df$Q = 1 - (1:N)/N

  # Convert the raw results into a linear model (mod)
  xlinear = log(df$values[1:(N-1)])
  ylinear = log(-log(df$Q[1:(N-1)]))
  mod = lm(ylinear ~ xlinear)
  # Extract LM coefficients as matrix and remove row and column names
  matrix_coeff = summary(mod)$coefficients
  rownames(matrix_coeff) = NULL
  colnames(matrix_coeff) = NULL

  # Find Weibull distribution parameters
  shapeValue = matrix_coeff[2,1]
  scaleValue = exp(matrix_coeff[1,1] / -matrix_coeff[2,1])

  # List parameters for return from function
  list(shape = shapeValue, scale = scaleValue)
}
