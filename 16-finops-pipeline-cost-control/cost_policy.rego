package infracost

deny[out] {
	maxTotalMonthlyCost = 450.0

	msg := sprintf(
		"Max total monthly estimated cost must be less than £ %.2f (actual max estimated cost is £ %.2f)",
		[maxTotalMonthlyCost, to_number(input.totalMonthlyCost)],
	)

	out := {
		"msg": msg,
		"failed": to_number(input.totalMonthlyCost) >= maxTotalMonthlyCost,
	}
}