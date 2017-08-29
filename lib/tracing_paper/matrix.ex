defmodule TracingPaper.Matrix do
  @identity %{
    {0, 0} => 1,
    {1, 0} => 0,
    {2, 0} => 0,
    {3, 0} => 0,
    {0, 1} => 0,
    {1, 1} => 1,
    {2, 1} => 0,
    {3, 1} => 0,
    {0, 2} => 0,
    {1, 2} => 0,
    {2, 2} => 1,
    {3, 2} => 0,
    {0, 3} => 0,
    {1, 3} => 0,
    {2, 3} => 0,
    {3, 3} => 1,
  }

  def new(rows) do
    rows
    |> List.flatten
    |> Enum.with_index
    |> Enum.reduce(%{ }, fn {value, i}, matrix ->
      Map.put(matrix, i_to_xy(i), value)
    end)
  end

  def identity do
    @identity
  end

  def at(matrix, x, y) do
    Map.fetch!(matrix, {x, y})
  end

  def multiply(tuple, matrix) when is_tuple(tuple) do
    multiply(matrix, tuple)
  end
  def multiply(matrix, tuple) when is_tuple(tuple) do
    Enum.map(0..3, fn y ->
      Enum.map(0..3, fn x -> at(matrix, x, y) end)
      |> Enum.zip(Tuple.to_list(tuple))
      |> Enum.map(fn {l, r} -> l * r end)
      |> Enum.sum
    end)
    |> List.to_tuple
  end
  def multiply(matrix1, matrix2) do
    Enum.reduce(0..15, %{ }, fn i, matrix ->
      {x, y} = xy = i_to_xy(i)
      value =
        at(matrix1, 0, y) * at(matrix2, x, 0) +
        at(matrix1, 1, y) * at(matrix2, x, 1) +
        at(matrix1, 2, y) * at(matrix2, x, 2) +
        at(matrix1, 3, y) * at(matrix2, x, 3)
      Map.put(matrix, xy, value)
    end)
  end

  def transpose(matrix) do
    Enum.into(matrix, %{ }, fn {{x, y}, value} -> {{y, x}, value} end)
  end

  def det(m) do
    at(m, 0, 0) * at(m, 1, 1) * at(m, 2, 2) * at(m, 3, 3) +
    at(m, 0, 0) * at(m, 2, 1) * at(m, 3, 2) * at(m, 1, 3) +
    at(m, 0, 0) * at(m, 3, 1) * at(m, 1, 2) * at(m, 2, 3) +
    at(m, 1, 0) * at(m, 0, 1) * at(m, 3, 2) * at(m, 2, 3) +
    at(m, 1, 0) * at(m, 2, 1) * at(m, 0, 2) * at(m, 3, 3) +
    at(m, 1, 0) * at(m, 3, 1) * at(m, 2, 2) * at(m, 0, 3) +
    at(m, 2, 0) * at(m, 0, 1) * at(m, 1, 2) * at(m, 3, 3) +
    at(m, 2, 0) * at(m, 1, 1) * at(m, 3, 2) * at(m, 0, 3) +
    at(m, 2, 0) * at(m, 3, 1) * at(m, 0, 2) * at(m, 1, 3) +
    at(m, 3, 0) * at(m, 0, 1) * at(m, 2, 2) * at(m, 1, 3) +
    at(m, 3, 0) * at(m, 1, 1) * at(m, 0, 2) * at(m, 2, 3) +
    at(m, 3, 0) * at(m, 2, 1) * at(m, 1, 2) * at(m, 0, 3) -
    at(m, 0, 0) * at(m, 1, 1) * at(m, 3, 2) * at(m, 2, 3) -
    at(m, 0, 0) * at(m, 2, 1) * at(m, 1, 2) * at(m, 3, 3) -
    at(m, 0, 0) * at(m, 3, 1) * at(m, 2, 2) * at(m, 1, 3) -
    at(m, 1, 0) * at(m, 0, 1) * at(m, 2, 2) * at(m, 3, 3) -
    at(m, 1, 0) * at(m, 2, 1) * at(m, 3, 2) * at(m, 0, 3) -
    at(m, 1, 0) * at(m, 3, 1) * at(m, 0, 2) * at(m, 2, 3) -
    at(m, 2, 0) * at(m, 0, 1) * at(m, 3, 2) * at(m, 1, 3) -
    at(m, 2, 0) * at(m, 1, 1) * at(m, 0, 2) * at(m, 3, 3) -
    at(m, 2, 0) * at(m, 3, 1) * at(m, 1, 2) * at(m, 0, 3) -
    at(m, 3, 0) * at(m, 0, 1) * at(m, 1, 2) * at(m, 2, 3) -
    at(m, 3, 0) * at(m, 1, 1) * at(m, 2, 2) * at(m, 0, 3) -
    at(m, 3, 0) * at(m, 2, 1) * at(m, 0, 2) * at(m, 1, 3)
  end

  def invertible?(determinant) when is_number(determinant) do
    determinant != 0
  end
  def invertible?(matrix) do
    matrix
    |> det
    |> invertible?
  end

  def inverse(matrix) do
    determinant = det(matrix)

    unless invertible?(determinant) do
      raise "Error:  Matrix not invertible."
    end

    [
      at(matrix, 1, 1) * at(matrix, 2, 2) * at(matrix, 3, 3) +
      at(matrix, 2, 1) * at(matrix, 3, 2) * at(matrix, 1, 3) +
      at(matrix, 3, 1) * at(matrix, 1, 2) * at(matrix, 2, 3) -
      at(matrix, 1, 1) * at(matrix, 3, 2) * at(matrix, 2, 3) -
      at(matrix, 2, 1) * at(matrix, 1, 2) * at(matrix, 3, 3) -
      at(matrix, 3, 1) * at(matrix, 2, 2) * at(matrix, 1, 3),

      at(matrix, 1, 0) * at(matrix, 3, 2) * at(matrix, 2, 3) +
      at(matrix, 2, 0) * at(matrix, 1, 2) * at(matrix, 3, 3) +
      at(matrix, 3, 0) * at(matrix, 2, 2) * at(matrix, 1, 3) -
      at(matrix, 1, 0) * at(matrix, 2, 2) * at(matrix, 3, 3) -
      at(matrix, 2, 0) * at(matrix, 3, 2) * at(matrix, 1, 3) -
      at(matrix, 3, 0) * at(matrix, 1, 2) * at(matrix, 2, 3),

      at(matrix, 1, 0) * at(matrix, 2, 1) * at(matrix, 3, 3) +
      at(matrix, 2, 0) * at(matrix, 3, 1) * at(matrix, 1, 3) +
      at(matrix, 3, 0) * at(matrix, 1, 1) * at(matrix, 2, 3) -
      at(matrix, 1, 0) * at(matrix, 3, 1) * at(matrix, 2, 3) -
      at(matrix, 2, 0) * at(matrix, 1, 1) * at(matrix, 3, 3) -
      at(matrix, 3, 0) * at(matrix, 2, 1) * at(matrix, 1, 3),

      at(matrix, 1, 0) * at(matrix, 3, 1) * at(matrix, 2, 2) +
      at(matrix, 2, 0) * at(matrix, 1, 1) * at(matrix, 3, 2) +
      at(matrix, 3, 0) * at(matrix, 2, 1) * at(matrix, 1, 2) -
      at(matrix, 1, 0) * at(matrix, 2, 1) * at(matrix, 3, 2) -
      at(matrix, 2, 0) * at(matrix, 3, 1) * at(matrix, 1, 2) -
      at(matrix, 3, 0) * at(matrix, 1, 1) * at(matrix, 2, 2),



      at(matrix, 0, 1) * at(matrix, 3, 2) * at(matrix, 2, 3) +
      at(matrix, 2, 1) * at(matrix, 0, 2) * at(matrix, 3, 3) +
      at(matrix, 3, 1) * at(matrix, 2, 2) * at(matrix, 0, 3) -
      at(matrix, 0, 1) * at(matrix, 2, 2) * at(matrix, 3, 3) -
      at(matrix, 2, 1) * at(matrix, 3, 2) * at(matrix, 0, 3) -
      at(matrix, 3, 1) * at(matrix, 0, 2) * at(matrix, 2, 3),

      at(matrix, 0, 0) * at(matrix, 2, 2) * at(matrix, 3, 3) +
      at(matrix, 2, 0) * at(matrix, 3, 2) * at(matrix, 0, 3) +
      at(matrix, 3, 0) * at(matrix, 0, 2) * at(matrix, 2, 3) -
      at(matrix, 0, 0) * at(matrix, 3, 2) * at(matrix, 2, 3) -
      at(matrix, 2, 0) * at(matrix, 0, 2) * at(matrix, 3, 3) -
      at(matrix, 3, 0) * at(matrix, 2, 2) * at(matrix, 0, 3),

      at(matrix, 0, 0) * at(matrix, 3, 1) * at(matrix, 2, 3) +
      at(matrix, 2, 0) * at(matrix, 0, 1) * at(matrix, 3, 3) +
      at(matrix, 3, 0) * at(matrix, 2, 1) * at(matrix, 0, 3) -
      at(matrix, 0, 0) * at(matrix, 2, 1) * at(matrix, 3, 3) -
      at(matrix, 2, 0) * at(matrix, 3, 1) * at(matrix, 0, 3) -
      at(matrix, 3, 0) * at(matrix, 0, 1) * at(matrix, 2, 3),

      at(matrix, 0, 0) * at(matrix, 2, 1) * at(matrix, 3, 2) +
      at(matrix, 2, 0) * at(matrix, 3, 1) * at(matrix, 0, 2) +
      at(matrix, 3, 0) * at(matrix, 0, 1) * at(matrix, 2, 2) -
      at(matrix, 0, 0) * at(matrix, 3, 1) * at(matrix, 2, 2) -
      at(matrix, 2, 0) * at(matrix, 0, 1) * at(matrix, 3, 2) -
      at(matrix, 3, 0) * at(matrix, 2, 1) * at(matrix, 0, 2),



      at(matrix, 0, 1) * at(matrix, 1, 2) * at(matrix, 3, 3) +
      at(matrix, 1, 1) * at(matrix, 3, 2) * at(matrix, 0, 3) +
      at(matrix, 3, 1) * at(matrix, 0, 2) * at(matrix, 1, 3) -
      at(matrix, 0, 1) * at(matrix, 3, 2) * at(matrix, 1, 3) -
      at(matrix, 1, 1) * at(matrix, 0, 2) * at(matrix, 3, 3) -
      at(matrix, 3, 1) * at(matrix, 1, 2) * at(matrix, 0, 3),

      at(matrix, 0, 0) * at(matrix, 3, 2) * at(matrix, 1, 3) +
      at(matrix, 1, 0) * at(matrix, 0, 2) * at(matrix, 3, 3) +
      at(matrix, 3, 0) * at(matrix, 1, 2) * at(matrix, 0, 3) -
      at(matrix, 0, 0) * at(matrix, 1, 2) * at(matrix, 3, 3) -
      at(matrix, 0, 1) * at(matrix, 3, 2) * at(matrix, 0, 3) -
      at(matrix, 3, 0) * at(matrix, 0, 2) * at(matrix, 1, 3),

      at(matrix, 0, 0) * at(matrix, 1, 1) * at(matrix, 3, 3) +
      at(matrix, 1, 0) * at(matrix, 3, 1) * at(matrix, 0, 3) +
      at(matrix, 3, 0) * at(matrix, 0, 1) * at(matrix, 1, 3) -
      at(matrix, 0, 0) * at(matrix, 3, 1) * at(matrix, 1, 3) -
      at(matrix, 1, 0) * at(matrix, 0, 1) * at(matrix, 3, 3) -
      at(matrix, 3, 0) * at(matrix, 1, 1) * at(matrix, 0, 3),

      at(matrix, 0, 0) * at(matrix, 3, 1) * at(matrix, 1, 2) +
      at(matrix, 1, 0) * at(matrix, 0, 1) * at(matrix, 3, 2) +
      at(matrix, 3, 0) * at(matrix, 1, 1) * at(matrix, 0, 2) -
      at(matrix, 0, 0) * at(matrix, 1, 1) * at(matrix, 3, 2) -
      at(matrix, 1, 0) * at(matrix, 3, 1) * at(matrix, 0, 2) -
      at(matrix, 3, 0) * at(matrix, 0, 1) * at(matrix, 1, 2),



      at(matrix, 0, 1) * at(matrix, 2, 2) * at(matrix, 1, 3) +
      at(matrix, 1, 1) * at(matrix, 0, 2) * at(matrix, 2, 3) +
      at(matrix, 2, 1) * at(matrix, 1, 2) * at(matrix, 0, 3) -
      at(matrix, 0, 1) * at(matrix, 1, 2) * at(matrix, 2, 3) -
      at(matrix, 1, 1) * at(matrix, 2, 2) * at(matrix, 0, 3) -
      at(matrix, 2, 1) * at(matrix, 0, 2) * at(matrix, 1, 3),

      at(matrix, 0, 0) * at(matrix, 1, 2) * at(matrix, 2, 3) +
      at(matrix, 1, 0) * at(matrix, 2, 2) * at(matrix, 0, 3) +
      at(matrix, 2, 0) * at(matrix, 0, 2) * at(matrix, 1, 3) -
      at(matrix, 0, 0) * at(matrix, 2, 2) * at(matrix, 1, 3) -
      at(matrix, 1, 0) * at(matrix, 0, 2) * at(matrix, 2, 3) -
      at(matrix, 2, 0) * at(matrix, 1, 2) * at(matrix, 0, 3),

      at(matrix, 0, 0) * at(matrix, 2, 1) * at(matrix, 1, 3) +
      at(matrix, 1, 0) * at(matrix, 0, 1) * at(matrix, 2, 3) +
      at(matrix, 2, 0) * at(matrix, 1, 1) * at(matrix, 0, 3) -
      at(matrix, 0, 0) * at(matrix, 1, 1) * at(matrix, 2, 3) -
      at(matrix, 1, 0) * at(matrix, 2, 1) * at(matrix, 0, 3) -
      at(matrix, 2, 0) * at(matrix, 0, 1) * at(matrix, 1, 3),

      at(matrix, 0, 0) * at(matrix, 1, 1) * at(matrix, 2, 2) +
      at(matrix, 1, 0) * at(matrix, 2, 1) * at(matrix, 0, 2) +
      at(matrix, 2, 0) * at(matrix, 0, 1) * at(matrix, 1, 2) -
      at(matrix, 0, 0) * at(matrix, 2, 1) * at(matrix, 1, 2) -
      at(matrix, 1, 0) * at(matrix, 0, 1) * at(matrix, 2, 2) -
      at(matrix, 2, 0) * at(matrix, 1, 1) * at(matrix, 0, 2),
    ]
    |> Enum.map(fn n -> n / determinant end)
    |> new
  end

  def translate(x, y, z) do
    identity()
    |> Map.put({3, 0}, x)
    |> Map.put({3, 1}, y)
    |> Map.put({3, 2}, z)
  end

  def scale(x, y, z) do
    identity()
    |> Map.put({0, 0}, x)
    |> Map.put({1, 1}, y)
    |> Map.put({2, 2}, z)
  end

  def rotate_x(degrees) do
    radians = degress_to_radians(degrees)
    identity()
    |> Map.put({1, 1}, :math.cos(radians))
    |> Map.put({2, 1}, -:math.sin(radians))
    |> Map.put({1, 2}, :math.sin(radians))
    |> Map.put({2, 2}, :math.cos(radians))
  end

  def rotate_y(degrees) do
    radians = degress_to_radians(degrees)
    identity()
    |> Map.put({0, 0}, :math.cos(radians))
    |> Map.put({2, 0}, :math.sin(radians))
    |> Map.put({0, 2}, -:math.sin(radians))
    |> Map.put({2, 2}, :math.cos(radians))
  end

  def rotate_z(degrees) do
    radians = degress_to_radians(degrees)
    identity()
    |> Map.put({0, 0}, :math.cos(radians))
    |> Map.put({1, 0}, -:math.sin(radians))
    |> Map.put({0, 1}, :math.sin(radians))
    |> Map.put({1, 1}, :math.cos(radians))
  end

  def shear(xy, xz, yx, yz, zx, zy) do
    identity()
    |> Map.put({1, 0}, xy)
    |> Map.put({2, 0}, xz)
    |> Map.put({0, 1}, yx)
    |> Map.put({2, 1}, yz)
    |> Map.put({0, 2}, zx)
    |> Map.put({1, 2}, zy)
  end

  defp i_to_xy(i) do
    y = div(i, 4)
    x = rem(i, 4)
    {x, y}
  end

  defp degress_to_radians(degrees) do
    degrees / 180 * :math.pi
  end
end
