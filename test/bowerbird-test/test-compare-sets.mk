# Targets
.PHONY: test-compare-sets-one-element-equal-same-elements
test-compare-sets-one-element-equal:
	$(call bowerbird::test::compare-sets,alpha,alpha)

.PHONY: test-compare-sets-one-element-equal-leading-whitespace
test-compare-sets-one-element-equal-leading-whitespace:
	$(call bowerbird::test::compare-sets,alpha, alpha)

.PHONY: test-compare-sets-one-element-equal-trailing-whitespace
test-compare-sets-one-element-equal-trailing-whitespace:
	$(call bowerbird::test::compare-sets,alpha,alpha )

.PHONY: test-compare-sets-one-element-not-equal-different-elements
test-compare-sets-one-element-not-equal:
	! $(call bowerbird::test::compare-sets,alpha,beta)

.PHONY: test-compare-sets-one-element-not-equal-first-empty
test-compare-sets-not-equal-first-empty:
	! $(call bowerbird::test::compare-sets,,beta)

.PHONY: test-compare-sets-one-element-not-equal-second-empty
test-compare-sets-not-equal-second-empty:
	! $(call bowerbird::test::compare-sets,alpha,)

.PHONY: test-compare-sets-one-element-not-equal-both-empty
test-compare-sets-not-equal-both-empty:
	$(call bowerbird::test::compare-sets,,)

.PHONY: test-compare-sets-multiple-elements-equal-same-order
test-compare-sets-multiple-elements-equal-same-order:
	$(call bowerbird::test::compare-sets,alpha beta,alpha beta)

.PHONY: test-compare-sets-multiple-elements-equal-different-order
test-compare-sets-multiple-elements-equal-different-order:
	$(call bowerbird::test::compare-sets,alpha beta,beta alpha)

.PHONY: test-compare-sets-multiple-elements-equal-leading-whitespace
test-compare-sets-multiple-elements-equal-leading-whitespace:
	$(call bowerbird::test::compare-sets,alpha beta, alpha beta)

.PHONY: test-compare-sets-multiple-elements-equal-trailing-whitespace
test-compare-sets-multiple-elements-equal-trailing-whitespace:
	$(call bowerbird::test::compare-sets,alpha beta,alpha beta )

.PHONY: test-compare-sets-multiple-element-not-equal-extra-element
test-compare-sets-multiple-element-not-equal-extra-element:
	! $(call bowerbird::test::compare-sets,alpha beta,alpha beta gamma)

.PHONY: test-compare-sets-multiple-element-not-equal-missing-element
test-compare-sets-multiple-element-not-equal-missing-element:
	! $(call bowerbird::test::compare-sets,alpha beta gamma,alpha beta)
