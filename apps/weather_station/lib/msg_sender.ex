defmodule WeatherStationApp.MsgServer do
  @protocol "led_protocol"

  @led_call_on 2 # have the same value as enum led_protocol in LED app
  @led_call_off 3
  require Logger

  import K10.MsgServer

  def setup() do
    Logger.info("Initializing message server for weather station app")
    :kos_status_ok = wait_for_port(@protocol)

    Logger.info("Alloc token slot")
    {:kos_status_ok, token} = kos_msg_token_slot_pool_alloc()
    request_msg = kos_msg_new(0, 0, 0, "")

    Logger.info("Request protocol")
    {:kos_status_ok, response_msg} = kos_dir_request(@protocol, token, K10.MsgServer.kos_msg_flag_send_token(), request_msg)

    Logger.info("connected to server port #{inspect(@protocol)}")
    Logger.info("received response: #{inspect(response_msg)}")

    msg = kos_msg_new(@led_call_on, 0, token, "")

    {:kos_status_ok, response_msg} = kos_msg_call(token, K10.MsgServer.kos_msg_flag_send_payload(), msg)

    Logger.info("called server: led_call_on")
    Logger.info("received response: #{inspect(response_msg)}")
    Logger.info("result status: #{inspect(kos_msg_label(response_msg))}")
    Logger.info("result string: #{inspect(kos_msg_payload(response_msg))}")

    msg = kos_msg_new(@led_call_off, 0, token, "")

    {:kos_status_ok, response_msg} = kos_msg_call(token, K10.MsgServer.kos_msg_flag_send_payload(), msg)
    
    Logger.info("received response: #{inspect(response_msg)}")
    Logger.info("result status: #{inspect(kos_msg_label(response_msg))}")
    Logger.info("result string: #{inspempty_tokenect(kos_msg_payload(response_msg))}")
  end

  defp wait_for_port(port) do
    unless kos_dir_query(port) == :kos_status_ok do
      :timer.sleep(1)
      wait_for_port(port)
    end

    :kos_status_ok
  end

  defp kos_msg_label({label, _, _, _}), do: label
  defp kos_msg_param({_, param, _, _}), do: param
  defp kos_msg_token({_, _, token, _}), do: token
  defp kos_msg_payload({_, _, _, payload}), do: payload

end
