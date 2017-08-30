defmodule RayTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Matrix, Point, Ray, Sphere, Vector}

  test "has an origin and a direction" do
    origin    = Point.new(1, 2, 3)
    direction = Vector.new(4, 5, 6)
    ray       = Ray.new(origin, direction)
    assert ray.origin    == origin
    assert ray.direction == direction
  end

  test "computes points from distance" do
    ray   = Ray.new(Point.new(2, 3, 4), Vector.new(1, 0, 0))
    point = Ray.position(ray, 0)
    assert point == ray.origin

    point    = Ray.position(ray, 1)
    expected = Point.new(3, 3, 4)
    assert point == expected

    point    = Ray.position(ray, -1)
    expected = Point.new(1, 3, 4)
    assert point == expected

    point    = Ray.position(ray, 2.5)
    expected = Point.new(4.5, 3, 4)
    assert point == expected
  end

  test "intersects a sphere at two points" do
    ray           = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.t end)
    assert intersections == [4, 6]
  end

  test "intersects a sphere at one point" do
    ray           = Ray.new(Point.new(0, 1, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.t end)
    assert intersections == [5]
  end

  test "misses a sphere" do
    ray           = Ray.new(Point.new(0, 2, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections = Ray.intersect(ray, sphere)
    assert intersections == [ ]
  end

  test "intersects inside a sphere" do
    ray           = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.t end)
    assert intersections == [-1, 1]
  end

  test "intersects behind a sphere" do
    ray           = Ray.new(Point.new(0, 0, 5), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.t end)
    assert intersections == [-6, -4]
  end

  test "intersections contain the object of intersection" do
    ray           = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.object end)
    assert intersections == [sphere, sphere]
  end

  test "intersection computes outside/inside" do
    ray           = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.new
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.inside? end)
    assert intersections == [false, true]
  end

  test "translation moves origin but not direction" do
    ray        = Ray.new(Point.new(1, 2, 3), Vector.new(0, 1, 0))
    matrix     = Matrix.translate(3, 4, 5)
    translated = Ray.transform(ray, matrix)
    expected   = Point.new(4, 6, 8)
    assert translated.origin    == expected
    assert translated.direction == ray.direction
  end

  test "scaling affects origin and direction" do
    ray                = Ray.new(Point.new(1, 2, 3), Vector.new(0, 1, 0))
    matrix             = Matrix.scale(2, 3, 4)
    scaled             = Ray.transform(ray, matrix)
    expected_origin    = Point.new(2, 6, 12)
    expected_direction = Vector.new(0, 3, 0)
    assert scaled.origin    == expected_origin
    assert scaled.direction == expected_direction
  end

  test "intersect honors scaling" do
    ray           = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.transform(Sphere.new, Matrix.scale(2, 2, 2))
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.t end)
    assert intersections == [3, 7]
  end

  test "intersect honors translation" do
    ray           = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    sphere        = Sphere.transform(Sphere.new, Matrix.translate(5, 0, 0))
    intersections =
      ray
      |> Ray.intersect(sphere)
      |> Enum.map(fn intersection -> intersection.t end)
    assert intersections == [ ]
  end
end
