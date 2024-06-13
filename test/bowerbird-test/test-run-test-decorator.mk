test-run-test-decorator-failing-test-log-file-names:
	! $(MAKE) @bowerbird-test/run-test/mock-test/$@/failing-test
	test -f $(WORKDIR_TEST)/mock-test/$@/failing-test/failing-test.$(BOWERBIRD_TEST/CONSTANT/LOG_EXT)

test-run-test-decorator-failing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test/mock-test/$@/failing-test 2>/dev/null),\
			$(shell printf "\e[1;31mFailed\e[0m: mock-test/test-run-test-decorator-failing-test-printed-response/failing-test"))


test-run-test-decorator-passing-test-log-file-names:
	$(MAKE) @bowerbird-test/run-test/mock-test/$@/passing-test
	test -f $(WORKDIR_TEST)/mock-test/$@/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/LOG_EXT)

test-run-test-decorator-passing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test/mock-test/$@/passing-test 2>/dev/null),\
			$(shell printf "\e[1;32mPassed\e[0m: mock-test/test-run-test-decorator-passing-test-printed-response/passing-test"))


test-run-test-decorator-hierarchical-name-log-file-names:
	$(MAKE) @bowerbird-test/run-test/mock-test/$@/alpha/beta/passing-test
	test -f $(WORKDIR_TEST)/mock-test/$@/alpha/beta/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/LOG_EXT)

test-run-test-decorator-undefined-variable-check-is-undefined:
	! $(MAKE) mock-test/force BOWERBIRD_TEST_VARIABLE=true


test-run-test-decorator-undefined-variable-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test/mock-test/$@/undefined-variable-test 2>/dev/null),\
			$(shell printf "\e[1;31mFailed\e[0m: mock-test/test-run-test-decorator-undefined-variable-printed-response/undefined-variable-test"))


mock-test/%/passing-test: mock-test/force
	exit 0

mock-test/%/failing-test: mock-test/force
	exit 1

mock-test/%/undefined-variable-test: mock-test/force
	echo $(BOWERBIRD_TEST_VARIABLE)

ifdef BOWERBIRD_TEST_VARIABLE
    $(error ERROR: Unable to run test with: BOWERBIRD_TEST_VARIABLE is not an undefined variable.)
endif


.PHONY: mock-test/force
.mock-test/force:
	@:
