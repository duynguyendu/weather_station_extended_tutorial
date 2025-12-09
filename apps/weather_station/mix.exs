defmodule WeatherStation.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather_station,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [
        weather_station: [
          include_erts: include_erts()
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {WeatherStationApp, []},
      extra_applications: [:logger]
    ]
  end

  # For overriding a different erlang installation when performing a release
  defp include_erts do
    case System.get_env("ERTS_INSTALL_PATH") do
      nil -> false
      path -> path
    end
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    kos_builtins = System.get_env("KOS_BUILTINS_PATH", "KOS_BUILTINS_PATH-NOTFOUND")

    [
      # KOS message server client. If you need to bind a port,
      # replace this with {:k10_msg_server, git: "https://github.com/Kry10-NZ/k10_msg_server"}
      {:k10_msg_server, git: "https://github.com/Kry10-NZ/k10_msg_server"}
      # {:kos_msg, path: Path.join(kos_builtins, "kos_msg_ex")}
      # {:kos_i2c_ex, path: Path.join(kos_builtins, "kos_i2c_ex")},
    ]
  end
end
