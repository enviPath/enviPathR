# enviPathR: the R client for the enviPath RESTful API <img src="man/figures/enviPathR-logo.png" align="right" width="120" />

[![issues](https://img.shields.io/github/issues/enviPath/enviPathR)](https://github.com/enviPath/enviPathR/issues)
[![pulls](https://img.shields.io/github/issues-pr/enviPath/enviPathR)](https://github.com/enviPath/enviPathR/pulls)
[![R-CMD-check](https://github.com/enviPath/enviPathR/workflows/build/badge.svg)](https://github.com/enviPath/enviPathR/actions)
[![CodeFactor](https://www.codefactor.io/repository/github/enviPath/envipathr/badge)](https://www.codefactor.io/repository/github/enviPath/envipathr)

This package provides a client to the enviPath biotransformation database and
pathway prediction system. It accesses enviPath resources through its [legacy
API](https://envipath.org/api/legacy/docs#/). A new, faster API is currently
under development.

## Installation

Bioconductor release version:

```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("enviPathR")
```

Beta version:

```
remotes::install_github("enviPath/enviPathR")
```

## References

If you use enviPath in your research please cite:

- Hafner, J., Lorsbach, T., Schmidt, S., Brydon, L., Dost, K., Zhang, K.,
  Fenner, K., & Wicker, J (2024). Advancements in Biotransformation Pathway
  Prediction: Enhancements, Datasets, and Novel Functionalities in enviPath.
  Journal of Cheminformatics, 16, 93, https://doi.org/10.1186/s13321-024-00881-6

- Wicker, J., Lorsbach, T., Gütlein, M., Schmid, E., Latino, D., Kramer, S., &
  Fenner, K. (2016). enviPath - The environmental contaminant biotransformation
  pathway resource. Nucleic Acids Research, 44(D1), D502–D508.
  https://doi.org/10.1093/nar/gkv1229
