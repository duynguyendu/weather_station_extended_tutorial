
defmodule WeatherStationApp do
  @moduledoc """
  Documentation for `WeatherStation`.
  """

  def start(_type, _args) do
    hello()
    {:ok, self()}
  end

  @doc """
  Hello world.

  ## Examples

      iex> WeatherStation.hello()
      :world

  """
  def hello do
    IO.puts("hello weather_station")
    :world
  end
end
