alias TracingPaper.{
  Canvas,
  Color,
  Intersection,
  Material,
  Point,
  Ray,
  Sphere,
  Vector
}
alias TracingPaper.HomogeneousCoordinate, as: Coord

origin        = Point.new(0, 0, -5)
sphere        =
  Sphere.new
  |> Sphere.change_material(
    Material.new(
      color:     Color.new(1, 0, 1),
      ambient:   0.1,
      diffuse:   0.9,
      specular:  0.6,
      shininess: 200
    )
  )
canvas_offset = 200
image_width   = 100
image_height  = 100
half_width    = div(image_width, 2)
half_height   = div(image_height, 2)
light         = Coord.normalize(Vector.new(-1, -1, -1))
incoming      = Coord.negate(light)

File.cd!(__DIR__, fn ->
  Enum.reduce(
    half_height..-half_height,
    Canvas.new(image_width, image_height),
    fn y, acc ->
      Enum.reduce(-half_width..half_width, acc, fn x, canvas ->
        position = Point.new(x, y, canvas_offset)

        ray           = Ray.new(
          origin,
          Coord.normalize(Coord.subtract(position, origin))
        )
        intersections = Ray.intersect(ray, sphere)
        hit           = Intersection.hit(intersections)

        if hit do
          point      = Ray.position(ray, hit.t)
          normal     = Sphere.normal(hit.object, point)
          eye        = Coord.negate(ray.direction)
          reflection = Coord.reflect(incoming, normal)
          color      = Material.lighting(
            hit.object.material,
            eye,
            normal,
            light,
            reflection
          )
          Canvas.draw(canvas, x + 50, y + 50, color)
        else
          canvas
        end
      end)
    end
  )
  |> Canvas.to_png("3d_sphere.png")
end)
