WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
BOWERBIRD_TEST/CONSTANT/LOG_EXT = log
BOWERBIRD_TEST/PATTERN/FILE/DEFAULT = test*.mk
BOWERBIRD_TEST/PATTERN/FILE/USER_DEFINED = $(BOWERBIRD_TEST/PATTERN/FILE/DEFAULT)
BOWERBIRD_TEST/PATTERN/TARGET/DEFAULT = test*
BOWERBIRD_TEST/PATTERN/TARGET/USER_DEFINED = $(BOWERBIRD_TEST/PATTERN/TARGET/DEFAULT)

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
$(shell sed -n 's/\(^$(subst *,[^:]*,$(BOWERBIRD_TEST/PATTERN/TARGET/USER_DEFINED))\):.*/\1/p' $1)
endef


# bowerbird::test::pattern-test-files,<patterns>
#
#   Updates the filename pattern for test discovery used only by the next invocation of
#   bowerbird::generate-test-runner. The call to bowerbird::generate-test-runner will
#	revert the filename pattern back to the default value such that subsequent calls to
#	bowerbird::generate-test-runner will use the default filename patter.
#
#   Args:
#       pattern: Wildcard filename pattern.
#
#   Example:
#       $(call bowerbird::test::pattern-test-files,test*.mk)
#       $(call bowerbird::test::pattern-test-files,*test.*)
#
define bowerbird::test::pattern-test-files
$(eval BOWERBIRD_TEST/PATTERN/FILE/USER_DEFINED := $1)
endef


# bowerbird::test::pattern-test-targets,<patterns>
#
#   Updates the target pattern for test discovery used only by the next invocation of
#   bowerbird::generate-test-runner. The call to bowerbird::generate-test-runner will
#	revert the target pattern back to the default value such that subsequent calls to
#	bowerbird::generate-test-runner will use the default target patten.
#
#   Args:
#       pattern: Wildcard target pattern.
#
#   Example:
#       $(call bowerbird::test::pattern-test-targets,test*)
#       $(call bowerbird::test::pattern-test-targets,*_check)
#
define bowerbird::test::pattern-test-targets
$(eval BOWERBIRD_TEST/PATTERN/TARGET/USER_DEFINED := $1)
endef


# bowerbird::generate-test-runner,<target>,<path>
#
#   Creates a target for running all the test targets discovered in the specified test
#	file path.
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
    BOWERBIRD_TEST_FILES/$1 := $$(call bowerbird::test::find-test-files,$2,$$(BOWERBIRD_TEST/PATTERN/FILE/USER_DEFINED))
    $$(if $$(BOWERBIRD_TEST_FILES/$1),,$$(warning WARNING: No test files found in '$2' matching '$$(BOWERBIRD_TEST/PATTERN/FILE/USER_DEFINED)'))
    ifneq (,$$(BOWERBIRD_TEST_FILES/$1))
        BOWERBIRD_TEST_TARGETS/$1 := $$(call bowerbird::test::find-test-targets,$$(BOWERBIRD_TEST_FILES/$1),$$(BOWERBIRD_TEST/PATTERN/TARGET/USER_DEFINED))
        ifeq ($$(filter $$(MAKEFILE_LIST),$$(BOWERBIRD_TEST_FILES/$1)),)
            -include $$(BOWERBIRD_TEST_FILES/$1)
        endif
    else
        BOWERBIRD_TEST_TARGETS/$1 =
    endif

    .PHONY: bowerbird-test/runner/list-tests/$1 $$(BOWERBIRD_TEST_TARGETS/$1)
    bowerbird-test/runner/list-tests/$1:
		@echo "Discovered tests"; $$(foreach t,$$(sort $$(BOWERBIRD_TEST_TARGETS/$1)),echo "    $$t";)

    .PHONY: bowerbird-test/runner/run-tests/$1
    bowerbird-test/runner/run-tests/$1: $$(foreach target,$$(BOWERBIRD_TEST_TARGETS/$1),@bowerbird-test/run-test/$$(target))

    .PHONY: $1
    $1:
		@$(MAKE) bowerbird-test/runner/list-tests/$1
		@$(MAKE) bowerbird-test/runner/run-tests/$1
		@printf "\e[1;32mAll Test Passed\e[0m\n"

    BOWERBIRD_TEST/PATTERN/FILE/USER_DEFINED := $$(BOWERBIRD_TEST/PATTERN/FILE/DEFAULT)
    BOWERBIRD_TEST/PATTERN/TARGET/USER_DEFINED := $$(BOWERBIRD_TEST/PATTERN/TARGET/DEFAULT)
endef

# Decorator Targets
__UNDEFINED_VARIABLE_WARNING_STRING:=warning: undefined variable

@bowerbird-test/run-test/%: bowerbird-test/force
	@mkdir -p $(WORKDIR_TEST)/$*
	@($(MAKE) $* --debug=v --warn-undefined-variables SHELL='sh -xvp' \
			>$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST/CONSTANT/LOG_EXT) 2>&1 && \
			(! (grep -v "grep.*$(__UNDEFINED_VARIABLE_WARNING_STRING)" \
					$(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST/CONSTANT/LOG_EXT) | \
					grep --color=always "^.*$(__UNDEFINED_VARIABLE_WARNING_STRING).*$$" \
					>> $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST/CONSTANT/LOG_EXT)) || exit 1) && \
			printf "\e[1;32mPassed\e[0m: $*\n") || \
		(printf "\e[1;31mFailed\e[0m: $*\n" && \
			echo && cat $(WORKDIR_TEST)/$*/$(notdir $*).$(BOWERBIRD_TEST/CONSTANT/LOG_EXT) >&2 && \
			echo && printf "\e[1;31mFailed\e[0m: $*\n" >&2 && exit 1)

.PHONY: bowerbird-test/force
bowerbird-test/force:
	@:
#
