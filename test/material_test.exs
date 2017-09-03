defmodule MaterialTest do
  use ExUnit.Case, async: true
  import TracingPaper.Assertions

  alias TracingPaper.{Color, Material, Vector}
  alias TracingPaper.HomogeneousCoordinate, as: Coord

  test "has color, ambient, diffuse, specular, and shininess" do
    color     = Color.new(1, 0, 1)
    ambient   = 0.1
    diffuse   = 0.8
    specular  = 0.6
    shininess = 200
    material  = Material.new(
      color:     color,
      ambient:   ambient,
      diffuse:   diffuse,
      specular:  specular,
      shininess: shininess
    )
    assert material.color     == color
    assert material.ambient   == ambient
    assert material.diffuse   == diffuse
    assert material.specular  == specular
    assert material.shininess == shininess
  end

  describe "lighting" do
    setup ~w[add_lit_material]a

    test "with eye between the light and surface", %{material: material} do
      eye_vector     = Vector.new(0, 0, -1)
      normal_vector  = Vector.new(0, 0, -1)
      light_vector   = Vector.new(0, 0, -1)
      reflect_vector =
        Coord.reflect(Coord.negate(light_vector), normal_vector)
      lit            = Material.lighting(
        material,
        eye_vector,
        normal_vector,
        light_vector,
        reflect_vector
      )
      expected       = Color.new(1.9, 1.9, 1.9)
      assert_close_to_color lit, expected
    end

    test "with eye opposite surface and light offset 45 degrees",
         %{material: material} do
      eye_vector     = Vector.new(0, 0, -1)
      normal_vector  = Vector.new(0, 0, -1)
      light_vector   = Coord.normalize(Vector.new(0, 1, -1))
      reflect_vector =
        Coord.reflect(Coord.negate(light_vector), normal_vector)
      lit            = Material.lighting(
        material,
        eye_vector,
        normal_vector,
        light_vector,
        reflect_vector
      )
      expected       = Color.new(0.7364, 0.7364, 0.7364)
      assert_close_to_color lit, expected
    end

    test "with eye in the path of the reflection vector",
         %{material: material} do
      normal_vector  = Vector.new(0, 0, -1)
      light_vector   = Coord.normalize(Vector.new(0, 1, -1))
      reflect_vector =
        Coord.reflect(Coord.negate(light_vector), normal_vector)
      eye_vector     = reflect_vector
      lit            = Material.lighting(
        material,
        eye_vector,
        normal_vector,
        light_vector,
        reflect_vector
      )
      expected       = Color.new(1.6364, 1.6364, 1.6364)
      assert_close_to_color lit, expected
    end

    test "with the light behind the surface", %{material: material} do
      eye_vector     = Coord.normalize(Vector.new(0, 1, -1))
      normal_vector  = Vector.new(0, 0, -1)
      light_vector   = Vector.new(0, 1, 1)
      reflect_vector =
        Coord.reflect(Coord.negate(light_vector), normal_vector)
      lit            = Material.lighting(
        material,
        eye_vector,
        normal_vector,
        light_vector,
        reflect_vector
      )
      expected       = Color.new(0.1, 0.1, 0.1)
      assert_close_to_color lit, expected
    end
  end

  defp add_lit_material(context) do
    lit_material = Material.new(
      color:     Color.new(1, 1, 1),
      ambient:   0.1,
      diffuse:   0.9,
      specular:  0.9,
      shininess: 200
    )
    Map.put(context, :material, lit_material)
  end
end
