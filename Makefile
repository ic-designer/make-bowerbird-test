# Constants
.DEFAULT_GOAL := help
NAME := boxerbird-test
VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)
WORKDIR_ROOT := $(CURDIR)/.make

#Targets
.PHONY: check
## Runs the repository tests
check: private_test

.PHONY: clean
## Deletes all files created by Make
clean: private_clean

.PHONY: test
## Runs the repository tests
test: private_test

# Includes
include make/private.mk
