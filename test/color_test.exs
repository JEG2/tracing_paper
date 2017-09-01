defmodule ColorTest do
  use ExUnit.Case, async: true
  import TracingPaper.Assertions

  alias TracingPaper.Color

  test "created from RGB values" do
    color     = Color.new(0.2, 0.4, 0.7)
    {r, g, b} = color
    assert r == 0.2
    assert g == 0.4
    assert b == 0.7
  end

  test "adds by components" do
    color1   = Color.new(0.9, 0.6, 0.75)
    color2   = Color.new(0.7, 0.1, 0.25)
    sum      = Color.add(color1, color2)
    expected = Color.new(1.6, 0.7, 1.0)
    assert_close_to_color sum, expected
  end

  test "subtracts by components" do
    color1     = Color.new(0.9, 0.6, 0.75)
    color2     = Color.new(0.7, 0.1, 0.25)
    difference = Color.subtract(color1, color2)
    expected   = Color.new(0.2, 0.5, 0.5)
    assert_close_to_color difference, expected
  end

  test "scalar multiplication scales components" do
    color    = Color.new(0.2, 0.3, 0.4)
    product  = Color.multiply(color, 2)
    expected = Color.new(0.4, 0.6, 0.8)
    assert_close_to_color product, expected
  end

  test "multiplies by components" do
    color1   = Color.new(1, 0.2, 0.4)
    color2   = Color.new(0.9, 1, 0.1)
    product  = Color.multiply(color1, color2)
    expected = Color.new(0.9, 0.2, 0.04)
    assert_close_to_color product, expected
  end
end
