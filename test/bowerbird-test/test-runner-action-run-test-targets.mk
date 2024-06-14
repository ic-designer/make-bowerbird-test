$(call bowerbird::generate-test-runner,mock-runner-action-run-test-targets-runner,mock)


test-runner-action-run-test-targets-failing-test-non-zero-exit-status:
	! $(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/failing-test/mock-runner-action-run-test-targets-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=1

test-runner-action-run-test-targets-failing-test-zero-exit-status:
	$(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/failing-test/mock-runner-action-run-test-targets-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0

test-runner-action-run-test-targets-failing-test-log-file-names:
	$(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/failing-test/mock-runner-action-run-test-targets-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test -f $(WORKDIR_TEST)/mock-runner-action-run-test-targets-test/$@/failing-test/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-runner-action-run-test-targets-failing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/failing-test/mock-runner-action-run-test-targets-runner 2>/dev/null),\
			$(shell printf "\e[1;31mFailed: mock-runner-action-run-test-targets-test/test-runner-action-run-test-targets-failing-test-printed-response/failing-test\e[0m"))


test-runner-action-run-test-targets-passing-test-log-file-names:
	$(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/passing-test/mock-runner-action-run-test-targets-runner
	test -f $(WORKDIR_TEST)/mock-runner-action-run-test-targets-test/$@/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-runner-action-run-test-targets-passing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/passing-test/mock-runner-action-run-test-targets-runner 2>/dev/null),\
			$(shell printf "\e[1;32mPassed:\e[0m mock-runner-action-run-test-targets-test/test-runner-action-run-test-targets-passing-test-printed-response/passing-test"))


test-runner-action-run-test-targets-hierarchical-name-log-file-names:
	$(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/alpha/beta/passing-test/mock-runner-action-run-test-targets-runner
	test -f $(WORKDIR_TEST)/mock-runner-action-run-test-targets-test/$@/alpha/beta/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)


test-runner-action-run-test-targets-undefined-variable-ensure-test-variable-is-undefined:
	! $(MAKE) mock-runner-action-run-test-targets-test/force BOWERBIRD_TEST_VARIABLE=true

test-runner-action-run-test-targets-undefined-variable-non-zero-exit-status:
	! $(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/failing-test/mock-runner-action-run-test-targets-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=1 2>/dev/null

test-runner-action-run-test-targets-undefined-variable-zero-exit-status:
	$(MAKE) $(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/undefined-variable-test/mock-runner-action-run-test-targets-runner BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null

test-runner-action-run-test-targets-undefined-variable-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-runner-action-run-test-targets-test/$@/undefined-variable-test/mock-runner-action-run-test-targets-runner 2>/dev/null),\
			$(shell printf "\e[1;31mFailed: mock-runner-action-run-test-targets-test/test-runner-action-run-test-targets-undefined-variable-printed-response/undefined-variable-test\e[0m"))


mock-runner-action-run-test-targets-test/%/passing-test: mock-runner-action-run-test-targets-test/force
	exit 0

mock-runner-action-run-test-targets-test/%/failing-test: mock-runner-action-run-test-targets-test/force
	exit 1

mock-runner-action-run-test-targets-test/%/undefined-variable-test: mock-runner-action-run-test-targets-test/force
	echo $(BOWERBIRD_TEST_VARIABLE)

ifdef BOWERBIRD_TEST_VARIABLE
    $(error ERROR: Unable to run test with: BOWERBIRD_TEST_VARIABLE is not an undefined variable.)
endif


.PHONY: mock-runner-action-run-test-targets-test/force
.mock-runner-action-run-test-targets-test/force:
	@:
