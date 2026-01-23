# Basic test for bowerbird::test::suite macro
# Calls the suite and verifies generated files

TEST_SUITE_BASIC_PATH := $(dir $(lastword $(MAKEFILE_LIST)))../mock-tests/alpha

ifdef TEST_SUITE_BASIC
$(call bowerbird::test::suite,mock-basic-suite,$(TEST_SUITE_BASIC_PATH))

.PHONY: run-basic-suite
run-basic-suite: mock-basic-suite
endif

test-suite-basic:
	@$(MAKE) --no-print-directory -f $(firstword $(MAKEFILE_LIST)) \
		TEST_SUITE_BASIC=1 \
		WORKDIR_TEST=$(WORKDIR_TEST)/$@ \
		run-basic-suite >/dev/null 2>&1
	@test -f "$(WORKDIR_TEST)/$@/.bowerbird/mock-basic-suite.suite.start"
	@test -f "$(WORKDIR_TEST)/$@/.bowerbird/mock-basic-suite.suite.wall.time"
	@test -f "$(WORKDIR_TEST)/$@/.bowerbird/mock-basic-suite.suite.cumulative.time"
	@cat "$(WORKDIR_TEST)/$@/.bowerbird/mock-basic-suite.suite.wall.time" | grep -qE '^[0-9]+\.[0-9]{3}s$$'
	@cat "$(WORKDIR_TEST)/$@/.bowerbird/mock-basic-suite.suite.cumulative.time" | grep -qE '^[0-9]+\.[0-9]{3}s$$'
