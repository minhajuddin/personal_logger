defmodule PLWeb.Plugs.API.AuthenticateUser do
  require Logger
  import Plug.Conn

  # TODO: This should really authenticate the user and put the user's struct
  # in the conn.private and not just decode the connect_key

  def init(opts), do: opts

  def call(conn, _opts) do
    ["Bearer " <> connect_key] = get_req_header(conn, "authorization")
    put_private(conn, :connect_key, connect_key)
  end

  def connect_key(conn) do
    conn.private[:connect_key]
  end
end

defmodule PLWeb.Plugs.AuthenticateUser do
  require Logger
  import Plug.Conn
  import Phoenix.Controller

  # TODO: This should really authenticate the user and put the user's struct
  # in the conn.private and not just decode the connect_key

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:connect_key, connect_key} when not is_nil(connect_key) <-
           {:connect_key, get_session(conn, :connect_key)},
         {:decode, {:ok, {_id, _api_key}}} <- {:decode, PLWeb.MagicToken.decode(connect_key)} do
      conn
    else
      {:connect_key, _} ->
        conn
        |> halt
        |> put_flash(:error, "You must be logged in to access this page.")
        |> redirect(to: "/")

      {:decode, {:error, err}} ->
        Logger.error(error_code: err)

        conn
        |> halt
        |> put_flash(:error, "You must be logged in to access this page.")
        |> redirect(to: "/")
    end
  end

  def connect_key(conn) do
    conn.private[:connect_key]
  end
end
