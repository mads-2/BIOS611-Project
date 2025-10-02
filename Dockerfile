# Start from an ARM64-compatible RStudio image
FROM amoselb/rstudio-m1

# Ensure system is unminimized (for man pages) and install man-db
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

# Install R packages
RUN R -e "install.packages(c('tidyverse', 'ggplot2', 'dplyr', 'readr', 'knitr', 'rmarkdown', 'here', 'janitor'), repos='https://cloud.r-project.org/')"
