define bowerbird::test::mock-test-files
$(call bowerbird::test::find-test-files,test/mock-tests,mock-test*.mk)
endef

test-find-test-files-mock-path-num-files:
	$(call bowerbird::test::compare-strings,3,$(words $(bowerbird::test::mock-test-files)))

test-find-test-files-mock-path-alpha:
	$(call bowerbird::test::compare-sets,$(filter %alpha.mk,$(bowerbird::test::mock-test-files)),$(abspath test/mock-tests/alpha/mock-test-alpha.mk))

test-find-test-files-mock-path-beta:
	$(call bowerbird::test::compare-sets,$(filter %beta.mk,$(bowerbird::test::mock-test-files)),$(abspath test/mock-tests/alpha/beta/mock-test-beta.mk))

test-find-test-files-mock-path-gamma:
	$(call bowerbird::test::compare-sets,$(filter %gamma.mk,$(bowerbird::test::mock-test-files)),$(abspath test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk))
