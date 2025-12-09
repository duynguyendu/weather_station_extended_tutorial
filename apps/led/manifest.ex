

defmodule Led do
  @behaviour KosManifest.App
  alias KosManifest.{Context, AccessControl}
  alias KosManifestSystems.Poukai

  @impl true
  @spec setup(Context.t(), Keyword.t()) :: {:ok, Context.t()} | {:error, any}
  def setup(context, opts \\ []) do

    # Add additional device resources or register clock/pinmux setups if required.
    msg_server = Keyword.get(opts, :msg_server, Poukai.msg_server())
    log_port = Keyword.get(opts, :log_port, "kos_log_protocol")
    internet_port = Keyword.get(opts, :internet_port, "kos_internet_protocol")

    disable_internet = Keyword.get(opts, :disable_internet, true)

    dir_access_control = %{
      log_port => AccessControl.client(),
      "led_protocol" => AccessControl.server()
    }
    dir_access_control = if disable_internet, do: dir_access_control, else: Map.put(dir_access_control, internet_port, AccessControl.client())

    # Set any environment variables you want your app to use for configuration here
    environ = %{
      # "KEY" => "value"
    }

    led_binary = Path.join([Mix.Project.build_path(), "lib", "system", "cmake", "apps", "led", "led"])
    led_binary = if File.exists?(led_binary) do
      led_binary
    else
      Path.join([Mix.Project.build_path(), "lib", "led", "cmake", "led", "led"])
    end
    led = %{
      name: "led",
      binary: led_binary,
      heap_pages: 10,
      ut_large_pages: 10,
      ut_4k_pages: 10,
      max_priority: 150,
      priority: 145,
      environ: environ,
      msg_servers: [
        %{
          name: msg_server,
          dir_access_control: dir_access_control
        }
      ]
    }

    context = context
    |> Context.put_app!(led)

    {:ok, led, context}
  end
end
