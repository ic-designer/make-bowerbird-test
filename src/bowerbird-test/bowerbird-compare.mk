define bowerbird::test::compare-strings # lhs, rhs
    test "$1" = "$2" || (echo "ERROR: Failed string comparison: '$1' != '$2'" >&2 && exit 1)
endef

define bowerbird::test::compare-sets # lhs, rhs
    test "$(sort $1)" = "$(sort $2)" || (echo "ERROR: Failed list comparison: '$(sort $1)' != '$(sort $2)'" >&2 && exit 1)
endef

define bowerbird::test::compare-files # lhs, rhs
    diff -q $1 $2 || (echo "ERROR: Failed file comparison:" 1>&2 && diff -y $1 $2 1>&2 && exit 1)
endef
