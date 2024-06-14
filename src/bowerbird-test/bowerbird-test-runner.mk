WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE = 0
BOWERBIRD_TEST/CONFIG/FILE_PATTERN_DEFAULT = test*.mk
BOWERBIRD_TEST/CONFIG/FILE_PATTERN_USER = $(BOWERBIRD_TEST/CONFIG/FILE_PATTERN_DEFAULT)
BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_DEFAULT = test*
BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_USER = $(BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_DEFAULT)
BOWERBIRD_TEST/CONSTANT/EXT_FAIL = fail
BOWERBIRD_TEST/CONSTANT/EXT_LOG = log
BOWERBIRD_TEST/CONSTANT/EXT_PASS = pass
BOWERBIRD_TEST/CONSTANT/SUBDIR_RESULTS = .results
BOWERBIRD_TEST/CONSTANT/UNDEFINED_VARIABLE_WARNING = warning: undefined variable
BOWERBIRD_TEST/CONSTANT/WORKDIR_ROOT = $(WORKDIR_TEST)
BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS = $(BOWERBIRD_TEST/CONSTANT/WORKDIR_ROOT)/$(BOWERBIRD_TEST/CONSTANT/SUBDIR_RESULTS)


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
$(shell find $(abspath $1) -type f -name '$2' 2>/dev/null)
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
$(shell sed -n 's/\(^$(subst *,[^:]*,$(BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_USER))\):.*/\1/p' $1  2>/dev/null)
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
$(eval BOWERBIRD_TEST/CONFIG/FILE_PATTERN_USER := $1)
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
$(eval BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_USER := $1)
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
    BOWERBIRD_TEST/FILES/$1 := $$(call bowerbird::test::find-test-files,$2,$$(BOWERBIRD_TEST/CONFIG/FILE_PATTERN_USER))
    $$(if $$(BOWERBIRD_TEST/FILES/$1),,$$(warning WARNING: No test files found in '$2' matching '$$(BOWERBIRD_TEST/CONFIG/FILE_PATTERN_USER)'))
    ifneq (,$$(BOWERBIRD_TEST/FILES/$1))
        BOWERBIRD_TEST/TARGETS/$1 := $$(call bowerbird::test::find-test-targets,$$(BOWERBIRD_TEST/FILES/$1),$$(BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_USER))
        ifeq ($$(filter $$(MAKEFILE_LIST),$$(BOWERBIRD_TEST/FILES/$1)),)
            -include $$(BOWERBIRD_TEST/FILES/$1)
        endif
    else
        BOWERBIRD_TEST/TARGETS/$1 =
    endif

    .PHONY: bowerbird-test/runner/list-tests/$1 $$(BOWERBIRD_TEST/TARGETS/$1)
    bowerbird-test/runner/list-tests/$1:
		@echo "Discovered tests"; $$(foreach t,$$(sort $$(BOWERBIRD_TEST/TARGETS/$1)),echo "    $$t";)

    .PHONY: bowerbird-test/runner/clean-results/$1
    bowerbird-test/runner/clean-results/$1:
		@test -n $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1
		@mkdir -p $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1
		@test -d $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1
		@rm -f $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1/*

    .PHONY: bowerbird-test/runner/run-tests/$1
    bowerbird-test/runner/run-tests/$1: $$(foreach target,$$(BOWERBIRD_TEST/TARGETS/$1),@bowerbird-test/run-test-target/$$(target)/$1)

    .PHONY: bowerbird-test/runner/report-results/$1
    bowerbird-test/runner/report-results/$1:
		@echo "reporting..."
		@$$(eval BOWERBIRD_TEST/RESULTS/NUM_PASS/$1 = $$(shell find \
				$$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1 \
				-type f -name '*.$$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)')) \
		$$(eval BOWERBIRD_TEST/RESULTS/NUM_FAIL/$1 = $$(shell find \
				$$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1 \
				-type f -name '*.$$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)')) \
		test -z "$$(BOWERBIRD_TEST/RESULTS/NUM_PASS/$1)" || cat $$(BOWERBIRD_TEST/RESULTS/NUM_PASS/$1); \
		test -z "$$(BOWERBIRD_TEST/RESULTS/NUM_FAIL/$1)" || cat $$(BOWERBIRD_TEST/RESULTS/NUM_FAIL/$1); \
		test $$(words $$(BOWERBIRD_TEST/RESULTS/NUM_PASS/$1)) -lt $$(words $$(BOWERBIRD_TEST/TARGETS/$1)) || \
				(printf "\e[1;32mPassed: $1: $$(words $$(BOWERBIRD_TEST/RESULTS/NUM_PASS/$1))/$$(words \
						$$(BOWERBIRD_TEST/TARGETS/$1)) passed\e[0m\n\n" && exit 0); \
		test $$(words $$(BOWERBIRD_TEST/RESULTS/NUM_FAIL/$1)) -eq 0 || \
				(printf "\e[1;31mFailed: $1: $$(words $$(BOWERBIRD_TEST/RESULTS/NUM_FAIL/$1))/$$(words \
						$$(BOWERBIRD_TEST/TARGETS/$1)) failed\e[0m\n\n" && exit 1);

    .PHONY: $1
    $1:
		test "$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL)" != "$(BOWERBIRD_TEST/CONSTANT/EXT_PASS)"
		@$(MAKE) bowerbird-test/runner/clean-results/$1
		@$(MAKE) bowerbird-test/runner/list-tests/$1
		@$(MAKE) bowerbird-test/runner/run-tests/$1
		@$(MAKE) bowerbird-test/runner/report-results/$1


    @bowerbird-test/run-test-target/%/$1: bowerbird-test/force
		@mkdir -p $$(WORKDIR_TEST)/$$*
		@mkdir -p $$(dir $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1/$$*)
		@($(MAKE) $$* --debug=v --warn-undefined-variables SHELL='sh -xvp' \
				>$$(WORKDIR_TEST)/$$*/$$(notdir $$*).$$(BOWERBIRD_TEST/CONSTANT/EXT_LOG) 2>&1 && \
				(! (grep -v "grep.*$$(BOWERBIRD_TEST/CONSTANT/UNDEFINED_VARIABLE_WARNING)" \
						$$(WORKDIR_TEST)/$$*/$$(notdir $$*).$$(BOWERBIRD_TEST/CONSTANT/EXT_LOG) | \
						grep --color=always "^.*$$(BOWERBIRD_TEST/CONSTANT/UNDEFINED_VARIABLE_WARNING).*$$$$" \
						>> $$(WORKDIR_TEST)/$$*/$$(notdir $$*).$$(BOWERBIRD_TEST/CONSTANT/EXT_LOG)) || exit 1) && \
				( \
					printf "\e[1;32mPassed:\e[0m $$*\n" && \
					printf "\e[1;32mPassed:\e[0m $$*\n" > $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1/$$*.$$(BOWERBIRD_TEST/CONSTANT/EXT_PASS) \
				)) || \
			(\
				printf "\e[1;31mFailed: $$*\e[0m\n" && \
				printf "\e[1;31mFailed: $$*\e[0m\n" > $$(BOWERBIRD_TEST/CONSTANT/WORKDIR_RESULTS)/$1/$$*.$$(BOWERBIRD_TEST/CONSTANT/EXT_FAIL) && \
					echo && cat $$(WORKDIR_TEST)/$$*/$$(notdir $$*).$$(BOWERBIRD_TEST/CONSTANT/EXT_LOG) >&2 && \
					echo && printf "\e[1;31mFailed: $$*\e[0m\n" >&2 && exit $$(BOWERBIRD_TEST/CONFIG/FAIL_EXIT_CODE) \
			)

    BOWERBIRD_TEST/CONFIG/FILE_PATTERN_USER := $$(BOWERBIRD_TEST/CONFIG/FILE_PATTERN_DEFAULT)
    BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_USER := $$(BOWERBIRD_TEST/CONFIG/TARGET_PATTERN_DEFAULT)
endef


.PHONY: bowerbird-test/force
bowerbird-test/force:
	@:
