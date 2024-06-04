# Constants
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

# Targets
test-compare-files-equal: \
		$(WORKDIR_TEST)/test-compare-files-equal/test-compare-files-1-alpha \
		$(WORKDIR_TEST)/test-compare-files-equal/test-compare-files-2-alpha
	$(call bowerbird::test::compare-files,\
		$(WORKDIR_TEST)/test-compare-files-equal/test-compare-files-1-alpha,\
		$(WORKDIR_TEST)/test-compare-files-equal/test-compare-files-2-alpha)

test-compare-files-not-equal: \
		$(WORKDIR_TEST)/test-compare-files-not-equal/test-compare-files-1-alpha \
		$(WORKDIR_TEST)/test-compare-files-not-equal/test-compare-files-2-beta
	! $(call bowerbird::test::compare-files,\
		$(WORKDIR_TEST)/test-compare-files-not-equal/test-compare-files-1-alpha,\
		$(WORKDIR_TEST)/test-compare-files-not-equal/test-compare-files-2-beta)


$(WORKDIR_TEST)/test-compare-files%-alpha: $(MAKEFILE_LIST)
	mkdir -p $(dir $@)
	echo 'alpha' > $@

$(WORKDIR_TEST)/test-compare-files%-beta: $(MAKEFILE_LIST)
	mkdir -p $(dir $@)
	echo 'beta' > $@
