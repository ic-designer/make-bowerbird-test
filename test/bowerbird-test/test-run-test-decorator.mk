test-run-test-decorator-failing-test:
	! $(MAKE) @bowerbird-test/run-test/bowerbird-test/failing-test
	test -f $(WORKDIR_TEST)/bowerbird-test/failing-test/failing-test.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/bowerbird-test/failing-test/failing-test.$(BOWERBIRD_TEST_STDERR_EXT)

.PHONY: bowerbird-test/failing-test
bowerbird-test/failing-test:
	exit 1


test-run-test-decorator-passing-test:
	$(MAKE) @bowerbird-test/run-test/bowerbird-test/passing-test
	test -f $(WORKDIR_TEST)/bowerbird-test/passing-test/passing-test.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/bowerbird-test/passing-test/passing-test.$(BOWERBIRD_TEST_STDERR_EXT)

.PHONY: bowerbird-test/passing-test
bowerbird-test/passing-test:
	exit 0


test-run-test-decorator-hierarchical-name:
	$(MAKE) @bowerbird-test/run-test/bowerbird-test/alpha/beta/gamma/hierarchical-name
	test -f $(WORKDIR_TEST)/bowerbird-test/alpha/beta/gamma/hierarchical-name/hierarchical-name.$(BOWERBIRD_TEST_STDOUT_EXT)
	test -f $(WORKDIR_TEST)/bowerbird-test/alpha/beta/gamma/hierarchical-name/hierarchical-name.$(BOWERBIRD_TEST_STDERR_EXT)

.PHONY: bowerbird-test/alpha/beta/gamma/hierarchical-name
bowerbird-test/alpha/beta/gamma/hierarchical-name:
	exit 0
