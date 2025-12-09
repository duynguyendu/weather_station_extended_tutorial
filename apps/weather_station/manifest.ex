

defmodule WeatherStation do
  @behaviour KosManifest.App
  import Bitwise
  alias KosManifest.{Context, AccessControl}
  alias Kos.Constants
  alias KosManifestSystems.Poukai

  @impl true
  @spec setup(Context.t(), Keyword.t()) :: {:ok, KosManifest.App.t(), Context.t()} | {:error, any}
  def setup(context, opts \\ []) do

    # Add additional device resources or register clock/pinmux setups if required.
    msg_server = Keyword.get(opts, :msg_server, Poukai.msg_server())
    rng_port = Keyword.get(opts, :rng_port, "kos_rng_protocol")
    log_port = Keyword.get(opts, :log_port, "kos_log_protocol")
    internet_port = Keyword.get(opts, :internet_port, "kos_internet_protocol")
    binary_path = Mix.Project.build_path()

    beam_path = Path.join(binary_path, "beam.smp")
    vdso_path = Path.join(binary_path, "libweather_station_vdso.so")
    weather_station = %{
      name: "weather_station",
      priority: 145,
      max_priority: 150,
      binary: beam_path,
      vdso: vdso_path,
      # 64 Mebibytes of small pages
      heap_pages: 64 * (1 <<< (20 - Constants.page_bits(context.platform))),
      # 2 Mebibytes of large pages
      ut_large_pages: div(2 * (1 <<< 20), 1 <<< Constants.large_page_bits(context.platform)),
      ut_4k_pages: 32,
      arguments: Constants.default_beam_arguments(),
      environ: Constants.default_beam_environ(),
      msg_servers: [
        %{
          name: msg_server,
          dir_access_control: %{
            rng_port => AccessControl.client(),
            log_port => AccessControl.client(),
            internet_port => AccessControl.client(),
            "led_protocol" => AccessControl.client()
          }
        }
      ]
    }

    {:ok, context, weather_station} = Context.put_app(context, weather_station)

    {:ok, weather_station, context}
  end
end
