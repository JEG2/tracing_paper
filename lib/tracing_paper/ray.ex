defmodule TracingPaper.Ray do
  defstruct ~w[origin direction]a

  alias TracingPaper.{Intersection, Matrix, Sphere}
  alias TracingPaper.HomogeneousCoordinate, as: Coord

  def new(origin, direction) do
    %__MODULE__{origin: origin, direction: direction}
  end

  def position(ray, t) do
    Coord.add(ray.origin, Coord.multiply(t, ray.direction))
  end

  def intersect(ray, %Sphere{ } = sphere) do
    object_ray    = transform(ray, Matrix.inverse(sphere.transformation))
    object_to_ray = Coord.subtract(object_ray.origin, sphere.origin)

    a = Coord.dot(object_ray.direction, object_ray.direction)
    b = 2 * Coord.dot(object_ray.direction, object_to_ray)
    c = Coord.dot(object_to_ray, object_to_ray) - 1

    discriminant = b * b - 4 * a * c

    cond do
      discriminant < 0 ->
        [ ]
      discriminant == 0 ->
        [-b / (2 * a)]
      discriminant > 0 ->
        discriminant_sqrt = :math.sqrt(discriminant)
        [
          (-b - discriminant_sqrt) / (2 * a),
          (-b + discriminant_sqrt) / (2 * a)
        ]
        |> Enum.sort
    end
    |> Enum.zip([false, true])
    |> Enum.map(fn {t, inside?} -> Intersection.new(t, sphere, inside?) end)
  end

  def transform(ray, matrix) do
    new(
      Matrix.multiply(matrix, ray.origin),
      Matrix.multiply(matrix, ray.direction)
    )
  end
end
