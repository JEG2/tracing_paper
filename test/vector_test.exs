defmodule VectorTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Point, Vector}

  test "vectors are created from x, y, and z distances" do
    vector       = Vector.new(-4, 4, -3)
    {x, y, z, w} = vector
    assert x == -4
    assert y == 4
    assert z == -3
    assert w == 0
    assert Vector.valid?(vector)
    refute Point.valid?(vector)
  end
end
