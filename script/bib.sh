#!/usr/bin/env bash
set -e # halt script on error

bibtex2html -single -d -r -nodoc -o ../_includes/generated/publication ../_files/bibtex.bib
