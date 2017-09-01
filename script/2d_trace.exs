alias TracingPaper.{Canvas, Color, Intersection, Matrix, Point, Ray, Sphere}
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
canvas_offset = 200
image_width   = 100
image_height  = 100
half_width    = div(image_width, 2)
half_height   = div(image_height, 2)
red           = Color.new(1, 0, 0)

File.cd!(__DIR__, fn ->
  Enum.reduce(
    half_height..-half_height,
    Canvas.new(image_width, image_height),
    fn y, acc ->
      Enum.reduce(-half_width..half_width, acc, fn x, canvas ->
        position = Point.new(x, y, canvas_offset)

        r = Ray.new(origin, Coord.normalize(Coord.subtract(position, origin)))
        i = Ray.intersect(r, sphere)

        if Intersection.hit(i) do
          Canvas.draw(canvas, x + 50, y + 50, red)
        else
          canvas
        end
      end)
    end
  )
  |> Canvas.to_png("2d_sphere.png")
end)
