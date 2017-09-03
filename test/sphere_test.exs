defmodule SphereTest do
  use ExUnit.Case, async: true
  import TracingPaper.Assertions

  alias TracingPaper.{Color, Material, Matrix, Point, Sphere, Vector}
  alias TracingPaper.HomogeneousCoordinate, as: Coord

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

  test "computes the normal on the x axis" do
    sphere   = Sphere.new
    point    = Point.new(1, 0, 0)
    normal   = Sphere.normal(sphere, point)
    expected = Vector.new(1, 0, 0)
    assert normal == expected
  end

  test "computes the normal on the y axis" do
    sphere   = Sphere.new
    point    = Point.new(0, 1, 0)
    normal   = Sphere.normal(sphere, point)
    expected = Vector.new(0, 1, 0)
    assert normal == expected
  end

  test "computes the normal on the z axis" do
    sphere   = Sphere.new
    point    = Point.new(0, 0, 1)
    normal   = Sphere.normal(sphere, point)
    expected = Vector.new(0, 0, 1)
    assert normal == expected
  end

  test "computes the normal on a non-axial point" do
    sphere   = Sphere.new
    n        = :math.sqrt(3) / 3
    point    = Point.new(n, n, n)
    normal   = Sphere.normal(sphere, point)
    expected = Vector.new(n, n, n)
    assert_close_to_tuple normal, expected
  end

  test "the surface normal is a normalized vector" do
    sphere   = Sphere.new
    n        = :math.sqrt(3) / 3
    point    = Point.new(n, n, n)
    normal   = Sphere.normal(sphere, point)
    expected = Coord.normalize(normal)
    assert_close_to_tuple normal, expected
  end

  test "computes the normal on a translated sphere" do
    sphere   =
      Sphere.new
      |> Sphere.transform(Matrix.translate(0, 5, 0))
    point    = Point.new(1, 5, 0)
    normal   = Sphere.normal(sphere, point)
    expected = Vector.new(1, 0, 0)
    assert_close_to_tuple normal, expected
  end

  test "computes the normal on a scaled sphere" do
    sphere   =
      Sphere.new
      |> Sphere.transform(Matrix.scale(1, 0.5, 1))
    n        = :math.sqrt(2) / 2
    point    = Point.new(0, n, n)
    normal   = Sphere.normal(sphere, point)
    expected = Vector.new(0, 0.97014, 0.24254)
    assert_close_to_tuple normal, expected
  end

  test "defaults the material" do
    sphere = Sphere.new
    color  = Color.new(1, 1, 1)
    assert sphere.material.color     == color
    assert sphere.material.ambient   == 0.1
    assert sphere.material.diffuse   == 0.8
    assert sphere.material.specular  == 0.6
    assert sphere.material.shininess == 200
  end

  test "material can be changed" do
    material = Material.new(
      color:     Color.new(1, 0, 1),
      ambient:   0.2,
      diffuse:   0.6,
      specular:  0.8,
      shininess: 100
    )
    sphere =
      Sphere.new
      |> Sphere.change_material(material)
    assert sphere.material == material
  end
end
