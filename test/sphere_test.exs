defmodule SphereTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Matrix, Point, Sphere}

  test "has an origin and a radius" do
    sphere = Sphere.new
    origin = Point.new(0, 0, 0)
    radius = 1
    assert sphere.origin == origin
    assert sphere.radius == radius
  end

  test "defaults to an identity transformation" do
    sphere = Sphere.new
    assert sphere.transformation == Matrix.identity
  end

  test "set a transformation" do
    sphere     = Sphere.new
    matrix     = Matrix.translate(2, 3, 4)
    translated = Sphere.transform(sphere, matrix)
    assert translated.origin         == sphere.origin
    assert translated.radius         == sphere.radius
    assert translated.transformation == matrix
  end
end
