# Process the mock tests
$(call bowerbird::test::pattern-test-files,mock-test*.mk)
$(call bowerbird::test::pattern-test-targets,test*)
$(call bowerbird::test::generate-runner,run-generate-runner-mock-test,test/mock-tests)

# Targets
test-generate-runner-mock-test-files:
	$(call bowerbird::test::compare-sets,\
			$(BOWERBIRD_TEST/FILES/run-generate-runner-mock-test),\
			$(abspath test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk) \
					$(abspath test/mock-tests/alpha/beta/mock-test-beta.mk) \
					$(abspath test/mock-tests/alpha/mock-test-alpha.mk))

test-generate-runner-mock-test-targets:
	$(call bowerbird::test::compare-sets,\
			$(sort $(BOWERBIRD_TEST/TARGETS/run-generate-runner-mock-test)),\
			$(sort test-find-files-gamma-1 test-find-files-gamma-2 \
					test-find-files-beta-1 test-find-files-beta-2 \
					test-find-files-alpha-1 test-find-files-alpha-2))

test-generate-runner-mock-test-include: $(BOWERBIRD_TEST/TARGETS/run-generate-runner-mock-test)

test-generate-runner-mock-test-runner:
	$(MAKE) run-generate-runner-mock-test
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
	test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/run-generate-runner-mock-test/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_LOG);)
