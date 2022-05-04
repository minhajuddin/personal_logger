defmodule PLWeb.API.LogController do
  use PLWeb, :controller

  alias PL.Logs
  require Logger
  import PLWeb.Plugs.AuthenticateUser, only: [connect_key: 1]

  def index(conn, _params) do
    connect_key = connect_key(conn)
    entries = Logs.list_entries(connect_key)

    send_resp(
      conn,
      :ok,
      entries
      |> Enum.map(fn x ->
        x
        |> Map.from_struct()
        |> Map.take(~w[id body inserted_at updated_at]a)
      end)
      |> Jason.encode!()
    )
  end

  def create(conn, params) do
    connect_key = connect_key(conn)
    Logs.create_entry(params["log"], connect_key)
    send_resp(conn, :created, "{}")
  end
end
