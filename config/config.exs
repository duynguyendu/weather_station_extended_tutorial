
import Config

# WARNING: this MUST only be set to true for development devices
# Ensure it is removed or set to false before building the release for
# production devices.
config :kos_manifest, insecure_remote_iex_enabled: false

config :kos_manifest, default_module: WeatherStationManifest
