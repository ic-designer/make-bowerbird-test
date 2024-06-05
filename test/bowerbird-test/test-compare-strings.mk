test-compare-string-equal:
	$(call bowerbird::test::compare-strings,alpha,alpha)

test-compare-string-not-equal:
	! $(call bowerbird::test::compare-strings,alpha,beta)

test-compare-string-not-equal-leading-whitespace:
	! $(call bowerbird::test::compare-strings,alpha, alpha)

test-compare-string-not-equal-trailing-whitespace:
	! $(call bowerbird::test::compare-strings,alpha,alpha )

test-compare-string-not-equal-first-empty:
	! $(call bowerbird::test::compare-strings,,beta)

test-compare-string-not-equal-second-empty:
	! $(call bowerbird::test::compare-strings,alpha,)

test-compare-string-not-equal-both-empty:
	$(call bowerbird::test::compare-strings,,)
