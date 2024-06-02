# Targets
.PHONY: test-string-compare-equal
test-string-compare-equal:
	$(call bowerbird::test::string_compare,alpha,alpha)

.PHONY: test-string-compare-not-equal
test-string-compare-not-equal:
	! $(call bowerbird::test::string_compare,alpha,beta)

.PHONY: test-string-compare-not-equal-first-empty
test-string-compare-not-equal-first-empty:
	! $(call bowerbird::test::string_compare,,beta)

.PHONY: test-string-compare-not-equal-second-empty
test-string-compare-not-equal-second-empty:
	! $(call bowerbird::test::string_compare,alpha,)

.PHONY: test-string-compare-not-equal-both-empty
test-string-compare-not-equal-both-empty:
	$(call bowerbird::test::string_compare,,)
