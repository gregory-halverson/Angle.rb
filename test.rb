require_relative 'angle.rb'

(0...360).step(5).each do |degree|
  theta = degrees(degree)
  puts "angle: #{theta} sin: #{theta.sin} cos: #{theta.cos} tan: #{theta.cos}"
end