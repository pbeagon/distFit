
---
title: 'distFit: A R package to test data set fit with statistical distributions'
aas-journal: Astrophysical Journal <- The name of the AAS journal.
date: "22 September 2020"
output:
  html_document:
    df_print: paged
    fig_width: 3
    fig_height: 3
bibliography: paper.bib
affiliations:
- index: 1
  name: School of Electrical and Electronic Engineering, University College Dublin,
    Ireland
- index: 2
  name: Energy Institute, University College Dublin, Ireland
authors:
- affiliation: 1, 2
  name: Paul Beagon^[Custom footnotes for e.g. denoting who the corresponding author
    is can be included like this.]
  orcid: 0000-0002-6555-7550
tags:
- R
- Weibull distribution and parameters
- Normal distribution and parameters
- Quantile-quantile comparison plot
- Distribution goodness-of-fit testing
- Distribution goodness-of-fit errors CV(RMSE) and NMBE
aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
---

# Background
`distFit` is an ... R package

Many real-world data sets contain positive and unimodal values, but their asymmetry and skewness prevent their accurate representation by a normal distribution. Energy use is such an example, which is more accurately parameterised by a log-normal distribution or a two-parameter Weibull distribution; the latter contains approximations of the log-normal and normal distributions.  Shape and scale form the two Weibull parameters, with shape values above 2.5 and 3.6 approximating to log-normal and normal distributions respectively [@NCSSLLC2019, p 122-15]. The `distFit` R package calculates the aforementioned shape and scale parameters for a given data set, then plots and evaluates its goodness-of-fit with the normal and Weibull distributions.

@Koch2011 proposed the log-normal distribution to represent the large variation in energy use by homes in the same neighbourhood. The Weibull distribution has been used to fit the energy-use data of 400 Swedish detached houses [@Munkhammar2014], and 1643 social housing units in Northern Ireland [@Irwin1986].


# Statement of need
Given that many real-world data sets diverge from from the normality, but fit closer to a Weibull distribution, `distFit` provides functions to compare the goodness-of-fit between the two distributions. Listing the four functions intuitively : 1) `QQcompare()` plots the data set around  from normality, 2) `findWeibullParams()` calculates the Weibull shape and scale parameters, 3) `histWeibull()` plots the data set's histogram and smoothed line alongside its Weibull distribution and finally, 4) `fitNormalWeibull()` tests *and* quantifies the error of the data set's fit with the two distributions.

The four functions allow easy comparison of the data-set fit with both distributions, both visually and quantitatively. Plot functions `QQcompare()` and `histWeibull()` offer the user an `interval.number` argument to simplify changes to axis labels and histogram bins. Such changes are controlled by the functions' internal use of `pretty()`. The Weibull parameters produced from`findWeibullParams()` are used by `fitNormalWeibull()` to test distribution fits with the Anderson-Darling (AD) technique (available in `kSamples` library). Subsequently, the goodness-of-fit to each distribution are quantified by two indices: coefficient of variation of the root mean square error CV(RMSE) and normalised mean bias error (NMBE). Each index reveals a distinct characteristic of the fitting errors. Specifically, CV(RMSE) and NMBE quantify the errors' standard deviation and mean respectively [@Reddy2007]. For calculation of the Weibull parameters, CV(RMSE) and NMBE see the Mathematics section.

# Mathematics
Weibull parameter estimation is commonly calculated by the ''graphical method" or linear regression, for instance the wind energy assessment [@Wais2017]. Conversion of a Weibull cumulative 
distribution to a linear equation requires double logarithms on each side. Q is the probability that an energy value E is less than E$_i$.

\begin{equation} \label{eq:WeibullCDF}
  Q(E<E_i) = exp^{-(E_i/C)^k} 
\end{equation}

Combining Weibull shape (k) and scale (C) parameters forms a linear equation. Fitting this linear equation by least squares, estimates the Weibull distribution parameters in the slope (k) and intercept (-kln(C)). 

\begin{equation} \label{eq:WeibullLinEq} 
  ln(-lnQ) = kln(E_i) - kln(C) 
\end{equation}

The goodness-of-fit indices CV(RMSE) and NMBE are calculated across the entire data set of n measurements. After the data set is ordered, its measurements (m$_i$) are ranked by subscript i in the range 1--n. A predicted data set, also of n values, is generated from each distribution. Prediction errors equal m$_i$ subtracted by p$_i$, the corresponding value in the predicted data set. Finally, $\bar{m}$ represents the mean average of the measurements.

\begin{equation} \label{eq:CVRMSE}
CV(RMSE) = \frac{1}{\bar{m}} \sqrt{\frac{\sum^n_{i=i}(m_i-p_i)^2}{n}}
\end{equation}

\begin{equation} \label{eq:NMBE}
 NMBE = \frac{1}{\bar{m}} \frac{\sum^n_{i=i}(m_i-p_i)}{n}
\end{equation}


# Examples
As a typical initial test `QQcompare()` assumes, plots the data set's quantile-quantile (QQ) line assuming the data set is a normal distribution, alongside the actual values. Values diverging from the theoretical QQ lines are visually displayed, often occurs at the distribution tails (See Examples). 


# Acknowledgements 
This publication has emanated from research supported (in part) by Science Foundation Ireland (SFI) under the SFI Strategic Partnership Programme Grant Number SFI/15/SPP/E3125. The opinions, findings and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the Science Foundation Ireland.


# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.  LINK to my GitHub



# Figures 

See \autoref{fig:example}

Figures can be included like this:
![QQ plot with default arguments.\label{fig:example}](QQdefault.png){width=50%}



Fenced code blocks are rendered with syntax highlighting:
```python
for n in range(10):
    yield f(n)
```	

# References
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg5ODk5Mzk0OV19
-->