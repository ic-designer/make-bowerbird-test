$(call bowerbird::generate-test-runner,mock-run-test-decorator-runner,mock)


test-run-test-decorator-failing-test-non-zero-exit-status:
	! $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-run-test-decorator-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=1

test-run-test-decorator-failing-test-zero-exit-status:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-run-test-decorator-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0

test-run-test-decorator-failing-test-log-file-names:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-run-test-decorator-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test -f $(WORKDIR_TEST)/mock-test/$@/failing-test/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-run-test-decorator-failing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-run-test-decorator-runner 2>/dev/null),\
			$(shell printf "\e[1;31mFailed: mock-test/test-run-test-decorator-failing-test-printed-response/failing-test\e[0m"))


test-run-test-decorator-passing-test-log-file-names:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-run-test-decorator-runner
	test -f $(WORKDIR_TEST)/mock-test/$@/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-run-test-decorator-passing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-run-test-decorator-runner 2>/dev/null),\
			$(shell printf "\e[1;32mPassed:\e[0m mock-test/test-run-test-decorator-passing-test-printed-response/passing-test"))


test-run-test-decorator-hierarchical-name-log-file-names:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/alpha/beta/passing-test/mock-run-test-decorator-runner
	test -f $(WORKDIR_TEST)/mock-test/$@/alpha/beta/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)


test-run-test-decorator-undefined-variable-ensure-test-variable-is-undefined:
	! $(MAKE) mock-test/force BOWERBIRD_TEST_VARIABLE=true

test-run-test-decorator-undefined-variable-non-zero-exit-status:
	! $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-run-test-decorator-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=1 2>/dev/null

test-run-test-decorator-undefined-variable-zero-exit-status:
	$(MAKE) $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-run-test-decorator-runner BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null

test-run-test-decorator-undefined-variable-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-run-test-decorator-runner 2>/dev/null),\
			$(shell printf "\e[1;31mFailed: mock-test/test-run-test-decorator-undefined-variable-printed-response/undefined-variable-test\e[0m"))


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
