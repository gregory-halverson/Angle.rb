require_relative 'approx.rb'

# convert float to whole and fraction
def modf(number)
  whole = Integer(number)
  remainder = number - whole
  return whole.abs, remainder
end

class Angle
  # constants
  @@PI = Math::PI
  @@TWO_PI = Math::PI * 2
  @@PI_SYMBOL = "\u03c0"
  @@DEGREE_SYMBOL = "\u00b0"
  @@SECONDS_DECIMAL_PLACES = 2
  @@ROUND_TRIG

  # initializers

  def initialize(angle, mode=:degrees, display=:readable)
    @mode = mode
    @display = display

    case mode
      when :degrees
        self.from_radians Angle.normalize_radians(Angle.degrees_to_radians(angle))
      when :radians
        self.from_radians Angle.normalize_radians angle
    end
  end

  def from_degrees(degrees)
    @angle = Angle.degrees_to_radians(degrees)
  end

  def from_radians(radians)
    @angle = radians
  end

  # getters and setters

  def mode
    @mode
  end

  def display
    @display
  end

  def set_display(display)
    @display = display
  end

  def angle
    @angle
  end

  def radians
    self.angle
  end

  def degrees
    Angle.radians_to_degrees(self.radians).to_f
  end

  def minutes
    self.degrees * 60
  end

  def seconds
    self.minutes * 60
  end

  # normailize a value of degrees to [0, 360)
  def self.normalize_degrees(degrees)
    degrees -= 360 while degrees >= 360
    degrees += 360 while degrees <= -360
    degrees
  end

  # normalize a value of radians to [0, 2pi)
  def self.normalize_radians(radians)
    radians -= @@TWO_PI while radians >= @@TWO_PI
    radians += @@TWO_PI while radians <= -@@TWO_PI
    radians
  end

  # convert degrees as float to radians as float
  def self.degrees_to_radians(degrees)
    Angle.normalize_radians(degrees.to_f * @@PI / 180)
  end

  # convert radians as float to degrees as float
  def self.radians_to_degrees(radians)
    Angle.normalize_degrees(radians.to_f * 180 / @@PI)
  end

  # convert degrees as float to degrees, minutes, seconds
  def self.degrees_to_sexagesimal(degrees)
    degrees = Angle.normalize_degrees(degrees.to_f)
    degrees, remainder = modf degrees.to_f
    remainder = remainder.round(9)
    minutes, seconds = modf remainder * 60
    seconds *= 60
    return degrees, minutes, seconds
  end

  # convert degrees, minutes, seconds to degrees as float
  def self.sexagesimal_to_degrees(degrees, minutes, seconds)
    degrees = Angle.normalize_degrees(degrees.to_f)
    degrees + minutes.to_f / 60.0 + seconds.to_f / 3600.0
  end

  # convert degrees as float to coefficient of pi as rational
  def self.degrees_to_coefficient(degrees)
    Angle.radians_to_coefficient(Angle.degrees_to_radians(degrees))
  end

  # convert coefficient of pi as rational to degrees as float
  def self.coefficient_to_degrees(coefficient)
    Angle.normalize_degrees(coefficient.to_f * 180.0)
  end

  # convert radians as float to coefficient of pi as rational
  def self.radians_to_coefficient(radians)
    (radians.to_f / @@PI).to_r
  end

  # convert coefficient of pi as rational to radians as float
  def self.coefficient_to_radians(coefficient)
    Angle.normalize_radians(coefficient.to_f * @@PI)
  end

  # trig functions

  def sin
    sin = Math.sin(self.radians).round(@@ROUND_TRIG)
    (sin == 0) ? 0 : sin
  end

  def cos
    cos = Math.cos(self.radians).round(@@ROUND_TRIG)
    (cos == 0) ? 0 : cos
  end

  def cosine
    self.cos
  end

  def tan
    return nil if self.radians == @@PI / 2

    tan = Math.tan(self.radians).round(@@ROUND_TRIG)
    (tan == 0) ? 0 : tan
  end

  def tangent
    self.tan
  end

  def csc
    return nil if self.radians == 0 or self.radians == @@PI

    1 / self.sin
  end

  def cosecant
    self.csc
  end

  def sec
    return nil if self.radians == @@PI / 2

    1 / self.cos
  end

  def secant
    self.sec
  end

  def cot
    return nil if self.radians == 0 or self.radians == @@PI
    return 0 if self.radians == @@PI / 2

    1 / self.tan
  end

  def cotangent
    self.cot
  end

  def crd
    2 * (self / 2).sin
  end

  def chord
    self.crd
  end

  def versin
    1 - self.cos
  end

  def vercosin
    1 + self.cos
  end

  def coversin
    1 - self.sin
  end

  def covercosin
    1 + self.sin
  end

  def haversin
    self.versin / 2
  end

  def havercosin
    self.vercosin / 2
  end

  def hacoversin
    self.coversin / 2
  end

  def hacovercosin
    self.covercosin / 2
  end

  def exsec
    self.sec - 1
  end

  def exsecant
    self.exsec
  end

  def excsc
    self.csc - 1
  end

  # output and type conversions

  def to_s_deg
    case @display
      when :readable
        degrees = Angle.radians_to_degrees(self.radians.round(10))
        degrees, minutes, seconds = Angle.degrees_to_sexagesimal(degrees)
        seconds = seconds.round(@@SECONDS_DECIMAL_PLACES)

        output = ''
        output += (@angle < 0 ? '-' : '')
        output += "#{degrees}" + @@DEGREE_SYMBOL

        if minutes > 0 or seconds > 0
          output += "%02.0f" % minutes
          output += "\'"

          if seconds > 0
            seconds, remainder = modf(seconds)
            remainder = remainder.round(@@SECONDS_DECIMAL_PLACES)

            if remainder >= 1
              seconds += Integer(remainder).to_f
              remainder -= Integer(remainder).to_f
            end

            output += "%02.0f" % seconds

            if not (remainder == 0 or (remainder.abs < (10.0 ** -@@SECONDS_DECIMAL_PLACES)))
              output += ("#{remainder.round(@@SECONDS_DECIMAL_PLACES)}"[1..-1])
            end

            output += "\""
          end
        end

        return output
      when :decimal
        return Angle.radians_to_degrees(self.radians).to_s
      else
        return Angle.radians_to_degrees(self.radians).to_s
    end
  end

  def to_s_rad
    case @display
      when :readable
        coefficient = Angle.radians_to_coefficient(self.radians.round(10))

        return '0' if coefficient.numerator == 0

        output = ''
        output += '-' if @angle < 0
        output += "#{coefficient.numerator}" if coefficient.numerator.abs != 1
        output += @@PI_SYMBOL
        output += "/#{coefficient.denominator}" if coefficient.denominator.abs != 1

        return output
      when :decimal
        self.radians.to_f.to_s
      else
        self.radians.to_f.to_s
    end
  end

  def to_s
    case @mode
      when :degrees
        return to_s_deg
      when :radians
        return to_s_rad
      else
        return to_s_deg
    end
  end

  def to_f
    case @mode
      when :degrees
        return Angle.radians_to_degrees(self.radians).round(12)
      when :radians
        return self.radians
      else
        return Angle.radians_to_degrees self.radians
    end
  end

  def to_r
    Angle.radians_to_coefficient(self.radians) / 2
  end

  def to_degrees
    Angle.new(Angle.radians_to_degrees(self.radians), mode=:degrees, display=@display)
  end

  def to_radians
    Angle.new(self.radians, mode=:radians, display=@display)
  end

  def abs
    new_angle = self.clone
    new_angle.from_radians new_angle.angle.abs
    new_angle
  end

  def abs!
    @angle = @angle.abs
  end

  # operator overloads

  def +(other_angle)
    new_angle = self.clone
    new_angle.from_radians(Angle.normalize_radians(new_angle.angle + other_angle.angle))
    new_angle
  end

  def -(other_angle)
    new_angle = self.clone
    new_angle.from_radians(Angle.normalize_radians(new_angle.angle - other_angle.angle))
    new_angle
  end

  def *(number)
    new_angle = self.clone
    new_angle.from_radians(Angle.normalize_radians(new_angle.angle * number))
    new_angle
  end

  def /(number)
    new_angle = self.clone
    new_angle.from_radians(Angle.normalize_radians(new_angle.angle / number))
    new_angle
  end
end

def degrees(degrees)
  Angle.new degrees, mode=:degrees
end

def sexagesimal(degrees, minutes, seconds)
  Angle.new(Angle.sexagesimal_to_degrees(degrees, minutes, seconds), mode=:degrees)
end

def radians(radians)
  Angle.new radians, mode=:radians
end

a = sexagesimal(0, 1, 0)
puts a
puts a.degrees
puts a.degrees.to_r
