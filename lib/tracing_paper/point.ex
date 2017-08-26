defmodule TracingPaper.Point do
  def new(x, y, z), do: {x, y, z, 1}

  def valid?({_x, _y, _z, 1}), do: true
  def valid?(_non_point),      do: false
end
