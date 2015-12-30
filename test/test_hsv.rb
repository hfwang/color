# -*- ruby encoding: utf-8 -*-

require 'color'
require 'minitest_helper'

module TestColor
  class TestHSV < Minitest::Test
    def setup
#     @hsl = Color::HSL.new(262, 67, 42)
      @hsv = Color::HSV.new(145, 20, 30)
#     @rgb = Color::RGB.new(88, 35, 179)
    end

    def test_brightness
      assert_in_delta 30.0, @hsv.value, Color::COLOR_TOLERANCE
      assert_in_delta 0.3, @hsv.v, Color::COLOR_TOLERANCE
    end

    def test_hue
      assert_in_delta 0.4027, @hsv.h, Color::COLOR_TOLERANCE
      assert_in_delta 145, @hsv.hue, Color::COLOR_TOLERANCE
      @hsv.hue = 33
      assert_in_delta 0.09167, @hsv.h, Color::COLOR_TOLERANCE
      @hsv.hue = -33
      assert_in_delta 0.90833, @hsv.h, Color::COLOR_TOLERANCE
      @hsv.h = 3.3
      assert_in_delta 360, @hsv.hue, Color::COLOR_TOLERANCE
      @hsv.h = -3.3
      assert_in_delta 0.0, @hsv.h, Color::COLOR_TOLERANCE
      @hsv.hue = 0
      @hsv.hue -= 20
      assert_in_delta 340, @hsv.hue, Color::COLOR_TOLERANCE
      @hsv.hue += 45
      assert_in_delta 25, @hsv.hue, Color::COLOR_TOLERANCE
    end

    def test_saturation
      assert_in_delta 0.2, @hsv.s, Color::COLOR_TOLERANCE
      assert_in_delta 20, @hsv.saturation, Color::COLOR_TOLERANCE
      @hsv.saturation = 33
      assert_in_delta 0.33, @hsv.s, Color::COLOR_TOLERANCE
      @hsv.s = 3.3
      assert_in_delta 100, @hsv.saturation, Color::COLOR_TOLERANCE
      @hsv.s = -3.3
      assert_in_delta 0.0, @hsv.s, Color::COLOR_TOLERANCE
    end

    def test_to_grayscale
      gs = @hsv.to_grayscale
      assert_kind_of Color::GreyScale, gs
      assert_in_delta 30, gs.gray, Color::COLOR_TOLERANCE
    end

    def test_to_rgb
      rgb = @hsv.to_rgb
      assert_kind_of Color::RGB, rgb
      assert_in_delta 0.24, rgb.r, Color::COLOR_TOLERANCE
      assert_in_delta 0.30, rgb.g, Color::COLOR_TOLERANCE
      assert_in_delta 0.265, rgb.b, Color::COLOR_TOLERANCE
      assert_equal "#3d4d44", @hsv.html
      # assert_equal "rgb(24.00%, 36.00%, 29.00%)", @hsl.css_rgb
      # assert_equal "rgba(24.00%, 36.00%, 29.00%, 1.00)", @hsl.css_rgba
      # assert_equal "rgba(24.00%, 36.00%, 29.00%, 0.20)", @hsl.css_rgba(0.2)
    end

    def test_inspect
      assert_equal "HSV [145.00 deg, 20.00%, 30.00%]", @hsv.inspect
    end
  end
end
