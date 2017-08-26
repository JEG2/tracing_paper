defmodule TracingPaper.Vector do
  def new(x, y, z), do: {x, y, z, 0}

  def valid?({_x, _y, _z, 0}), do: true
  def valid?(_non_vector),     do: false
end
