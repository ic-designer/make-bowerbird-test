test-find-test-targets-mock-path-only-alpha-sorted-targets:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/mock-test-alpha.mk),test-find-files-alpha-1 test-find-files-alpha-2)

test-find-test-targets-mock-path-only-alpha-num-targets:
	$(call bowerbird::test::compare-strings,2,$(words $(call bowerbird::test::find-test-targets,test/mock-tests/alpha/mock-test-alpha.mk)))


test-find-test-targets-mock-path-only-beta-sorted-targets:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/beta/mock-test-beta.mk),test-find-files-beta-1 test-find-files-beta-2)

test-find-test-targets-mock-path-only-beta-num-targets:
	$(call bowerbird::test::compare-strings,2,$(words $(call bowerbird::test::find-test-targets,test/mock-tests/alpha/beta/mock-test-beta.mk)))


test-find-test-targets-mock-path-only-gamma-sorted-targets:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk),test-find-files-gamma-1 test-find-files-gamma-2)

test-find-test-targets-mock-path-only-gamma-num-targets:
	$(call bowerbird::test::compare-strings,2,$(words $(call bowerbird::test::find-test-targets,test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk)))


test-find-test-targets-mock-path-all-files-sorted-targets:
	$(call bowerbird::test::compare-sets,$(call bowerbird::test::find-test-targets,\
			test/mock-tests/alpha/mock-test-alpha.mk test/mock-tests/alpha/beta/mock-test-beta.mk \
			test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk),\
			test-find-files-alpha-1 test-find-files-alpha-2 \
			test-find-files-beta-1 test-find-files-beta-2 \
			test-find-files-gamma-1 test-find-files-gamma-2)

test-find-test-targets-mock-path-all-files-num-targets:
	$(call bowerbird::test::compare-strings,6,$(words $(call bowerbird::test::find-test-targets,\
			test/mock-tests/alpha/mock-test-alpha.mk \
			test/mock-tests/alpha/beta/mock-test-beta.mk \
			test/mock-tests/alpha/beta/gamma/mock-test-gamma.mk)))
