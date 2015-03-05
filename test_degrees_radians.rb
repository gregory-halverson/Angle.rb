require_relative 'angle.rb'

(0...360).step(5) do |degree|
  d = degrees(degree)
  d_f = d.to_f
  r = d.to_radians
  r_f = r.to_f

  puts "degrees: #{d} (#{d_f}) radians: #{r} (#{r_f})"
end