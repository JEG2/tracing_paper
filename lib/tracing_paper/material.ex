defmodule TracingPaper.Material do
  alias TracingPaper.Color
  alias TracingPaper.HomogeneousCoordinate, as: Coord

  defstruct color:     Color.new(1, 1, 1),
            ambient:   0.1,
            diffuse:   0.8,
            specular:  0.6,
            shininess: 200

  def new(attributes \\ [ ]) do
    struct(__MODULE__, attributes)
  end

  def lighting(
    material,
    eye_vector,
    normal_vector,
    light_vector,
    reflect_vector
  ) do
    light_dot_normal = Coord.dot(light_vector, normal_vector)
    intensity        =
      if light_dot_normal < 0 do
        material.ambient
      else
        diffuse         = material.diffuse * light_dot_normal
        reflect_dot_eye = Coord.dot(reflect_vector, eye_vector)
        specular        = material.specular *
                          :math.pow(reflect_dot_eye, material.shininess)
        material.ambient + diffuse + specular
      end
    Color.multiply(material.color, intensity)
  end
end
