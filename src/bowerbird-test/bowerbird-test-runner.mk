# Constants
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
BOWERBIRD_TEST_STDERR_EXT = stderr.txt
BOWERBIRD_TEST_STDOUT_EXT = stdout.txt

# Recipes
define bowerbird::test::find-test-files # path, pattern
$(shell find $(abspath $1) -type f -name '$2')
endef

define bowerbird::test::find-test-targets # list of test files
$(shell sed -n 's/\(^test[^:]*\):.*/\1/p' $1)
endef

define bowerbird::generate-test-runner # target, path, file-pattern
    BOWERBIRD_TEST_FILES/$1 := $$(call bowerbird::test::find-test-files,$2,$3)
    $$(if $$(BOWERBIRD_TEST_FILES/$1),,$$(warning WARNING: No test files found in '$2' matching '$3'))
    ifneq (,$$(BOWERBIRD_TEST_FILES/$1))
        BOWERBIRD_TEST_TARGETS/$1 := $$(call bowerbird::test::find-test-targets,$$(BOWERBIRD_TEST_FILES/$1))
        -include $$(BOWERBIRD_TEST_FILES/$1)
    endif

    .PHONY: $$(BOWERBIRD_TEST_TARGETS/$1)

    .PHONY: bowerbird-test/list-tests/$1
    bowerbird-test/list-tests/$1:
		@echo "Discovered tests"; $$(foreach t,$$(sort $$(BOWERBIRD_TEST_TARGETS/$1)),echo "    $$t";)

    .PHONY: $1
    $1: bowerbird-test/list-tests/$1 $$(foreach target,$$(BOWERBIRD_TEST_TARGETS/$1),@bowerbird-test/run-test/$$(target))
		@printf "\e[1;32mAll Test Passed\e[0m\n"
endef

# Decorator Targets
__UNDEFINED_VARIABLE_WARNING_STRING:=warning: undefined variable

@bowerbird-test/run-test/%: bowerbird-test/force
	@mkdir -p $(WORKDIR_TEST)/$*
	@($(MAKE) $* --debug=v --warn-undefined-variables SHELL='sh -xvp' \
			1>$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_STDOUT_EXT) \
			2>$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_STDERR_EXT) && \
			(! (grep -v "grep.*$(__UNDEFINED_VARIABLE_WARNING_STRING)" \
					$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_STDERR_EXT) | \
					grep --color=always "^.*$(__UNDEFINED_VARIABLE_WARNING_STRING).*$$" \
					>> $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_STDERR_EXT)) || exit 1) && \
			printf "\e[1;32mPassed\e[0m: $*\n") || \
		(printf "\e[1;31mFailed\e[0m: $*\n" && \
			echo && cat $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_STDOUT_EXT) >&2 && \
			echo && cat $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_STDERR_EXT) >&2 && \
			echo && printf "\e[1;31mFailed\e[0m: $*\n" >&2 && exit 1)

.PHONY: bowerbird-test/force
bowerbird-test/force:
	@:
