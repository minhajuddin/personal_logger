defmodule PLWeb.LogController do
  use PLWeb, :controller

  alias PL.Accounts
  require Logger
  import PLWeb.Plugs.AuthenticateUser, only: [connect_key: 1]

  def index(conn, params) do
    {:ok, {user_id, _}} = connect_key(conn) |> PLWeb.MagicToken.decode
    entries = Logs.list_entries(connect_key)
    render(conn, "index.html")
  end

end
