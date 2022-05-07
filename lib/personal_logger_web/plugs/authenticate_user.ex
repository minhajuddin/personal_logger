defmodule PLWeb.Plugs.API.AuthenticateUser do
  require Logger
  import Plug.Conn

  # TODO: This should really authenticate the user and put the user's struct
  # in the conn.private and not just decode the magic_token

  def init(opts), do: opts

  def call(conn, _opts) do
    ["Bearer " <> magic_token] = get_req_header(conn, "authorization")
    put_private(conn, :magic_token, magic_token)
  end

  def magic_token(conn) do
    conn.private[:magic_token]
  end
end

defmodule PLWeb.Plugs.AuthenticateUser do
  require Logger
  import Plug.Conn
  import Phoenix.Controller

  # TODO: This should really authenticate the user and put the user's struct
  # in the conn.private and not just decode the magic_token

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:magic_token, magic_token} when not is_nil(magic_token) <-
           {:magic_token, get_session(conn, :magic_token)},
         {:decode, {:ok, {_id, _api_key}}} <- {:decode, PLWeb.MagicToken.decode(magic_token)} do
      conn
    else
      {:magic_token, _} ->
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

  def magic_token(conn) do
    conn.private[:magic_token]
  end
end
