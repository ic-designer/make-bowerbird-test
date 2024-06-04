test-compare-string-equal:
	$(call bowerbird::test::compare-string,alpha,alpha)

test-compare-string-not-equal:
	! $(call bowerbird::test::compare-string,alpha,beta)

test-compare-string-not-equal-leading-whitespace:
	! $(call bowerbird::test::compare-string,alpha, alpha)

test-compare-string-not-equal-trailing-whitespace:
	! $(call bowerbird::test::compare-string,alpha,alpha )

test-compare-string-not-equal-first-empty:
	! $(call bowerbird::test::compare-string,,beta)

test-compare-string-not-equal-second-empty:
	! $(call bowerbird::test::compare-string,alpha,)

test-compare-string-not-equal-both-empty:
	$(call bowerbird::test::compare-string,,)
