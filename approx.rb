module Math
  DEFAULT_MAXDEN = 1000000

  def self.approx(val, maxden=DEFAULT_MAXDEN)
    sign = 1
    m11 = 1
    m22 = 1
    m12 = 0
    m21 = 0

    if val < 0.0
      sign = -1
      val *= -1.0
    end

    x = val
    count = 0

    # loop finding terms until denominator is too big
    ai = x.floor

    # loop until denominator is too big
    while m21 * ai + m22 <= maxden
      # count iterations
      count += 1

      # limit iterations
      break if count > 50000000

      t = m11 * ai + m12
      m12 = m11
      m11 = t
      t = m21 * ai + m22
      m22 = m21
      m21 = t

      break if x == ai

      x = 1 / (x - ai.to_f)

      break if x > 0x7FFFFFFF

      ai = x.floor
    end

    numerator = m11 * sign
    denominator = m21
    imprecision = val - m11.to_f / m21.to_f

    return numerator, denominator, imprecision
  end

  # convert float to whole and fractional part
  def self.modf(number)
    number.divmod 1
  end
end

class Float
  def modf
    self.divmod 1
  end

  def to_r
    Rational(*Math.approx(self)[0, 2])
  end
end