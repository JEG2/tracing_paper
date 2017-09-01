defmodule TracingPaper.Assertions do
  def assert_close_to_tuple({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    ExUnit.Assertions.assert_in_delta x1, x2, 0.0001
    ExUnit.Assertions.assert_in_delta y1, y2, 0.0001
    ExUnit.Assertions.assert_in_delta z1, z2, 0.0001
    ExUnit.Assertions.assert_in_delta w1, w2, 0.0001
  end

  def assert_close_to_matrix(matrix1, matrix2) do
    Enum.each(0..3, fn y ->
      Enum.each(0..3, fn x ->
        ExUnit.Assertions.assert_in_delta(
          TracingPaper.Matrix.at(matrix1, x, y),
          TracingPaper.Matrix.at(matrix2, x, y),
          0.0001
        )
      end)
    end)
  end

  def assert_close_to_color({r1, g1, b1}, {r2, g2, b2}) do
    ExUnit.Assertions.assert_in_delta r1, r2, 0.0001
    ExUnit.Assertions.assert_in_delta g1, g2, 0.0001
    ExUnit.Assertions.assert_in_delta b1, b2, 0.0001
  end
end

ExUnit.start()
