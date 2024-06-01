# Recipes
define bowerbird::test::string_compare # lhs, rhs
    test "$1" = "$2" || (echo "ERROR: Failed comparison: '$1' != '$2'" >&2 && exit 1)
endef
