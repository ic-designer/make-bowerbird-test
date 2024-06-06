# Bowerbird Test Tools

[![Makefile CI](https://github.com/ic-designer/make-bowerbird-test/actions/workflows/makefile.yml/badge.svg)](https://github.com/ic-designer/make-bowerbird-test/actions/workflows/makefile.yml)


## Installation

The Bowerbird Test Tools can be loaded using the Bowerbird Dependency Tools as shown
below. Please refer the [Bowerbird Depend Tools](https://github.com/ic-designer/make-bowerbird-deps.git)
for more information about the `bowerbird::git-dependency` macro.

```makefile
$(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-test,\
		https://github.com/ic-designer/make-bowerbird-test.git,main,bowerbird.mk))
```

## Macros

### `bowerbird::generate-test-runner`

```
bowerbird::generate-test-runner,<target>,<path>,<file-pattern>

  Creates a target for running all the test targets found in files matching the
	specified file pattern under the tree starting with the specified path.

  Args:
      target: Name of the test-runner target to create.
      path: Starting directory name for the search.
      pattern: Regular expression for matching filenames.

  Example:
      $(call bowerbird::generate-test-runner,test-target,test/,test*.mk)
		make test-target
```


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
