defmodule TracingPaper.Intersection do
  defstruct ~w[t object inside?]a

  def new(t, object, inside?) do
    %__MODULE__{t: t, object: object, inside?: inside?}
  end

  def hit(intersections) do
    intersections
    |> Enum.sort_by(fn intersection -> intersection.t end)
    |> Enum.find(fn intersection -> intersection.t > 0 end)
  end
end
