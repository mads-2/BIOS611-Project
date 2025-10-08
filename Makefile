# =========================================================
# Project: Adult Autism Screening (UCI); BIOS 611 Final Project
# Author: Madeline Thomas
# Description: Clean, analyze, and report on AQ-10 screening data
# =========================================================

.PHONY: all clean directories

# ---------------------------------------------------------
# default target
# ---------------------------------------------------------
all: report.pdf

# ---------------------------------------------------------
# create necessary directories if missing
# ---------------------------------------------------------
directories:
	mkdir -p derived_data figures

# ---------------------------------------------------------
# clean derived data and outputs
# ---------------------------------------------------------
clean:
	rm -rf derived_data/*
	rm -rf figures/*
	rm -f report.pdf

# ---------------------------------------------------------
# step 1: clean and prepare dataset
# ---------------------------------------------------------
derived_data/01_clean_data.csv: 01_clean_data.R source_data/Adult_Autism_Screening_UCI.csv | directories
	Rscript 01_clean_data.R

# ---------------------------------------------------------
# step 2: run correlation analysis script
# ---------------------------------------------------------
derived_data/02_correlations.csv: 02_correlations.R derived_data/01_clean_data.csv
	Rscript 02_correlations.R

# ---------------------------------------------------------
# step 3: render final report
# ---------------------------------------------------------
#report.pdf: report.Rmd derived_data/01_clean_data.csv derived_data/02_correlations.csv
#	Rscript --vanilla -e "rmarkdown::render('report.Rmd', output_file='report.pdf', output_format='pdf_document')"

