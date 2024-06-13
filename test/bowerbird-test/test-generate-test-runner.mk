# Process the mock tests
$(call bowerbird::test::pattern-test-files,mock-test*.mk)
$(call bowerbird::generate-test-runner,run-generate-test-runner-mock-test,test/mock-tests)

# Targets
test-generate-test-runner-mock-test-files:
	$(call bowerbird::test::compare-sets,\
			$(BOWERBIRD_TEST_FILES/run-generate-test-runner-mock-test),\
			$(abspath test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk) \
					$(abspath test/mock-tests/alpha/beta/mock-test-beta.mk) \
					$(abspath test/mock-tests/alpha/mock-test-alpha.mk))

test-generate-test-runner-mock-test-targets:
	$(call bowerbird::test::compare-sets,\
			$(sort $(BOWERBIRD_TEST_TARGETS/run-generate-test-runner-mock-test)),\
			$(sort test-find-files-gamma-1 test-find-files-gamma-2 \
					test-find-files-beta-1 test-find-files-beta-2 \
					test-find-files-alpha-1 test-find-files-alpha-2))

test-generate-test-runner-mock-test-include: $(BOWERBIRD_TEST_TARGETS/run-generate-test-runner-mock-test)

test-generate-test-runner-mock-test-runner:
	$(MAKE) run-generate-test-runner-mock-test
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		test -f $(WORKDIR_TEST)/test-find-files-$(f)/test-find-files-$(f).$(BOWERBIRD_TEST_EXT_LOG);)
