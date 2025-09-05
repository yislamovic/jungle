# Set the default currency for the Money gem to avoid deprecation warnings
Money.default_currency = :usd
Money.rounding_mode = BigDecimal::ROUND_HALF_UP