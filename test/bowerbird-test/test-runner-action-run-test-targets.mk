$(call bowerbird::generate-test-runner,mock-runner,)


test-runner-action-run-test-targets-failing-test-non-zero-exit-status:
	! $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=1

test-runner-action-run-test-targets-failing-test-zero-exit-status:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0

test-runner-action-run-test-targets-failing-test-generate-log-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test -f $(WORKDIR_TEST)/mock-test/$@/failing-test/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-runner-action-run-test-targets-failing-test-generate-failed-response-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)

test-runner-action-run-test-targets-failing-test-do-not-generate-passing-response-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test ! -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)

test-runner-action-run-test-targets-failing-test-response-file-contents:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)
	$(call bowerbird::test::compare-strings,\
			$$(cat $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/failing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)),\
			$(shell printf "\e[1;31mFailed: mock-test/test-runner-action-run-test-targets-failing-test-response-file-contents/failing-test\e[0m"))


test-runner-action-run-test-targets-failing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/failing-test/mock-runner 2>/dev/null),\
			$(shell printf "\e[1;31mFailed: mock-test/test-runner-action-run-test-targets-failing-test-printed-response/failing-test\e[0m"))


test-runner-action-run-test-targets-passing-test-generate-log-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-runner
	test -f $(WORKDIR_TEST)/mock-test/$@/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-runner-action-run-test-targets-passing-test-generate-passing-response-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)

test-runner-action-run-test-targets-passing-test-do-not-generate-failing-response-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0
	test ! -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)

test-runner-action-run-test-targets-passing-test-response-file-contents:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)
	$(call bowerbird::test::compare-strings,\
			$$(cat $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)),\
			$(shell printf "\e[1;32mPassed:\e[0m mock-test/test-runner-action-run-test-targets-passing-test-response-file-contents/passing-test"))

test-runner-action-run-test-targets-passing-test-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/passing-test/mock-runner 2>/dev/null),\
			$(shell printf "\e[1;32mPassed:\e[0m mock-test/test-runner-action-run-test-targets-passing-test-printed-response/passing-test"))


test-runner-action-run-test-targets-undefined-variable-ensure-test-variable-is-undefined:
	! $(MAKE) mock-test/force BOWERBIRD_TEST_VARIABLE=true

test-runner-action-run-test-targets-undefined-variable-non-zero-exit-status:
	! $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=1 2>/dev/null

test-runner-action-run-test-targets-undefined-variable-zero-exit-status:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null

test-runner-action-run-test-targets-undefined-variable-generate-log-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null
	test -f $(WORKDIR_TEST)/mock-test/$@/undefined-variable-test/undefined-variable-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)

test-runner-action-run-test-targets-undefined-variable-test-generate-failed-response-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/undefined-variable-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)

test-runner-action-run-test-targets-undefined-variable-test-do-not-generate-passing-response-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null
	test ! -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/undefined-variable-test.$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)

test-runner-action-run-test-targets-undefined-variable-test-response-file-contents:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner \
			BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE=0 2>/dev/null
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/undefined-variable-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)
	$(call bowerbird::test::compare-strings,\
			$$(cat $(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/mock-runner/mock-test/$@/undefined-variable-test.$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)),\
			$(shell printf "\e[1;31mFailed: mock-test/test-runner-action-run-test-targets-undefined-variable-test-response-file-contents/undefined-variable-test\e[0m"))

test-runner-action-run-test-targets-undefined-variable-printed-response:
	$(call bowerbird::test::compare-strings,\
			$(shell $(MAKE) @bowerbird-test/run-test-target/mock-test/$@/undefined-variable-test/mock-runner 2>/dev/null),\
			$(shell printf "\e[1;31mFailed: mock-test/test-runner-action-run-test-targets-undefined-variable-printed-response/undefined-variable-test\e[0m"))


test-runner-action-run-test-targets-hierarchical-name-generate-log-file:
	$(MAKE) @bowerbird-test/run-test-target/mock-test/$@/alpha/beta/passing-test/mock-runner
	test -f $(WORKDIR_TEST)/mock-test/$@/alpha/beta/passing-test/passing-test.$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)


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
