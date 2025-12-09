
defmodule WeatherStationManifest.MixProject do
  use Mix.Project

  def project do
    [
      app: :system,
      elixirc_paths: ["system.ex"],
      compilers: [:elixir_make, :cmake] ++ Mix.compilers(),
      version: "0.1.0",
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases do
    []
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :kos_manifest],
    ]
  end

  # kos_manifest_systems contains the libraries required for defining a KOS system.
  # elixir_make and elixir_cmake enable building Elixir/C applications using the KOS compilers
  defp deps do
    kos_builtins = System.get_env("KOS_BUILTINS_PATH", "KOS_BUILTINS_PATH-NOTFOUND")
    [
      {:kos_manifest_systems, path: Path.join(kos_builtins, "kos_manifest_systems")},
      {:elixir_make, "~> 0.6", runtime: false},
      {:elixir_cmake, "~> 0.8.0", runtime: false},
    ]
  end
end
