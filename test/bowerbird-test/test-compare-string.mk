# Targets
.PHONY: test-compare-string-equal
test-compare-string-equal:
	$(call bowerbird::test::compare-string,alpha,alpha)

.PHONY: test-compare-string-not-equal
test-compare-string-not-equal:
	! $(call bowerbird::test::compare-string,alpha,beta)

.PHONY: test-compare-string-not-equal-first-empty
test-compare-string-not-equal-first-empty:
	! $(call bowerbird::test::compare-string,,beta)

.PHONY: test-compare-string-not-equal-second-empty
test-compare-string-not-equal-second-empty:
	! $(call bowerbird::test::compare-string,alpha,)

.PHONY: test-compare-string-not-equal-both-empty
test-compare-string-not-equal-both-empty:
	$(call bowerbird::test::compare-string,,)
