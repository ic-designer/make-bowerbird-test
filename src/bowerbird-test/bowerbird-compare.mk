# bowerbird::test::compare-strings,<str1>,<str2>
#
#   Compares two string values.
#
#   Args:
#       str1: First string to be compared.
#       str2: Second string to be compared.
#
#   Errors:
#       Terminates with exit 1 if string unequal are not equal.
#
#   Example:
#       $(call bowerbird::test::compare-strings,equal,equal)
#       ! $(call bowerbird::test::compare-strings,not-equal,not equal)
#
define bowerbird::test::compare-strings
    test "$1" = "$2" || \
            (echo "ERROR: Failed string comparison: '$1' != '$2'" >&2 && exit 1)
endef

# bowerbird::test::compare-sets,<set1>,<set2>
#
#   Compares two unordered list of values. Duplicate elements in the list are not
#   considered.
#
#   Args:
#       set1: First set to be compared.
#       set2: Second set to be compared.
#
#   Errors:
#       Terminates with exit 1 if the lists contain different elements.
#
#   Example:
#       $(call bowerbird::test::compare-sets,equal-1 equal-2,equal-2 equal-1)
#       ! $(call bowerbird::test::compare-sets,not-equal-1,not-equal-1 not-equal-2)
define bowerbird::test::compare-sets
    test "$(sort $1)" = "$(sort $2)" || \
            (echo "ERROR: Failed list comparison: '$(sort $1)' != '$(sort $2)'" >&2 && \
            exit 1)
endef

# bowerbird::test::compare-files,<file1>,<file2>
#
#   Compares the content of the two files.
#
#   Args:
#       file1: First file to be compared.
#       file2: Second file to be compared.
#
#   Errors:
#       Terminates with exit 1 if the files are different.
#
#   Example:
#       $(call bowerbird::test::compare-files,./file1,./file2)
#
define bowerbird::test::compare-files
    diff -q $1 $2 || \
            (echo "ERROR: Failed file comparison:" 1>&2 && diff -y $1 $2 1>&2 && exit 1)
endef
