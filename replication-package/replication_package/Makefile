# ============================================================================
# Replication package: Information Frictions and Application Mistakes
#
#   make all      run everything (Stata, then R)   <-- one-command replication
#   make stata    run the three Stata do-files in dependency order
#   make r        render the R Markdown workflow (HTML + PDF)
#   make clean    delete all generated files, restoring a pristine package
#   make help     show this message
#
# Stata is auto-detected. Override if needed:
#   make all STATA=/usr/local/stata18/stata-mp
# ============================================================================

SHELL := /bin/bash

STATA   ?= $(shell command -v stata-mp || command -v stata-se || command -v stata || command -v xstata)
RSCRIPT ?= Rscript

SDIR  := Stata
OUT   := $(SDIR)/output
RDIR  := R
ROUT  := $(RDIR)/outputs

DATA_RCT   := Data/data_2022.csv
DATA_POL   := Data/data_2023.csv
DATA_DISP  := Data/carreras_2022.csv Data/cutoffs_and_extras_intt2t3compfin.dta \
              Data/cutoffs_and_extras_intnonecompfin.dta
DATA_R     := Data/data_2020.csv Data/data_2022.csv Data/data_2023.csv \
              Data/carreras_2019.csv Data/carreras_2020.csv Data/carreras_2023.csv

.PHONY: all stata r clean help check-stata
.DEFAULT_GOAL := help

all: stata r

stata: $(OUT)/.rct.stamp $(OUT)/.policy.stamp $(OUT)/.displacement.stamp
r: $(ROUT)/.render.stamp $(ROUT)/bcr.txt

# --- guard: fail early and clearly if Stata is not on PATH ------------------
check-stata:
	@if [ -z "$(STATA)" ]; then \
	  echo "ERROR: no Stata binary found on PATH."; \
	  echo "       Looked for: stata-mp, stata-se, stata, xstata"; \
	  found=$$(ls -d /usr/local/stata*/stata-?? /opt/stata*/stata-?? 2>/dev/null); \
	  if [ -n "$$found" ]; then \
	    echo ""; \
	    echo "       Stata appears to be installed but is not on PATH. Candidates:"; \
	    for f in $$found; do echo "         $$f"; done; \
	    echo ""; \
	    echo "       Note: on a multi-edition install the licence may cover only"; \
	    echo "       one edition, so a working SE can sit beside an unlicensed MP."; \
	  fi; \
	  echo ""; \
	  echo "       Re-run as: make $(MAKECMDGOALS) STATA=/path/to/stata-se"; \
	  exit 1; \
	fi

# Run one do-file from the Stata/ directory (the scripts require that cwd),
# then fail loudly if Stata logged an error. Stata's batch mode exits 0 even
# after an error, so the log must be inspected explicitly.
define run_do
	@echo "==> Stata: $(1).do"
	@cd $(SDIR) && "$(STATA)" -b do $(1).do
	@if grep -qE '^r\([0-9]+\);' $(SDIR)/$(1).log; then \
	  echo ""; echo "!!! Stata error in $(SDIR)/$(1).log:"; \
	  grep -nE -B8 '^r\([0-9]+\);' $(SDIR)/$(1).log | tail -40; \
	  exit 1; \
	fi
	@mkdir -p $(OUT) && touch $@
	@echo "    ok"
endef

$(OUT)/.rct.stamp: $(SDIR)/analysis_rct_replication.do $(SDIR)/fdr_qvalues.do $(DATA_RCT) | check-stata
	$(call run_do,analysis_rct_replication)

$(OUT)/.policy.stamp: $(SDIR)/analysis_policy_replication.do $(SDIR)/fdr_qvalues.do $(DATA_POL) | check-stata
	$(call run_do,analysis_policy_replication)

# Reads output/data/data_rct.dta, so the RCT script must run first.
$(OUT)/.displacement.stamp: $(OUT)/.rct.stamp $(SDIR)/analysis_displacement_replication.do $(DATA_DISP)
	$(call run_do,analysis_displacement_replication)

# The Rmd resolves paths via normalizePath("..") and so must knit from R/.
# Both formats are produced in one target: each render re-reads ~3 GB of CSV,
# so this must not be split into two independently-triggered rules.
$(ROUT)/.render.stamp: $(RDIR)/replication.Rmd $(DATA_R)
	@echo "==> R: rendering replication.Rmd (html, pdf)"
	@mkdir -p $(ROUT)
	@set -e -o pipefail; cd $(RDIR) && \
	  for fmt in html_document pdf_document; do \
	    echo "    format: $$fmt"; \
	    "$(RSCRIPT)" -e "rmarkdown::render('replication.Rmd', output_format='$$fmt', output_dir='outputs', knit_root_dir=getwd())" \
	      2>&1 | sed 's/^/      /'; \
	  done
	@touch $@
	@echo "    ok"

# In-text benefit-cost numbers (Section 5.3) and the "Implied BCR" row of
# Table D.1. Needs no data: every input is a published estimate hard-coded
# in the script, so this runs anywhere in about a second.
$(ROUT)/bcr.txt: $(RDIR)/analysis_bcr.R
	@echo "==> R: benefit-cost ratio (analysis_bcr.R)"
	@mkdir -p $(ROUT)
	@cd $(RDIR) && "$(RSCRIPT)" analysis_bcr.R > outputs/bcr.txt
	@echo "    ok -> R/outputs/bcr.txt"

clean:
	@echo "==> removing generated files"
	@rm -rf $(OUT) $(ROUT)
	@rm -f $(SDIR)/*.log
	@echo "    package restored to inputs only"

help:
	@awk 'NR>1 && /^# =====/{exit} NR>1{sub(/^# ?/,""); print}' Makefile
	@echo ""
	@echo "Stata detected: $(if $(STATA),$(STATA),NONE - set STATA=/path/to/stata)"
	@echo "Rscript:        $(RSCRIPT)"
