defmodule PLWeb.Plugs.AuthenticateUser do
  require Logger
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    ["Bearer " <> connect_key] = get_req_header(conn, "authorization")
    put_private(conn, :connect_key, connect_key)
  end

  def connect_key(conn) do
    conn.private[:connect_key]
  end
end
