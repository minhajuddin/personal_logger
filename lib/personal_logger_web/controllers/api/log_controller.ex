defmodule PLWeb.API.LogController do
  use PLWeb, :controller

  alias PL.Logs
  require Logger
  import PLWeb.Plugs.AuthenticateUser, only: [magic_token: 1]

  def index(conn, _params) do
    magic_token = magic_token(conn)
    entries = Logs.list_entries(magic_token)

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
    magic_token = magic_token(conn)
    Logs.create_entry(params["log"], magic_token)
    send_resp(conn, :created, "{}")
  end
end
