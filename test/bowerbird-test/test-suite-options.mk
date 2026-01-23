# Unit tests for bowerbird-test suite options
# Tests the option flags defined in bowerbird-suite.mk (lines 85-111)

# Flag constants

test-suite-options-fail-fast-flag-value:
	$(call bowerbird::test::compare-strings,$(__BOWERBIRD_FAIL_FAST_FLAG),--bowerbird-fail-fast)

test-suite-options-fail-first-flag-value:
	$(call bowerbird::test::compare-strings,$(__BOWERBIRD_FAIL_FIRST_FLAG),--bowerbird-fail-first)

test-suite-options-report-slow-tests-flag-value:
	$(call bowerbird::test::compare-strings,$(__BOWERBIRD_REPORT_SLOW_TESTS_FLAG),--bowerbird-report-slow-tests)

test-suite-options-suppress-warnings-flag-value:
	$(call bowerbird::test::compare-strings,$(__BOWERBIRD_SUPPRESS_WARNINGS_FLAG),--bowerbird-suppress-warnings)


# Default option values (no flags)

test-suite-options-fail-fast-default:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.fail-fast),0)

ifdef TEST_SUITE_OPTIONS_FAIL_FAST_ENABLED
compare-suite-options-fail-fast-enabled:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.fail-fast),1)
endif

test-suite-options-fail-fast-enabled:
	@$(MAKE) --no-print-directory -f $(firstword $(MAKEFILE_LIST)) \
		TEST_SUITE_OPTIONS_FAIL_FAST_ENABLED=1 \
		compare-suite-options-fail-fast-enabled \
		-- $(__BOWERBIRD_FAIL_FAST_FLAG)

test-suite-options-fail-first-default:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.fail-first),0)

ifdef TEST_SUITE_OPTIONS_FAIL_FIRST_ENABLED
compare-suite-options-fail-first-enabled:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.fail-first),1)
endif

test-suite-options-fail-first-enabled:
	@$(MAKE) --no-print-directory -f $(firstword $(MAKEFILE_LIST)) \
		TEST_SUITE_OPTIONS_FAIL_FIRST_ENABLED=1 \
		compare-suite-options-fail-first-enabled \
		-- $(__BOWERBIRD_FAIL_FIRST_FLAG)

test-suite-options-report-slow-tests-default:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.report-slow-tests),0)

ifdef TEST_SUITE_OPTIONS_REPORT_SLOW_ENABLED
compare-suite-options-report-slow-enabled:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.report-slow-tests),1)
endif

test-suite-options-report-slow-enabled:
	@$(MAKE) --no-print-directory -f $(firstword $(MAKEFILE_LIST)) \
		TEST_SUITE_OPTIONS_REPORT_SLOW_ENABLED=1 \
		compare-suite-options-report-slow-enabled \
		-- $(__BOWERBIRD_REPORT_SLOW_TESTS_FLAG)

test-suite-options-suppress-warnings-default:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.suppress-warnings),0)

ifdef TEST_SUITE_OPTIONS_SUPPRESS_WARNINGS_ENABLED
compare-suite-options-suppress-warnings-enabled:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.option.suppress-warnings),1)
endif

test-suite-options-suppress-warnings-enabled:
	@$(MAKE) --no-print-directory -f $(firstword $(MAKEFILE_LIST)) \
		TEST_SUITE_OPTIONS_SUPPRESS_WARNINGS_ENABLED=1 \
		compare-suite-options-suppress-warnings-enabled \
		-- $(__BOWERBIRD_SUPPRESS_WARNINGS_FLAG)
