defmodule IntersectionTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Intersection, Sphere}

  test "has a t value, an object, and an inside flag" do
    t            = 3.5
    sphere       = Sphere.new
    inside?      = true
    intersection = Intersection.new(t, sphere, inside?)
    assert intersection.t       == t
    assert intersection.object  == sphere
    assert intersection.inside? == inside?
  end

  test "computes the hit with all positive intersections" do
    sphere       = Sphere.new
    expected     = Intersection.new(1, sphere, false)
    intersection = Intersection.new(2, sphere, true)
    hit          = Intersection.hit([expected, intersection])
    assert hit == expected
  end

  test "computes the hit with negative and positive intersections" do
    sphere       = Sphere.new
    intersection = Intersection.new(-1, sphere, false)
    expected     = Intersection.new(1,  sphere, true)
    hit          = Intersection.hit([intersection, expected])
    assert hit == expected
  end

  test "computes the hit with all negative intersections" do
    sphere        = Sphere.new
    intersection1 = Intersection.new(-2, sphere, false)
    intersection2 = Intersection.new(-1, sphere, true)
    hit           = Intersection.hit([intersection1, intersection2])
    assert is_nil(hit)
  end
end
