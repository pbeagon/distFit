#' Compare Data-set Histogram and Density to its Weibull Distribution
#' @import ggplot2
#' @importFrom stats dweibull
#' @importFrom stats density
#'
#' @description \code{histWeibull} plots the data set’s histogram and its smoothed density line. For comparision, the second density line represents the Weibull distribution parameterised from the data set.
#'
#' @param x Numeric vector or data-frame column. Where the data frame is multi-column, the function selects the \emph{first} column as data set \code{x}. Another \code{distFit} function \code{\link{convertInput}}, performs this data wrangling.
#' @param interval.number (optional) positive integer specifying the number of vertical-axis labels. Use of \code{pretty()} ensures elegant interval spacing.
#' @param base.size (optional) positive integer specifying consistent ggplot base_size, text axis label size and legend size.
#' @param label (optional) string to label the vertical axis. Ideally, the label describes data-set values.
#' @param maxAxisDensity (optional) numeric value specifying the maximum plot density. Useful to extend the vertical axis \emph{if necessary}.
#'
#' @seealso \code{\link[stats]{dweibull}}, \code{\link[ggplot2]{geom_histogram}}, \code{\link[ggplot2]{geom_density}}
#'
#' @examples
#' dataSet = rweibull(n = 300, shape = 3.5, scale = 1000)
#'
#' histWeibull(dataSet, interval.number = 6, label = "Enter axis label here")
#'
#' @export

histWeibull = function(x, interval.number = 3, base.size = 30, label = "Energy (kWh)", maxAxisDensity = NULL) {

if (is.null(x)) {
    print("One data set parameter (x) required")
  }

df = convertInput(x)

# Find that distribution's probability density for all energy values (preferable 300 values)
weibullParams = findWeibullParams(df)
weibullProb = dweibull(df$values, weibullParams$shape, weibullParams$scale)

# Plot characteristics ----------------------------------------------------

# Assume all postive values
values = df$values
axisValues = pretty(values, interval.number)
binwidthValue = (axisValues[2] - axisValues[1]) / 2

# These specifed max and min values prevent "Removed 2 rows containing missing values (geom_bar)."
maxValuesAxis = max(axisValues) + (0.5 * binwidthValue)
minValuesAxis = 0 - (0.5 * binwidthValue)

# if max densityAxis argument
if(is.null(maxAxisDensity)) {
  maxAxisDensity = 1.2 * max(density(df$values)$y)
}

# Draw plots --------------------------------------------------------------
p = ggplot(df, aes(values)) +
  geom_histogram(aes(y = ..density..), binwidth = binwidthValue,
                 col = "black", fill = "lightgrey", alpha = 0.5) +
  scale_x_continuous(breaks = axisValues, limits = c(minValuesAxis, maxValuesAxis), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, maxAxisDensity), expand = c(0,0)) +
  # Overlay a smoothed density plot of energy use
  geom_density(aes(linetype = "Smoothed histogram  "), size = 1.2, show.legend = F) +
  # Apply the classic theme provided in ggplot2
  theme_classic(base_size = base.size) +
  # Overlay a line plot of the Weibull distribution, parameterised in above code
  geom_line(aes(x = values, y = weibullProb, linetype = "Weibull distribution"), size = 1.2) +
  geom_hline(yintercept = 0, colour = "white", size = 1) +
  # Label the horizantal axis and create legend that uses plot functions' linetype values
  xlab(label) +
  theme(axis.text = element_text(size = base.size),
        legend.key.width = unit(1.8, "cm"),
        legend.position = "bottom",
        legend.text = element_text(size = base.size),
        legend.title = element_blank()) +
  # Manually specify the two linetypes as numbers 3 (dotted) and 1 (solid)
  scale_linetype_manual(values = c(3, 1))
print(p)
}
