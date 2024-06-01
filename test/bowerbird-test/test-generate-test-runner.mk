
# Process the mock tests
$(eval $(call bowerbird::generate-test-runner,test/mock-tests,mock-test*.mk))

# Targets
.PHONY: test-generate-test-runner-mock-test-files
test-generate-test-runner-mock-test-files:
	$(call bowerbird::test::string_compare,$(BOWERBIRD_TEST_FILES),/Users/jfreden/wa/repos/make-bowerbird-test/test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk /Users/jfreden/wa/repos/make-bowerbird-test/test/mock-tests/alpha/beta/mock-test-beta.mk /Users/jfreden/wa/repos/make-bowerbird-test/test/mock-tests/alpha/mock-test-alpha.mk)

.PHONY: test-generate-test-runner-mock-test-targets
test-generate-test-runner-mock-test-targets:
	$(call bowerbird::test::string_compare,$(sort $(BOWERBIRD_TEST_TARGETS)),$(sort test-find-files-gamma-1 test-find-files-gamma-2 test-find-files-beta-1 test-find-files-beta-2 test-find-files-alpha-1 test-find-files-alpha-2))

.PHONY: test-generate-test-runner-mock-test-include
test-generate-test-runner-mock-test-include: $(BOWERBIRD_TEST_TARGETS)

.PHONY: test-generate-test-runner-mock-test-runner
test-generate-test-runner-mock-test-runner:
	$(MAKE) bowerbird-test/run-tests
	test -f $(WORKDIR_TEST)/test-find-files-alpha-1/test-find-files-alpha-1.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-alpha-1/test-find-files-alpha-1.$(BOWERBIRD_TEST_STDERR_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-alpha-2/test-find-files-alpha-2.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-alpha-2/test-find-files-alpha-2.$(BOWERBIRD_TEST_STDERR_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-beta-1/test-find-files-beta-1.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-beta-1/test-find-files-beta-1.$(BOWERBIRD_TEST_STDERR_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-beta-2/test-find-files-beta-2.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-beta-2/test-find-files-beta-2.$(BOWERBIRD_TEST_STDERR_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-gamma-1/test-find-files-gamma-1.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-gamma-1/test-find-files-gamma-1.$(BOWERBIRD_TEST_STDERR_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-gamma-2/test-find-files-gamma-2.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/test-find-files-gamma-2/test-find-files-gamma-2.$(BOWERBIRD_TEST_STDERR_EXT)
