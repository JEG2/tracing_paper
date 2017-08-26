defmodule PointTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Point, Vector}

  test "points are created from x, y, and z coordinates" do
    point        = Point.new(4, -4, 3)
    {x, y, z, w} = point
    assert x == 4
    assert y == -4
    assert z == 3
    assert w == 1
    assert Point.valid?(point)
    refute Vector.valid?(point)
  end
end
