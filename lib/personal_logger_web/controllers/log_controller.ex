defmodule PLWeb.LogController do
  use PLWeb, :controller

  alias PL.Accounts
  require Logger
  import PLWeb.Plugs.AuthenticateUser, only: [magic_token: 1]

  def index(conn, params) do
    {:ok, {user_id, _}} = magic_token(conn) |> PLWeb.MagicToken.decode()
    entries = Logs.list_entries(magic_token)
    render(conn, "index.html")
  end
end
