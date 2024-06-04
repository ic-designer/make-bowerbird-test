test-find-test-targets-mock-path-only-alpha:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/mock-test-alpha.mk),test-find-files-alpha-1 test-find-files-alpha-2)

test-find-test-targets-mock-path-only-beta:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/beta/mock-test-beta.mk),test-find-files-beta-1 test-find-files-beta-2)

test-find-test-targets-mock-path-only-gamma:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk),test-find-files-gamma-1 test-find-files-gamma-2)

test-find-test-targets-mock-path-all-files:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/mock-test-alpha.mk test/mock-tests/alpha/beta/mock-test-beta.mk test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk),test-find-files-alpha-1 test-find-files-alpha-2 test-find-files-beta-1 test-find-files-beta-2 test-find-files-gamma-1 test-find-files-gamma-2)
