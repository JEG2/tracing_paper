defmodule TracingPaper.Canvas do
  # require Color
  alias TracingPaper.Color

  @black Color.new(0, 0, 0)
  defstruct width:         nil,
            height:        nil,
            pixels:        Map.new,
            default_color: @black,
            colors:        MapSet.new([@black])

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end

  def pixel(%__MODULE__{width: width, height: height} = canvas, x, y)
  when x >= 0 and x < width and y >= 0 and y < height do
    Map.get(canvas.pixels, {x, y}, canvas.default_color)
  end

  def draw(%__MODULE__{width: width, height: height} = canvas, x, y, color)
  when x >= 0 and x < width and y >= 0 and y < height do
    %__MODULE__{
      canvas |
      pixels: Map.put(canvas.pixels, {x, y}, color),
      colors: MapSet.put(canvas.colors, color)
    }
  end

  def to_png(canvas, path) do
    image     = :egd.create(canvas.width, canvas.height)
    color_map = Enum.into(canvas.colors, Map.new, fn color ->
      {color, :egd.color(color_to_bytes(color))}
    end)
    Enum.each(0..(canvas.height - 1), fn y ->
      Enum.each(0..(canvas.width - 1), fn x ->
        point     = {x, y}
        color     = pixel(canvas, x, y)
        color_ref = Map.fetch!(color_map, color)
        :ok       = :egd.line(image, point, point, color_ref)
      end)
    end)
    image
    |> :egd.render
    |> :egd.save(String.to_charlist(path))
  end

  defp color_to_bytes({r, g, b}) do
    {to_byte(r * 255), to_byte(g * 255), to_byte(b * 255)}
  end

  defp to_byte(n) when n <   0, do: 0
  defp to_byte(n) when n > 255, do: 255
  defp to_byte(n),              do: n
end
