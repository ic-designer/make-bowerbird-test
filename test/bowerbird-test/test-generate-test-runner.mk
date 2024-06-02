
# Process the mock tests
$(eval $(call bowerbird::generate-test-runner,mock-tests,test/mock-tests,mock-test*.mk))

# Targets
test-generate-test-runner-mock-test-files:
	$(call bowerbird::test::compare-sets,$(BOWERBIRD_TEST_FILES/mock-tests),$(abspath test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk) $(abspath test/mock-tests/alpha/beta/mock-test-beta.mk) $(abspath test/mock-tests/alpha/mock-test-alpha.mk))

test-generate-test-runner-mock-test-targets:
	$(call bowerbird::test::compare-sets,$(sort $(BOWERBIRD_TEST_TARGETS/mock-tests)),$(sort test-find-files-gamma-1 test-find-files-gamma-2 test-find-files-beta-1 test-find-files-beta-2 test-find-files-alpha-1 test-find-files-alpha-2))

test-generate-test-runner-mock-test-include: $(BOWERBIRD_TEST_TARGETS/mock-tests)

test-generate-test-runner-mock-test-runner:
	$(MAKE) bowerbird-test/run-tests/mock-tests
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
