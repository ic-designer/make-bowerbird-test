# Constants
.DEFAULT_GOAL := help

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
