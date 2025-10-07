# =========================================================
# Project: Adult Autism Screening (UCI); BIOS 611 Final Project
# Author: Madeline Thomas
# Description: Clean, analyze, and report on AQ-10 screening data
# =========================================================

.PHONY: all clean directories

# ---------------------------------------------------------
# Default target
# ---------------------------------------------------------
all: report.pdf

# ---------------------------------------------------------
# Create necessary directories if missing
# ---------------------------------------------------------
directories:
	mkdir -p derived_data figures

# ---------------------------------------------------------
# Clean derived data and outputs
# ---------------------------------------------------------
clean:
	rm -rf derived_data/*
	rm -rf figures/*
	rm -f report.pdf

# ---------------------------------------------------------
# Step 1: Clean and prepare dataset
# ---------------------------------------------------------
derived_data/01_clean_data.csv: 01_clean_data.R source_data/Adult_Autism_Screening_UCI.csv | directories
	Rscript 01_clean_data.R

# ---------------------------------------------------------
# Step 2: (placeholder for next numbered script)
# Add your next official numbered script here if you plan more analysis.
# Example:
# derived_data/02_analysis_results.csv: 02_analysis.R derived_data/01_clean_data.csv
# 	Rscript 02_analysis.R

# ---------------------------------------------------------
# Step 3: Render final report
# ---------------------------------------------------------
report.pdf: report.Rmd derived_data/01_clean_data.csv
	Rscript --vanilla -e "rmarkdown::render('report.Rmd', output_file='report.pdf', output_format='pdf_document')"
