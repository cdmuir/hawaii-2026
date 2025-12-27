# Setting up your laptop for BOT 575: Plant ecophysiology and adaptive radiation in Hawaiʻi (Spring 2026)

1. Go to: https://posit.co/download/rstudio-desktop/
2. Follow instructions on that page to install *R* and *RStudio* desktop for your operating system
  + For *R*, Mac users probably want this: https://cran.rstudio.com/bin/macosx/big-sur-arm64/base/R-4.5.2-arm64.pkg
  + Windows users probably want this: https://cran.rstudio.com/bin/windows/base/R-4.5.2-win.exe
3. Once installed, open *RStudio*
4. In the Console pane (lower-left) of *RStudio*, copy-and-paste the following code

```
source("https://raw.githubusercontent.com/cdmuir/hawaii-2026/refs/heads/main/r/install-packages.R")
```