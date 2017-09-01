defmodule TracingPaper.Color do
  def new(r, g, b), do: {r, g, b}

  def add({r1, g1, b1}, {r2, g2, b2}) do
    {r1 + r2, g1 + g2, b1 + b2}
  end

  def subtract({r1, g1, b1}, {r2, g2, b2}) do
    {r1 - r2, g1 - g2, b1 - b2}
  end

  def multiply(n, t)
  when is_number(n) and is_tuple(t) and tuple_size(t) == 3 do
    multiply(t, n)
  end
  def multiply({r, g, b}, n) when is_number(n) do
    {r * n, g * n, b * n}
  end
  def multiply({r1, g1, b1}, {r2, g2, b2}) do
    {r1 * r2, g1 * g2, b1 * b2}
  end
end
