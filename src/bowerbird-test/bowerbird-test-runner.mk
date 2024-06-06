WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
BOWERBIRD_TEST_STDERR_EXT = stderr.txt
BOWERBIRD_TEST_STDOUT_EXT = stdout.txt


# bowerbird::test::find-test-files,<path>,<pattern>
#
#   Returns a list of all the files matching the specified pattern under the directory
#	tree starting with the specified path.
#
#   Args:
#       path: Starting directory name for the search.
#       pattern: Regular expression for matching filenames.
#
#   Example:
#       $(call bowerbird::test::find-test-files,test/,test*.*)
#
define bowerbird::test::find-test-files
$(shell find $(abspath $1) -type f -name '$2')
endef

# bowerbird::test::find-test-targets,<files>
#
#   Returns a list of make targets starting with prefix 'test' found in the specified
#	list of files.
#
#   Args:
#       files: List of files to search for make targets.
#
#   Example:
#       $(call bowerbird::test::find-test-targets,test-file-1.mk test-files-2.mk)
#
define bowerbird::test::find-test-targets
$(shell sed -n 's/\(^test[^:]*\):.*/\1/p' $1)
endef

# bowerbird::generate-test-runner,<target>,<path>,<file-pattern>

#   Creates a target for running all the test targets found in files matching the
# 	specified file pattern under the tree starting with the specified path.

#   Args:
#       target: Name of the test-runner target to create.
#       path: Starting directory name for the search.
#       pattern: Regular expression for matching filenames.

#   Example:
#       $(call bowerbird::generate-test-runner,test-target,test/,test*.mk)
# 		make test-target

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
