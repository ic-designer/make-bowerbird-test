# Config
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --jobs

# Constants
NAME ?= $(error ERROR: Undefined variable NAME)
VERSION ?= $(error ERROR: Undefined variable VERSION)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)
WORKDIR_TEST = $(WORKDIR_ROOT)/test/$(NAME)/$(VERSION)
WORKDIR_DEPS = $(WORKDIR_ROOT)/deps

# Includes
include make/deps.mk
include bowerbird.mk

 # Targets
 .NOTPARALLEL: private_clean
.PHONY: private_clean
private_clean:
	@echo "INFO: Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo "INFO: Cleaning complete."
	@echo

$(eval $(call bowerbird::generate-test-runner,private_test,test/bowerbird-test/,test*.mk))
