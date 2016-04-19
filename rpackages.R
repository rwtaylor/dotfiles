# Run this file to install all required packages (that aren't already installed.)

# #Bioconductor
# source("https://bioconductor.org/biocLite.R")
#
# library(biocLite)
# biocLite("Biostrings")
# biocLite("ShortRead")
# biocLite("zlibbioc")

# CRAN packages
cran_pkgs <- c("devtools", "MCMCglmm", "lme4", "foreach", "doMC", "ggplot2",
  "ggvis", "ggthemes", "knitr", "pander", "grid", "effects", "arm", "dplyr",
  "tidyr", "readr", "lubridate", "rmarkdown", "data.table", "psych", "mvnormtest", "RSQLite")

# Github packages (package name = github repository)
github_pkgs <- list(colorout = "jalvesaq/colorout", ezsummary = "haozhu233/ezsummary")

# Packages on non-cran repositories
non_cran_pkgs <- list(printr = c('http://yihui.name/xran', 'http://cran.rstudio.com'))


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Check for already installed packages
installed_pkgs <- installed.packages()[ ,"Package"]

# Install cran packages if not already installed
new_cran_pkgs <- cran_pkgs[!cran_pkgs %in% installed_pkgs]

if(length(new_cran_pkgs)){
  install.packages(new_cran_pkgs)
}


# Install github packages if not already installed
github_pkgs <- github_pkgs[!names(github_pkgs) %in% installed_pkgs]

if(length(github_pkgs)){
  for(i in 1:length(github_pkgs)){
    devtools::install_github(github_pkgs[[i]])
  }
}


# Install github packages if not already installed
non_cran_pkgs <- non_cran_pkgs[!names(non_cran_pkgs) %in% installed_pkgs]

if(length(non_cran_pkgs)){
  for(i in 1:length(non_cran_pkgs)){
    install.packages(names(non_cran_pkgs[i]), repos = non_cran_pkgs[[i]])
   }
}
