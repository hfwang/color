# -*- ruby encoding: utf-8 -*-

# An HSV colour object. Internally, the hue (#h), saturation (#s), and
# value/brightness (#v) values are dealt with as fractional values in
# the range 0..1.
class Color::HSV
  include Color

  class << self
    # Creates an HSL colour object from fractional values 0..1.
    def from_fraction(h = 0.0, s = 0.0, v = 0.0, &block)
      new(h, s, v, 1.0, 1.0, &block)
    end
  end

  # Coerces the other Color object into HSV.
  def coerce(other)
    other.to_hsl
  end

  # Creates an HSV colour object from the standard values of degrees and
  # percentages (e.g., 145 deg, 30%, 50%).
  def initialize(h = 0, s = 0, v = 0, radix1 = 360.0, radix2 = 100.0, &block) # :yields self:
    @h = Color.normalize(h / radix1)
    @s = Color.normalize(s / radix2)
    @v = Color.normalize(v / radix2)
    block.call if block
  end

  # Present the colour as an HTML/CSS colour string.
  def html
    to_rgb.html
  end

  # Present the colour as an RGB HTML/CSS colour string (e.g., "rgb(0%, 50%,
  # 100%)"). Note that this will perform a #to_rgb operation using the
  # default conversion formula.
  def css_rgb
    to_rgb.css_rgb
  end

  # Present the colour as an RGBA (with alpha) HTML/CSS colour string (e.g.,
  # "rgb(0%, 50%, 100%, 1)"). Note that this will perform a #to_rgb
  # operation using the default conversion formula.
  def css_rgba(alpha = 1)
    to_rgb.css_rgba(alpha)
  end

  # Present the colour as an HSL HTML/CSS colour string (e.g., "hsl(180,
  # 25%, 35%)").
  def css_hsl
    to_hsl.css_hsl
  end

  # Present the colour as an HSLA (with alpha) HTML/CSS colour string (e.g.,
  # "hsla(180, 25%, 35%, 1)").
  def css_hsla(alpha = 1)
    to_hsl.css_hsla(alpha)
  end

  # Converting from HSL to RGB. As with all colour conversions, this is
  # approximate at best. The code here is adapted from fvd and van Dam,
  # originally found at [1] (implemented similarly at [2]).
  #
  # This simplifies the calculations with the following assumptions:
  # - Luminance values <= 0 always translate to Color::RGB::Black.
  # - Luminance values >= 1 always translate to Color::RGB::White.
  # - Saturation values <= 0 always translate to a shade of gray using
  #   luminance as a percentage of gray.
  #
  # [1] http://bobpowell.net/RGBHSB.aspx
  # [2] http://support.microsoft.com/kb/29240
  def to_rgb(*)
    if Color.near_zero?(s)
      Color::RGB.from_grayscale_fraction(v)
    else
      h = (@h * 360) / 60
      i = h.floor
      f = h - i
      p = @v * (1 - @s)
      q = @v * (1 - @s * f)
      t = @v * (1 - @s * (1 - f))
      r, g, b = case i
                when 0
                  [v, t, p]
                when 1
                  [q, v, p]
                when 2
                  [p, v, t]
                when 3
                  [p, q, v]
                when 4
                  [t, p, v]
                else
                  [v, p, q]
                end

      # Only needed for Ruby 1.8. For Ruby 1.9+, we can do:
      # Color::RGB.new(*args, 1.0)
      Color::RGB.new(r, g, b, 1.0)
    end
  end

  # Converts to RGB then YIQ.
  def to_yiq
    to_rgb.to_yiq
  end

  # Converts to RGB then CMYK.
  def to_cmyk
    to_rgb.to_cmyk
  end

  def to_greyscale
    Color::GrayScale.from_fraction(@v)
  end
  alias to_grayscale to_greyscale

  # Returns the hue of the colour in degrees.
  def hue
    @h * 360.0
  end
  # Returns the hue of the colour in the range 0.0 .. 1.0.
  def h
    @h
  end
  # Sets the hue of the colour in degrees. Colour is perceived as a wheel,
  # so values should be set properly even with negative degree values.
  def hue=(hh)
    hh = hh / 360.0

    hh += 1.0 if hh < 0.0
    hh -= 1.0 if hh > 1.0

    @h = Color.normalize(hh)
  end
  # Sets the hue of the colour in the range 0.0 .. 1.0.
  def h=(hh)
    @h = Color.normalize(hh)
  end
  # Returns the percentage of saturation of the colour.
  def saturation
    @s * 100.0
  end
  # Returns the saturation of the colour in the range 0.0 .. 1.0.
  def s
    @s
  end
  # Sets the percentage of saturation of the colour.
  def saturation=(ss)
    @s = Color.normalize(ss / 100.0)
  end
  # Sets the saturation of the colour in the ragne 0.0 .. 1.0.
  def s=(ss)
    @s = Color.normalize(ss)
  end
  # Returns the percentage of brightness/value (#v) of the colour.
  def brightness
    @v * 100
  end
  alias value brightness

  # Returns the value of the colour in the range 0.0 .. 1.0.
  def v
    @v
  end
  # Sets the percentage of value of the colour.
  def value=(vv)
    @v = Color.normalize(vv / 100.0)
  end
  alias brightness= value= ;
  # Sets the value of the colour in the range 0.0 .. 1.0.
  def v=(vv)
    @v = Color.normalize(vv)
  end

  def to_hsv
    self
  end

  def to_hsl
    # With thanks to:
    # http://ariya.blogspot.com/2008/07/converting-between-hsl-and-hsv.html
    hh = @h
    ll = (2.0 - @s) * @v;
    ss = @s * @v;
    ss /= (ll <= 1) ? (ll) : 2 - (ll);
    ll /= 2;
    Color::HSL.from_fraction(hh, ss, ll)
  end

  def inspect
    "HSV [%.2f deg, %.2f%%, %.2f%%]" % [ hue, saturation, value ]
  end

  def to_a
    [ h, s, v ]
  end
end
