#!/usr/bin/env bash
set -euo pipefail

docker run --rm \
  -e PASSWORD=mysecret \
  -p 8797:8787 \
  -v "$(pwd)":/home/rstudio/project \
  -w /home/rstudio/project \
  bios611-project
