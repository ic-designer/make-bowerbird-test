# Unit tests for bowerbird-test suite constants
# Tests the constants defined in bowerbird-suite.mk (lines 113-130)

test-suite-constants-config-file-patterns-default:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.config.file-patterns),test*.mk)

test-suite-constants-config-target-patterns-default:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.config.target-patterns),test*)

test-suite-constants-ext-end:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.ext-end),end)

test-suite-constants-ext-fail:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.ext-fail),fail)

test-suite-constants-ext-log:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.ext-log),log)

test-suite-constants-ext-pass:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.ext-pass),pass)

test-suite-constants-ext-start:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.ext-start),start)

test-suite-constants-ext-time:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.ext-time),time)

test-suite-constants-fail-exit-code:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.fail-exit-code),1)

test-suite-constants-generated-dir:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.generated-dir),$(WORKDIR_TEST)/.generated)

test-suite-constants-process-tag:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.process-tag),__BOWERBIRD_TEST_PROCESS_TAG__=$(shell echo $$PPID))

test-suite-constants-subdir-cache:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.subdir-cache),.bowerbird)

test-suite-constants-undefined-variable-warning:
	$(call bowerbird::test::compare-strings,$(subst warning,WARN,$(bowerbird-test.constant.undefined-variable-warning)),WARN: undefined variable)

test-suite-constants-workdir-logs:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.workdir-logs),$(WORKDIR_TEST)/.bowerbird)

test-suite-constants-workdir-results:
	$(call bowerbird::test::compare-strings,$(bowerbird-test.constant.workdir-results),$(WORKDIR_TEST)/.bowerbird)
