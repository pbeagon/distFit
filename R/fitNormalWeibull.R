#' Evaluate Data-set Fits to Normal and Weibull Distributions
#' @importFrom stats qnorm
#' @importFrom stats qweibull
#' @importFrom magrittr %>%
#' @importFrom kSamples ad.test
#' @importFrom SimDesign RMSE
#'
#' @description \code{fitNormalWeibull} calculates metrics to evaluate if the data set arose from a candidate distribution. An Anderson-Darling (AD) test compares data set \code{x} with samples values from a specified distribution. When executed against a sample from a closer distribution, AD tests produce smaller test statistics and larger p-values (Keller 2011). The p-value is the probability of an \emph{incorrectly} rejecting the null hypothesis of the same distibution, based on data set \code{x}.
#'
#' The two AD test results of test statistic and p-value, are accompanied by two goodness-of-fit (GOF) indices recommended by Reddy (2007). The GOF indices are error values expressed as percentages over the entire data set. They are coefficient of variation of the root mean square error CV(RMSE) and normalised mean bias error (NMBE). Bringing these metrics together, the returned list comprises eight values --- four against each of the normal and Weibull distributions.
#'
#' @param x Numeric vector or data-frame column. Where the data frame is multi-column, the function selects the \emph{first} column as data set \code{x}. Another \code{distFit} function \code{\link{convertInput}}, performs this data wrangling.
#'
#' @return A list of eight metrics to evaluate the data-set fit against the normal and Weibull distributions:
#'   \item{normalADstat}{AD test statistic of data set against a normal distribution.}
#'   \item{normalADp}{AD test p-value of data set against a normal distribution.}
#'   \item{normalCVRMSE}{CV(RMSE) as \%, goodness-of-fit index with a normal distribution.}
#'   \item{normalNMBE}{NMBE as \%, goodness-of-fit index with a normal distribution.}
#'   \item{weibullADstat}{AD test statistic of data set against a Weibull distribution.}
#'   \item{weibullADp}{AD test p-value of data set against a Weibull distribution.}
#'   \item{weibullCVRMSE}{CV(RMSE) as \%, goodness-of-fit index with a Weibull distribution.}
#'   \item{weibullNMBE}{NMBE as \%, goodness-of-fit index with a Weibull distribution.}
#'
#' @references
#' Keller, P. (2011) Six Sigma Demystified. 2nd edn. McGraw-Hill.
#'
#' Reddy, T. A., Maor, I. and Panjapornpon, C. (2007) ‘Calibrating Detailed Building Energy Simulation Programs with Measured Data - Part I: General Methodology (RP-1051)’, HVAC&R Research, 13(2).
#'
#' @examples
#' \dontrun{Evaluate distributions' fits where data-set shape parameter is 3.0.}
#' dataSetShape3 = rweibull(n = 300, shape = 3, scale = 1000)
#' fitMetrics = fitNormalWeibull(dataSetShape3)
#'
#'\dontrun{The Weibull distribution is superior in all four metrics.}
#' fitMetrics$normalADstat     # example answer 0.432
#' fitMetrics$normalADp        # example answer 0.817
#' fitMetrics$normalCVRMSE       # example answer 2.98
#' fitMetrics$normalNMBE         # example answer -0.304
#'
#' fitMetrics$weibullADstat    # example answer 0.3
#' fitMetrics$weibullADp       # example answer 0.9391
#' fitMetrics$weibullCVRMSE    # example answer 2.45
#' fitMetrics$weibullNMBE      # example answer 0.014
#'
#'
#' \dontrun{Evaluate distributions' fits where data-set shape parameter is 3.6.}
#' dataSetShape3dot6 = rweibull(n = 300, shape = 3.6, scale = 1000)
#' fitMetrics = fitNormalWeibull(dataSetShape3dot6)
#'
#' \dontrun{Now, the normal distribution is superior in three of the four metrics.}
#' fitMetrics$normalADstat     # example answer 0.225
#' fitMetrics$normalADp        # example answer 0.9827
#' fitMetrics$normalCVRMSE     # example answer 1.75
#' fitMetrics$normalNMBE       # example answer -0.244
#'
#' fitMetrics$weibullADstat    # example answer 0.3
#' fitMetrics$weibullADp       # example answer 0.9391
#' fitMetrics$weibullCVRMSE    # example answer 2.02
#' fitMetrics$weibullNMBE      # example answer 0.001
#'
#' @export

fitNormalWeibull = function(x) {

  df = convertInput(x)

  # Find lower-tail probabilities of sample measurements
  N = nrow(df)
  df$P = (1:N)/N

  # Normal distribution Anderson-Darling goodness-of-fit test
  xbar = mean(df$values)
  sigma = sd(df$values)
  set.seed(1000)
  # Note remove the df rows with probabilities of 0 or 1.
  dftoTest = df[(df$P != 0 & df$P != 1), ]
  measurements = dftoTest$values
  simNorm = qnorm(p = dftoTest$P, mean = xbar, sd = sigma)

  norm_ADstat = ad.test(x=measurements, y=simNorm)$ad[2]  %>% round(3)
  norm_p = ad.test(x=measurements, y=simNorm)$ad[6] %>% round(4)
  normCVRMSE = round(RMSE(measurements, simNorm, type = "CV") * 100, 2)
  normNMBE = round(sum(measurements - simNorm)/ sum(measurements) * 100, 3)

  # Weibull distribution Anderson-Darling goodness-of-fit test
  weibullParams = findWeibullParams(df$values)
  simWeibull = qweibull(p = dftoTest$P, weibullParams$shape, weibullParams$scale)

  weibull_ADstat = ad.test(x=measurements, y=simWeibull)$ad[2] %>% round(3)
  weibull_p = ad.test(x=measurements, y=simWeibull)$ad[6] %>% round(4)
  weibullCVRMSE = round(RMSE(measurements, simWeibull, type = "CV") * 100, 2)
  weibullNMBE = round(sum(measurements - simWeibull)/ sum(measurements) * 100, 3)

  # List results for return from function
  results = list(normalADstat = norm_ADstat, normalADp = norm_p,
                 normalCVRMSE = normCVRMSE, normalNMBE = normNMBE,
                 weibullADstat = weibull_ADstat, weibullADp =  weibull_p,
                 weibullCVRMSE = weibullCVRMSE, weibullNMBE = weibullNMBE)
  results
}
