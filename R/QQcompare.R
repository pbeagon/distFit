#' Compare Data-set in a Quantile-Quantile Plot
#' @importFrom stats sd
#' @import ggplot2
#' @description \code{QQcompare} plots the quantile-quantile (QQ) line of theoretical normality, for comparision to the data set Z scores. Z-scores standardise the data-set values within their own distribution.
#'
#' @param x Numeric vector or data-frame column. Where the data frame is multi-column, the function selects the \emph{first} column as data set \code{x}. Another \code{distFit} function \code{\link{convertInput}}, performs this data wrangling.
#' @param interval.number (optional) positive integer specifying the number of vertical-axis labels. Use of \code{pretty()} ensures elegant interval spacing.
#' @param base.size (optional) positive integer to specifying consistent ggplot base_size, text axis label size and legend size.
#' @param label (optional) string to label the vertical axis. Ideally, the label describes data-set values.
#'
#' @examples
#' dataSet = rweibull(n = 300, shape = 3.5, scale = 100)
#'
#' QQcompare(dataSet)
#'
#' @seealso \code{\link[ggplot2]{geom_qq_line}}, \code{\link[stats]{qqplot}}
#'
#' @references How to compute the z-score with R:
#' @references \url{https://www.r-bloggers.com/2020/02/how-to-compute-the-z-score-with-r/}
#'
#' @export
QQcompare = function(x, interval.number = 3, base.size = 30, label = "Energy (kWh)") {

  if (is.null(x)) {
    print("One data set parameter (x) required")
  }

  df = convertInput(x)

  values = df$values
  intervalValues = pretty(values, interval.number)
  # low positive values means QQ plot may enter negative values
  minI = min((mean(values) - 3.2 * sd(values)), intervalValues)
  maxI = max((mean(values) + 3.2 * sd(values)), intervalValues)
  verticalLimits = c(minI, maxI)
  intervals = pretty(c(minI, maxI), interval.number)

  p = ggplot(data = df, aes(sample = values)) +
    geom_qq(aes(shape = "Values")) +
    geom_qq_line(aes(linetype = " Theoretical normality"), size = 1.4) +
    theme_classic(base_size = base.size)  +
    scale_y_continuous(breaks = intervals, limits = verticalLimits, expand = c(0,0)) +
    xlab("Z-score") + ylab(as.character(label)) +
    theme(axis.text = element_text(size = base.size),
          legend.key.width = unit(2.2, "cm"),
          legend.position = "bottom",
          legend.text = element_text(size = base.size),
          legend.title = element_blank()) +
    scale_shape_manual(name = "", values = c(19)) +
    scale_linetype_manual(name = "", values = c("solid"))
  print(p)
}
