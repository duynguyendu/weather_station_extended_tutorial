
defmodule WeatherStationApp do
  @moduledoc """
  Documentation for `WeatherStation`.
  """
  alias WeatherStationApp.MsgServer
  require Logger

  def start(_type, _args) do
    hello()
    MsgServer.setup()
    {:ok, self()}
  end

  @doc """
  Hello world.

  ## Examples

      iex> WeatherStation.hello()
      :world

  """
  def hello do
    Logger.info("hello weather_station")
    :world
  end
end
