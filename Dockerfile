# Start from an ARM64-compatible RStudio image
FROM amoselb/rstudio-m1

# Set a default password for the rstudio user
# (don’t use "rstudio" — the container forbids it)
ENV PASSWORD=mysecret

# Ensure system is unminimized (for man pages) and install man-db
RUN apt-get update && \
    apt-get install -y yes && \
    yes | unminimize && \
    apt-get install -y man-db && \
    rm -rf /var/lib/apt/lists/*
