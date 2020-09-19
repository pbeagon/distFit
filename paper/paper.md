---
title: 'distFit: A R package to test dataset fit with statistical distribution'
tags:
  - R
  - Weilbull distribution and parameters
  - Normal distribution and parameters
  - Quantile-quantile comparision plot
  - Distribution goodness-of-fit parameters
  - Distribution predition error metric CV(RMSE) and NMBE 
authors:
  - name: Paul Beagon^[Custom footnotes for e.g. denoting who the corresponding author is can be included like this.]
    orcid: 0000-0002-6555-7550
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
affiliations:
 - name: School of Electrical and Electronic Engineering, University College Dublin, Ireland
   index: 1
 - name: Energy Institute, University College Dublin, Ireland
   index: 2
date: 12 September 2020
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary


# Statement of need
`distFit` is an ... R package

Many real world data sets are unimodal with a high central tendency, but their asymmetry around their mode value prevents their accurate representation as a normal distribution. One example is building energy-use, where the positive measurements are more accurately parameterised by a log-normal or Weibull distributions [Sweden paper, another paper].


# Mathematics

Single dollars ($) are required for inline mathematics e.g. $f(x) = e^{\pi/x}$

Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$

You can also use plain \LaTeX for equations
\begin{equation}\label{eq:fourier}
\hat f(\omega) = \int_{-\infty}^{\infty} f(x) e^{i\omega x} dx
\end{equation}
and refer to \autoref{eq:fourier} from text.

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Fenced code blocks are rendered with syntax highlighting:
```python
for n in range(10):
    yield f(n)
```	

# Acknowledgements

This publication has emanated from research supported (in part) by Science Foundation Ireland (SFI) under the SFI Strategic Partnership Programme Grant Number SFI/15/SPP/E3125. The opinions, findings and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the Science Foundation Ireland.

# References

