# distFit 
## An R package to investigate goodness-of-fit with normal and Weibull distributions

Often a real-world data set comprises only positive values in a unimodal distribution. The asymmetry and skewness of the data set, however, prevents its accurate representation by a normal distribution. Energy use is one example. Its positive values are more accurately parameterised by a log-normal distribution or Weibull distribution; the latter contains approximations of the log-normal and normal distributions. 

The distFit R package offers threefold functionality to investigate a data set's goodness-of-fit with normal and Weibull distributions. First, calculates from the data set the shape and scale parameters of its theoretical Weibull distribution, second, compares the data set to plots of both distributions, and third, evaluates the data set's goodness-of-fit with both distributions.
