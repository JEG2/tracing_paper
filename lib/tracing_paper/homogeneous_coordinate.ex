defmodule TracingPaper.HomogeneousCoordinate do
  def add({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    {x1 + x2, y1 + y2, z1 + z2, w1 + w2}
  end

  def subtract({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    {x1 - x2, y1 - y2, z1 - z2, w1 - w2}
  end

  def negate({x, y, z, w}) do
    {-x, -y, -z, -w}
  end

  def multiply(n, t)
  when is_number(n) and is_tuple(t) and tuple_size(t) == 4 do
    multiply(t, n)
  end
  def multiply({x, y, z, w}, n) when is_number(n) do
    {x * n, y * n, z * n, w * n}
  end

  def divide(n, t)
  when is_number(n) and is_tuple(t) and tuple_size(t) == 4 do
    divide(t, n)
  end
  def divide({x, y, z, w}, n) when is_number(n) do
    {x / n, y / n, z / n, w / n}
  end

  def magnitude({x, y, z, 0}) do
    :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2) + :math.pow(z, 2))
  end

  def normalize({x, y, z, 0} = vector) do
    magnitude = magnitude(vector)
    {x / magnitude, y / magnitude, z / magnitude, 0}
  end

  def dot({x1, y1, z1, 0}, {x2, y2, z2, 0}) do
    x1 * x2 + y1 * y2 + z1 * z2
  end

  def cross({x1, y1, z1, 0}, {x2, y2, z2, 0}) do
    {y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2, 0}
  end
end
