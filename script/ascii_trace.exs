alias TracingPaper.{Intersection, Matrix, Point, Ray, Sphere}
alias TracingPaper.HomogeneousCoordinate, as: Coord

origin        = Point.new(0, 0, -5)
sphere        =
  Sphere.new
  # |> Sphere.transform(Matrix.scale(1, 0.5, 1))
  # |> Sphere.transform(Matrix.scale(0.5, 1, 1))
  # |> Sphere.transform(
  #   Matrix.multiply(Matrix.rotate_z(45), Matrix.scale(0.5, 1, 1))
  # )
  |> Sphere.transform(
    Matrix.multiply(Matrix.shear(1, 0, 0, 0, 0, 0), Matrix.scale(0.5, 1, 1))
  )
canvas_offset = 10
char_width    = 0.5
char_height   = 1
image_width   = 20
image_height  = 10
half_width    = div(image_width, 2)
half_height   = div(image_height, 2)

Enum.each(half_height..-half_height, fn char_y ->
  Enum.each(-half_width..half_width, fn char_x ->
    world_x = char_x * char_width
    world_y = char_y * char_height

    position = Point.new(world_x, world_y, canvas_offset)

    r = Ray.new(origin, Coord.normalize(Coord.subtract(position, origin)))
    i = Ray.intersect(r, sphere)

    if Intersection.hit(i) do
      IO.write("#")
    else
      IO.write(" ")
    end
  end)

  IO.write("\n")
end)
