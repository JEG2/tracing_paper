defmodule HomogeneousCoordinateTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Point, Vector}
  alias TracingPaper.HomogeneousCoordinate, as: Coord

  test "addition" do
    point  = Point.new(3, -2, 5)
    vector = Vector.new(-2, 3, 1)
    sum    = Coord.add(point, vector)
    assert sum == {1, 1, 6, 1}
  end

  test "subtraction" do
    point1     = Point.new(3, 2, 1)
    point2     = Point.new(5, 6, 7)
    difference = Coord.subtract(point1, point2)
    expected   = Vector.new(-2, -4, -6)
    assert difference == expected
  end

  test "negation" do
    t        = {1, -2, 3, -4}
    negated  = Coord.negate(t)
    expected = {-1, 2, -3, 4}
    assert negated == expected
  end

  test "scalar multiplication" do
    t        = {1, -2, 3, -4}
    product  = Coord.multiply(t, 3.5)
    expected = {3.5, -7, 10.5, -14}
    assert_close_to(product, expected)

    product  = Coord.multiply(t, 0.5)
    expected = {0.5, -1, 1.5, -2}
    assert_close_to(product, expected)
  end

  test "scalar division" do
    t        = {1, -2, 3, -4}
    result   = Coord.divide(t, 2)
    expected = {0.5, -1, 1.5, -2}
    assert_close_to(result, expected)
  end

  test "magnitudes" do
    vector    = Vector.new(1, 0, 0)
    magnitude = Coord.magnitude(vector)
    assert magnitude == 1

    vector    = Vector.new(0, 1, 0)
    magnitude = Coord.magnitude(vector)
    assert magnitude == 1

    vector    = Vector.new(0, 0, 1)
    magnitude = Coord.magnitude(vector)
    assert magnitude == 1

    vector    = Vector.new(1, 2, 3)
    magnitude = Coord.magnitude(vector)
    expected  = :math.sqrt(14)
    assert magnitude == expected

    vector    = Vector.new(-1, -2, -3)
    magnitude = Coord.magnitude(vector)
    assert magnitude == expected
  end

  test "normalization" do
    vector     = Vector.new(4, 0, 0)
    normalized = Coord.normalize(vector)
    expected   = Vector.new(1, 0, 0)
    assert normalized == expected

    vector     = Vector.new(1, 2, 3)
    normalized = Coord.normalize(vector)
    magnitude  = :math.sqrt(14)
    expected   = Vector.new(1 / magnitude, 2 / magnitude, 3 / magnitude)
    assert normalized == expected

    normalized_magnitude = Coord.magnitude(Coord.normalize(vector))
    assert normalized_magnitude == 1
  end

  test "dot products" do
    vector1 = Vector.new(1, 2, 3)
    vector2 = Vector.new(2, 3, 4)
    product = Coord.dot(vector1, vector2)
    assert product == 20
  end

  test "cross products" do
    vector1  = Vector.new(1, 2, 3)
    vector2  = Vector.new(2, 3, 4)
    product  = Coord.cross(vector1, vector2)
    expected = Vector.new(-1, 2, -1)
    assert product == expected
  end

  def assert_close_to({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    assert_in_delta x1, x2, 0.0001
    assert_in_delta y1, y2, 0.0001
    assert_in_delta z1, z2, 0.0001
    assert_in_delta w1, w2, 0.0001
  end
end
