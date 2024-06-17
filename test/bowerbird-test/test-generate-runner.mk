# Process the mock tests
$(call bowerbird::test::pattern-test-files,mock-test*.mk)
$(call bowerbird::test::pattern-test-targets,test*)
$(call bowerbird::test::generate-runner,mock-generate-runner,test/mock-tests)

# Targets
test-generate-runner-mock-test-files:
	$(call bowerbird::test::compare-sets,\
			$(BOWERBIRD_TEST/FILES/mock-generate-runner),\
			$(abspath test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk) \
					$(abspath test/mock-tests/alpha/beta/mock-test-beta.mk) \
					$(abspath test/mock-tests/alpha/mock-test-alpha.mk))

test-generate-runner-mock-test-targets:
	$(call bowerbird::test::compare-sets,\
			$(sort $(BOWERBIRD_TEST/TARGETS/mock-generate-runner)),\
			$(sort test-find-files-gamma-1 test-find-files-gamma-2 \
					test-find-files-beta-1 test-find-files-beta-2 \
					test-find-files-alpha-1 test-find-files-alpha-2))

test-generate-runner-mock-test-include: $(BOWERBIRD_TEST/TARGETS/mock-generate-runner)

test-generate-runner-mock-test-runner-logs:
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		test ! -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_LOG) || \
		rm -f  $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_LOG);)
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		! test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_LOG);)
	$(MAKE) mock-generate-runner
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_LOG);)

test-generate-runner-mock-test-runner-results:
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		test ! -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_PASS) || \
		rm -f  $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_PASS);)
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		! test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_PASS);)
	$(MAKE) mock-generate-runner
	$(foreach f,alpha-1 alpha-2 beta-1 beta-2 gamma-1 gamma-2,\
		test -f $(BOWERBIRD_TEST/CONSTANT/WORKDIR_LOGS)/mock-generate-runner/test-find-files-$(f).$(BOWERBIRD_TEST/CONSTANT/EXT_PASS);)
