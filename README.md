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

### `bowerbird::test::generate-runner`

```
bowerbird::test::generate-runner,<target>,<path>

    Creates a target for running all the test targets discovered in the specified test
    file path.

    Args:
        target: Name of the test-runner target to create.
        path: Starting directory name for the search.

    Configuration:
        pattern-test-files: Wildcard filename pattern used during test discovery.
		    Refer to bowerbird::test::pattern-test-files for more information about
    		changing this value. Defaults to 'test*.mk'.
        pattern-test-targets: Wildcard target pattern used during test discovery.
		    Refer to bowerbird::test::pattern-test-targets for more information about
    		changing this value. Defaults to 'test*'.

    Error:
        Throws an error if target empty.
	    Throws an error if path empty.

    Example:
        $(call bowerbird::test::generate-runner,test-target,test-dir)
 		    make test-target
```

### `bowerbird::test::pattern-test-files`

```
bowerbird::test::pattern-test-files,<patterns>

    Updates the filename pattern for test discovery used only by the next invocation of
    bowerbird::test::generate-runner. The call to bowerbird::test::generate-runner will
    revert the filename pattern back to the default value such that subsequent calls to
    bowerbird::test::generate-runner will use the default filename pattern.

    Args:
        pattern: Wildcard filename pattern.

    Example:
        $(call bowerbird::test::pattern-test-files,test*.mk)
        $(call bowerbird::test::pattern-test-files,*test.*)
```

### `bowerbird::test::pattern-test-targets`

```
bowerbird::test::pattern-test-targets,<patterns>

    Updates the target pattern for test discovery used only by the next invocation of
    bowerbird::test::generate-runner. The call to bowerbird::test::generate-runner will
    revert the target pattern back to the default value such that subsequent calls to
    bowerbird::test::generate-runner will use the default target patten.

    Args:
        pattern: Wildcard target pattern.

    Example:
        $(call bowerbird::test::pattern-test-targets,test*)
        $(call bowerbird::test::pattern-test-targets,*_check)
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
