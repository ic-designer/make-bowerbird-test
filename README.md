# Bowerbird Test Tools

[![Makefile CI](https://github.com/asikros/make-bowerbird-test/actions/workflows/makefile.yml/badge.svg)](https://github.com/asikros/make-bowerbird-test/actions/workflows/makefile.yml)


## Installation

The Bowerbird Test Tools can be loaded using the Bowerbird Dependency Tools as shown
below. Please refer the [Bowerbird Depend Tools](https://github.com/asikros/make-bowerbird-deps.git)
for more information about the `bowerbird::git-dependency` macro.

```makefile
$(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-test,\
		https://github.com/asikros/make-bowerbird-test.git,main,bowerbird.mk)
```

## Macros

### `bowerbird::test::suite`

Creates a test suite target that automatically discovers and executes test targets.

```makefile
$(call bowerbird::test::suite,<target>,<paths>,<file-patterns>,<target-patterns>)
```

**Parameters:**
- `target` (required) - Name of the test suite target to create
- `paths` (required) - Space-separated list of directories to search for test files
- `file-patterns` (optional) - Wildcard pattern for test file discovery (default: `test*.mk`)
- `target-patterns` (optional) - Wildcard pattern for test target discovery (default: `test*`)

**Features:**
- Fail-fast mode: Kill all tests on first failure with `--bowerbird-fail-fast`
- Fail-first mode: Run previously failed tests first with `--bowerbird-fail-first`
- Runtime timing: Automatic timing for all tests and test suites
- Slow test reporting: Display 3 slowest tests with `--bowerbird-report-slow-tests`
- Per-test isolation via recursive Make
- Undefined variable detection per test
- Colored output and detailed reporting

**Example:**

```makefile
# Basic usage with defaults (test*.mk files, test* targets)
ifdef bowerbird::test::suite
$(call bowerbird::test::suite,private_test,test/bowerbird-test)
endif

# With custom patterns
ifdef bowerbird::test::suite
$(call bowerbird::test::suite,private_test,test/bowerbird-test,test*.mk,test*)
endif

# Run tests
make private_test

# Run with fail-fast
make private_test -- --bowerbird-fail-fast

# Run with fail-first (previously failed tests run first)
make private_test -- --bowerbird-fail-first

# Run with slow test reporting
make private_test -- --bowerbird-report-slow-tests
```

**Runtime Timing:**

All tests and test suites automatically capture timing information displayed in the output:

```
Passed: (0.125s) test-compare-strings
Passed: (0.234s) test-compare-sets
Failed: (1.456s) test-mock-output

Passed: private_test: 45/46 passed in 8.345s (wall) / 15.234s (cumulative)
```

- **Individual test times**: Displayed in parentheses after each test result (millisecond precision)
- **Wall time**: Actual elapsed time from suite start to finish (accounts for parallel execution)
- **Cumulative time**: Sum of all individual test times (shows total CPU time)

The timing files are stored in `.make/test/<suite-name>/.bowerbird/` and include:
- `.start` - Test start timestamp (milliseconds since epoch)
- `.end` - Test end timestamp (milliseconds since epoch)
- `.time` - Test duration (formatted as `X.XXXs`)
- `.suite.start` - Suite start timestamp
- `.suite.wall.time` - Suite wall clock duration
- `.suite.cumulative.time` - Suite cumulative duration

Use `--bowerbird-report-slow-tests` to display the 3 slowest tests after suite completion.

### `bowerbird::test::compare-files`

Recipe for comparing files. If the two files are different, the command prints an error
message to `stderr` and terminates with exit code 1. If the files are the same, the
command exits with exit code 0.

```
bowerbird::test::compare-files,<file1>,<file2>

  Compares the content of the two files.

  Args:
      file1: First file to be compared.
      file2: Second file to be compared.

  Errors:
      Terminates with exit 1 if the files are different.

  Example:
      $(call bowerbird::test::compare-files,./file1,./file2)
```

### `bowerbird::test::compare-sets`

Recipe for comparing unordered list. If the two lists have different elements, the
command prints an error message to `stderr` and terminates with exit code 1. If the
unordered lists contain the same elements, the command exits with exit code 0. The
recipe does not consider duplicate entries.

```
bowerbird::test::compare-sets,<set1>,<set2>

  Compares two unordered list of values. Duplicate elements in the list are not
  considered.

  Args:
      set1: First set to be compared.
      set2: Second set to be compared.

  Errors:
      Terminates with exit 1 if the lists contain different elements.

  Example:
      $(call bowerbird::test::compare-sets,equal-1 equal-2,equal-2 equal-1)
```

### `bowerbird::test::compare-strings`

Recipe for comparing strings. If the two strings are new equal, the command prints
an error message to `stderr` and terminates with exit code 1. If the strings are equal,
the command exits with exit code 0.


```
bowerbird::test::compare-strings,<str1>,<str2>

  Compares two string values.

  Args:
      str1: First string to be compared.
      str2: Second string to be compared.

  Errors:
      Terminates with exit 1 if string unequal are not equal.

  Example:
      $(call bowerbird::test::compare-strings,equal,equal)
      ! $(call bowerbird::test::compare-strings,not-equal,not equal)
```
