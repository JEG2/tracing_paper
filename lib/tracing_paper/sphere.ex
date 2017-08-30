defmodule TracingPaper.Sphere do
  defstruct ~w[origin radius transformation]a

  alias TracingPaper.{Matrix, Point}

  def new(
    origin         \\ Point.new(0, 0, 0),
    radius         \\ 1,
    transformation \\ Matrix.identity
  ) do
    %__MODULE__{
      origin:         origin,
      radius:         radius,
      transformation: transformation
    }
  end

  def transform(sphere, transformation) do
    %__MODULE__{sphere | transformation: transformation}
  end
end
