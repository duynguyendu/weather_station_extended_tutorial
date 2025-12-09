
defmodule WeatherStationManifest do
  alias KosManifestSystems.Poukai
  alias Kos.Tunnel
  import KosManifest.Context

  @behaviour KosManifest.System

  @impl true
  def setup(context) do
    # This sets up the base Poukai system with the default settings
    # so that our apps can use basic services (such as internet, keys and rng)
    {:ok, context} =
      Poukai.setup(
        context,
        Poukai.default_settings(tunnel_ips_csv: Path.join([__DIR__, "config", "ips.csv"]))
      )

    # Remove this line when you want to enforce signed upgrades
    # See `mix help kos.manifest.sign` for commands for signing a manifest.
    {:ok, context} = set_kos_options(context, %{disable_signing: true})

    {:ok, context} = put_port(context, "led_protocol", Poukai.msg_server())

    # Automatically include all apps in the apps/ folder when they have an
    # apps/<app_name>/package/manifest.ex layout.
    # &module_opts/1 passes our local module_opts function defined below in
    # case we want to pass specific settings to one or more apps.
    context = KosManifest.System.automatically_include_apps_directory!(context, __DIR__, &module_opts/1)

    # Add new external applications here:
    # {:ok, context, _} = put_app(context, MyApp)

    # Checks to make sure that each app has valid KOS tunnel IP configurations
    {:ok, context} = Tunnel.check_tunnel_ips(context)

    {:ok, context}
  end

  # By default, all apps have default option settings applied (as defined in their manifests). To pass specific
  # option settings to an app, add another function before `defp module_opts(_module)` that pattern
  # matches the app name and specifies the desired option settings.
  # EG
  # defp module_opts(MyApp), do: [some_app_option: value]
  defp module_opts(_module), do: []
end
