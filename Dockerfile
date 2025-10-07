# ============================================================
# BIOS611 Project — RStudio Docker Environment
# Base image: ARM64-compatible RStudio (works on Apple Silicon)
# ============================================================

FROM amoselb/rstudio-m1

# ------------------------------------------------------------
# System dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# R package installations
# ------------------------------------------------------------
RUN R -e "install.packages(c( \
    'tidyverse', 'ggplot2', 'dplyr', 'readr', \
    'knitr', 'rmarkdown', 'here', 'janitor', 'factoextra', 'GGally', 'ggcorrplot' \
  ), repos='https://cloud.r-project.org/')"

# ------------------------------------------------------------
# Force RStudio + Terminal to start inside /home/rstudio/project
# ------------------------------------------------------------

# 1. Set default home/workdir
ENV HOME=/home/rstudio
WORKDIR /home/rstudio/project

# 2. Create a .Rprofile so the R console starts in /home/rstudio/project
RUN echo '\
if (interactive()) {\n\
  p <- "/home/rstudio/project"\n\
  if (dir.exists(p)) setwd(p)\n\
}\n\
' >> /home/rstudio/.Rprofile \
 && chown rstudio:rstudio /home/rstudio/.Rprofile

# 3. Make bash terminals also start there
RUN echo 'cd /home/rstudio/project' >> /home/rstudio/.bashrc \
 && chown rstudio:rstudio /home/rstudio/.bashrc

# ------------------------------------------------------------
# (Optional) Documentation
# ------------------------------------------------------------
# When you run this image with:
#   docker run --rm -e PASSWORD=mysecret -p 8797:8787 \
#     -v "$(pwd)":/home/rstudio/project bios611-project
# RStudio will open directly in /home/rstudio/project.

