def test_to_r(numerator_range, denominator_range)
  test_count = 0
  inaccuracy_count = 0

  numerator_range.each do |numerator|
    denominator_range.each do |denominator|
      test_count += 1

      original = "#{numerator}/#{denominator}"
      f = numerator.to_f / denominator.to_f
      r = f.to_r

      if r.numerator <= numerator
        accuracy = ''
      else
        inaccuracy_count += 1
        accuracy = ' inaccurate'
      end

      puts "#{original} -> #{f} -> #{r}#{accuracy}"
    end
  end

  inaccuracy_percent = (inaccuracy_count.to_f / test_count.to_f * 100.0).round(2)

  puts
  puts "inaccuracy count: #{inaccuracy_count} / #{test_count} (#{inaccuracy_percent}%)"
end

puts "approximation test"
puts
puts "using standard to_r method"
test_to_r 1..10, 1..10

# load custom to_r method
require_relative 'approx.rb'

puts
puts "loading custum to_r method"
test_to_r 1..10, 1..10