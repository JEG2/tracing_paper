defmodule TracingPaper.Sphere do
  alias TracingPaper.{Material, Matrix, Point}
  alias TracingPaper.HomogeneousCoordinate, as: Coord

  defstruct origin:         Point.new(0, 0, 0),
            radius:         1,
            transformation: Matrix.identity,
            material:       Material.new

  def new(attributes \\ [ ]) do
    struct(__MODULE__, attributes)
  end

  def change_material(sphere, material) do
    %__MODULE__{sphere | material: material}
  end

  def transform(sphere, transformation) do
    %__MODULE__{sphere | transformation: transformation}
  end

  def normal(sphere, point) do
    object_point  =
      Matrix.multiply(Matrix.inverse(sphere.transformation), point)
    object_normal = Coord.subtract(object_point, sphere.origin)
    world_normal  =
      Matrix.multiply(
        Matrix.transpose(Matrix.inverse(sphere.transformation)),
        object_normal
      )
    Coord.normalize(world_normal)
  end
end
