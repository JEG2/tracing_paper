alias TracingPaper.{Matrix, Point}

Stream.iterate(Point.new(0, 1, 0), fn point ->
  Matrix.rotate_z(-360 / 12)
  |> Matrix.multiply(point)
end)
|> Stream.with_index
|> Stream.drop(1)
|> Enum.take(12)
|> Enum.each(fn {{x, y, z, _w}, n} ->
  :io.format("~2B:  ~.2f,~.2f,~.2f~n", [n] ++ Enum.map([x, y, z], &(&1 / 1)))
end)
