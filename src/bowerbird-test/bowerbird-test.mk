# Recipes
define bowerbird::test::find-test-files # path, pattern
$(shell find $(abspath $1) -type f -name '$2')
endef

define bowerbird::test::find-test-targets # list of files
$(shell sed -n 's/\(^test.*\):/\1/p' $1)
endef

define bowerbird::test::string_compare # lhs, rhs
    test "$1" = "$2" || (echo "ERROR: Failed comparison: '$1' != '$2'" >&2 && exit 1)
endef
