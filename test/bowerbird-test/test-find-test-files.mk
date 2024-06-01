# Targets
define bowerbird::test::mock-test-files
$(call bowerbird::test::find-test-files,test/mock-tests,mock-test*.mk)
endef

.PHONY: test-find-test-files-mock-path-num-files
test-find-test-files-mock-path-num-files:
	@$(call bowerbird::test::string_compare,3,$(words $(bowerbird::test::mock-test-files)))

.PHONY: test-find-test-files-mock-path-alpha
test-find-test-files-mock-path-alpha:
	@$(call bowerbird::test::string_compare,$(filter %alpha.mk,$(bowerbird::test::mock-test-files)),/Users/jfreden/wa/repos/make-bowerbird-test/test/mock-tests/alpha/mock-test-alpha.mk)

.PHONY: test-find-test-files-mock-path-beta
test-find-test-files-mock-path-beta:
	@$(call bowerbird::test::string_compare,$(filter %beta.mk,$(bowerbird::test::mock-test-files)),/Users/jfreden/wa/repos/make-bowerbird-test/test/mock-tests/alpha/beta/mock-test-beta.mk)

.PHONY: test-find-test-files-mock-path-gamma
test-find-test-files-mock-path-gamma:
	@$(call bowerbird::test::string_compare,$(filter %gamma.mk,$(bowerbird::test::mock-test-files)),/Users/jfreden/wa/repos/make-bowerbird-test/test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk)
