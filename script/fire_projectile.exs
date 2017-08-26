defmodule Projectile do
  defstruct ~w[position velocity]a

  def new(position, velocity) do
    %__MODULE__{position: position, velocity: velocity}
  end
end

defmodule World do
  defstruct ~w[gravity wind]a

  def new(gravity, wind) do
    %__MODULE__{gravity: gravity, wind: wind}
  end
end

defmodule Simulation do
  alias TracingPaper.HomogeneousCoordinate, as: Coord

  def tick(
    %World{gravity: gravity, wind: wind},
    %Projectile{position: position, velocity: velocity}
  ) do
    Projectile.new(
      Coord.add(position, velocity),
      Coord.add(velocity, Coord.add(gravity, wind))
    )
  end

  def run(world, %Projectile{position: {_x, y, _z, _w}} = projectile, count)
  when count == 0 or y > 0 do
    IO.puts "Position:  #{inspect projectile}."
    run(world, tick(world, projectile), count + 1)
  end
  def run(_world, _projectile, count) do
    IO.puts "Impact in #{count} ticks."
  end
end

alias TracingPaper.{Point, Vector}
alias TracingPaper.HomogeneousCoordinate, as: Coord

position   = Point.new(0, 0, 0)
velocity   = Vector.new(1, 1, 0) |> Coord.normalize
projectile = Projectile.new(position, velocity)

gravity = Vector.new(0, -0.1, 0)
wind    = Vector.new(-0.01, 0, 0)
world   = World.new(gravity, wind)

Simulation.run(world, projectile, 0)
