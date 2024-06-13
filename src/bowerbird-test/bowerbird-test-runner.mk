WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
BOWERBIRD_TEST_EXT_LOG = log
BOWERBIRD_TEST/PATTERN/FILE = test*.mk
BOWERBIRD_TEST/PATTERN/TARGET = test*

# bowerbird::test::find-test-files,<path>,<pattern>
#
#   Returns a list of all the files matching the specified pattern under the directory
#	tree starting with the specified path.
#
#   Args:
#       path: Starting directory name for the search.
#       pattern: Wildcard expression for matching filenames.
#
#   Example:
#       $(call bowerbird::test::find-test-files,test/,test*.*)
#
define bowerbird::test::find-test-files
$(shell find $(abspath $1) -type f -name '$2')
endef

# bowerbird::test::find-test-targets,<files>,<pattern>
#
#   Returns a list of make targets starting with prefix 'test' found in the specified
#	list of files.
#
#   Args:
#       files: List of files to search for make targets.
#       pattern: Wildcard expression for matching filenames.
#
#   Example:
#       $(call bowerbird::test::find-test-targets,test-file-1.mk test-files-2.mk)
#
define bowerbird::test::find-test-targets
$(shell sed -n 's/\(^$(subst *,[^:]*,$(BOWERBIRD_TEST/PATTERN/TARGET))\):.*/\1/p' $1)
endef

# $(shell sed -n 's/\(^test[^:]*\):.*/\1/p' $1)



# bowerbird::test::pattern-test-files,<patterns>
#
#   Changes the filename pattern used by bowerbird::test::find-test-files during test
#	file discovery.
#
#   Args:
#       pattern: Wildcard filename pattern.
#
#   Example:
#       $(call bowerbird::test::pattern-test-files,test*.mk)
#       $(call bowerbird::test::pattern-test-files,*test.*)
#
define bowerbird::test::pattern-test-files
$(eval BOWERBIRD_TEST/PATTERN/FILE = $1)
endef

# bowerbird::test::pattern-test-targets,<patterns>
#
#   Changes the target pattern used by bowerbird::test::find-test-targets during test
#	target discovery.
#
#   Args:
#       pattern: Wildcard target pattern.
#
#   Example:
#       $(call bowerbird::test::pattern-test-targets,test*)
#       $(call bowerbird::test::pattern-test-targets,*_check)
#
define bowerbird::test::pattern-test-targets
$(eval BOWERBIRD_TEST/PATTERN/TARGET= $1)
endef

# bowerbird::generate-test-runner,<target>,<path>
#
#   Creates a target for running all the test targets discovered in the specified test
#	file path. The test
#
#   Args:
#       target: Name of the test-runner target to create.
#       path: Starting directory name for the search.
#       pattern: Regular expression for matching filenames.
#
#   Configuration:
#       pattern-test-files: Wildcard filename pattern used during test discovery.
#			Refer to bowerbird::test::pattern-test-files for more information about
#			changing this value. Defaults to 'test*.mk'.
#       pattern-test-targets: Wildcard target pattern used during test discovery.
#			Refer to bowerbird::test::pattern-test-targets for more information about
#			changing this value. Defaults to 'test*'.
#
#   Example:
#       $(call bowerbird::generate-test-runner,test-target,test-dir)
# 		make test-target
#
define bowerbird::generate-test-runner # target, path
$(eval $(call bowerbird::generate-test-runner-implementation,$1,$2))
endef

# bowerbird::generate-test-runner-implementation,<target>,<path>
#
#   Impplementation for creating a target for running all the test targets discovered
#   in the specified test file path. The test
#
#   Args:
#       target: Name of the test-runner target to create.
#       path: Starting directory name for the search.
#       pattern: Regular expression for matching filenames.
#
#   Configuration:
#       pattern-test-files: Wildcard filename pattern used during test discovery.
#			Refer to bowerbird::test::pattern-test-files for more information about
#			changing this value. Defaults to 'test*.mk'.
#       pattern-test-targets: Wildcard target pattern used during test discovery.
#			Refer to bowerbird::test::pattern-test-targets for more information about
#			changing this value. Defaults to 'test*'.
#
#   Example:
#       $(call bowerbird::generate-test-runner,test-target,test-dir)
# 		make test-target
#
define bowerbird::generate-test-runner-implementation # target, path

    BOWERBIRD_TEST_FILES/$1 := $$(call bowerbird::test::find-test-files,$2,$$(BOWERBIRD_TEST/PATTERN/FILE))
    $$(if $$(BOWERBIRD_TEST_FILES/$1),,$$(warning WARNING: No test files found in '$2' matching '$$(BOWERBIRD_TEST/PATTERN/FILE)'))
    ifneq (,$$(BOWERBIRD_TEST_FILES/$1))
        BOWERBIRD_TEST_TARGETS/$1 := $$(call bowerbird::test::find-test-targets,$$(BOWERBIRD_TEST_FILES/$1),$$(BOWERBIRD_TEST/PATTERN/TARGET))
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
			>$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_EXT_LOG) 2>&1 && \
			(! (grep -v "grep.*$(__UNDEFINED_VARIABLE_WARNING_STRING)" \
					$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_EXT_LOG) | \
					grep --color=always "^.*$(__UNDEFINED_VARIABLE_WARNING_STRING).*$$" \
					>> $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_EXT_LOG)) || exit 1) && \
			printf "\e[1;32mPassed\e[0m: $*\n") || \
		(printf "\e[1;31mFailed\e[0m: $*\n" && \
			echo && cat $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST_EXT_LOG) >&2 && \
			echo && printf "\e[1;31mFailed\e[0m: $*\n" >&2 && exit 1)

.PHONY: bowerbird-test/force
bowerbird-test/force:
	@:
