defmodule CanvasTest do
  use ExUnit.Case, async: true

  alias TracingPaper.{Canvas, Color}

  test "has a width and height" do
    width  = 20
    height = 10
    canvas = Canvas.new(width, height)
    assert canvas.width  == width
    assert canvas.height == height
  end

  test "defaults pixels to black" do
    canvas = Canvas.new(20, 10)
    black  = Color.new(0, 0, 0)
    Enum.each(0..9, fn y ->
      Enum.each(0..19, fn x ->
        assert Canvas.pixel(canvas, x, y) == black
      end)
    end)
  end

  test "supports drawing pixels" do
    red    = Color.new(1, 0, 0)
    canvas =
      Canvas.new(20, 10)
      |> Canvas.draw(2, 3, red)
    drawn  = Canvas.pixel(canvas, 2, 3)
    assert drawn == red
  end

  test "writes PNG files" do
    canvas =
      Canvas.new(5, 3)
      |> Canvas.draw(0, 0, Color.new(1.5, 0, 0))
      |> Canvas.draw(2, 1, Color.new(0, 0.5, 0))
      |> Canvas.draw(4, 2, Color.new(-0.5, 0, 1))
    path   = "test.png"

    File.cd!(__DIR__, fn ->
      if File.exists?(path) do
        File.rm(path)
      end

      assert !File.exists?(path)
      Canvas.to_png(canvas, path)
      assert File.exists?(path)

      File.rm(path)
    end)
  end
end
