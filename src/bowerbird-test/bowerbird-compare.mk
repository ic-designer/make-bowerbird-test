define bowerbird::test::compare-string # lhs, rhs
    test "$1" = "$2" || (echo "ERROR: Failed string comparison: '$1' != '$2'" >&2 && exit 1)
endef

define bowerbird::test::compare-sets # lhs, rhs
    test "$(sort $1)" = "$(sort $2)" || (echo "ERROR: Failed list comparison: '$(sort $1)' != '$(sort $2)'" >&2 && exit 1)
endef
