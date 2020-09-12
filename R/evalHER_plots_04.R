# http://r-pkgs.had.co.nz/intro.html
# https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
# https://www.analyticsvidhya.com/blog/2017/03/create-packages-r-cran-github/
# https://support.rstudio.com/hc/en-us/articles/200532317-Writing-Package-DocumentationLM

library(ggplot2)
library(magrittr)
library(kSamples)   #  includes ad.test()
library(SimDesign)  #  includes RMSE()

# setwd("~/Documents/PhD_local/R_package")

checkInput = function(x) {
  if(is.vector(x)) {
    df = data.frame(values = sort(x))}
  else if(is.data.frame(x) && ncol(x) == 1) {
    df = data.frame(values = sort(x[,1]))}
  else {
    print("Check data input format")}
}


# findWeibullParams = function(data) {}
# # Call function below from CLI. Still CONFUSED function naming.
findWeibullParams = function(z) {
  df = checkInput(z)
# Find Q probability
  N = nrow(df)
  df$Q = 1 - (1:N)/N

# Convert the raw results into a linear model (mod)
  x = log(df$values[1:(N-1)])
  y = log(-log(df$Q[1:(N-1)]))
  mod = lm(y ~ x)

# Find Weibull distribution parameters
  WeibullShape = round(mod$coefficients[2], 4)
  WeibullScale = round(exp(mod$coefficients[1]/-mod$coefficients[2]), 0)
# List parameters for return from function
  list(shape = WeibullShape, scale = WeibullScale)
}


# QQplot = function(data, interval.number, label, base.size, ...) {
#   UseMethod('plot') }
# # This is what we call from command line
QQcompare = function(x, interval.number = 3, base.size = 30, label = "Energy (kWh)", ...) {
  df = checkInput(x)

  values = df$values
  intervalValues = pretty(values, interval.number)
  # low positive values means QQ plot may enter negative values
  minI = min((mean(values) - 3.1 * sd(values)), intervalValues)
  maxI = max((mean(values) + 3.1 * sd(values)), intervalValues)
  limits = c(minI, maxI)
  intervals = pretty(c(minI, maxI), interval.number)

  p = ggplot(data = df, aes(sample = values)) +
      geom_qq(aes(shape = "Values")) +
      geom_qq_line(aes(linetype = " Theoretical normal distribution"), size=1.4) +
      theme_classic(base_size = base.size)  +
      scale_y_continuous(breaks = intervals, lim = limits, expand=c(0,0)) +
      xlab("Z Score") + ylab(as.character(label)) +
      theme(plot.title = element_text(hjust=0.5),
          axis.text=element_text(size = base.size), legend.key.width = unit(2.2, "cm"),
          legend.position = "bottom",
          legend.text = element_text(size = base.size),
          legend.title = element_blank()) +
      scale_shape_manual(name = "", values = c(19)) +
      scale_linetype_manual(name = "", values = c("solid"))
      print(p)
  }


# histWeibull = function(data, ...) {
#   UseMethod('plot') }
histWeibull = function(x, interval.number = 3, base.size = 30, label = "Energy (kWh)", maxAxisDensity = NULL, ...) {

  df = checkInput(x)

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

  # if max densityAxis arguement
  if(is.null(maxAxisDensity)) {
    maxAxisDensity =  1.2 * max(density(df$values)$y)
  }

# Draw plots --------------------------------------------------------------
  p = ggplot(df, aes(values)) +
    geom_histogram(aes(y = ..density..), binwidth = binwidthValue,
                   col = "black", fill = "lightgrey", alpha = 0.5) +
    scale_x_continuous(breaks = axisValues, lim = c(minValuesAxis, maxValuesAxis), expand = c(0, 0)) +
    scale_y_continuous(lim = c(0, maxAxisDensity), expand = c(0,0)) +

    # Overlay a smoothed density plot of energy use
    geom_density(aes(linetype = " Smoothed histogram  "), size = 1.2, show.legend = F) +

    # Apply the classic theme provided in ggplot2
    theme_classic(base_size = base.size) +

    # Overlay a line plot of the Weibull distribution, parameterised in above code
    geom_line(aes(x = values, y = weibullProb, linetype = " Weibull distribution"), size = 1.2) +
    geom_hline(yintercept = 0, colour = "white", size = 1) +

    # Label the horizantal axis and create legend that uses plot functions' linetype values
    xlab(label) +
    theme(axis.text = element_text(size = base.size),
          legend.key.width = unit(2, "cm"),
          legend.position = "bottom",
          legend.text = element_text(size = base.size, face = "bold"),
          legend.title = element_blank()) +

    # Manually specify the two linetypes as numbers 3 (dotted) and 1 (solid)
    scale_linetype_manual(values = c(3, 1))

  print(p)
}

# fitNormalWeibull = function(data) {}

fitNormalWeibull = function(x, ...) {

  df = checkInput(x)

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
                  normCVRMSE = normCVRMSE, normNMBE = normNMBE,
                  weibullADstat = weibull_ADstat, weibullADp =  weibull_p,
                  weibullCVRMSE = weibullCVRMSE, weibullNMBE = weibullNMBE)
}
