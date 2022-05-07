defmodule PLWeb.SessionController do
  use PLWeb, :controller
  alias PL.Accounts

  def new(conn, _params) do
    render conn, []
  end

  def create(conn, %{"sign_in" => %{"connect_key" => connect_key}}) do
    with {:ok, validated_connect_key} <- PLWeb.MagicToken.decode(connect_key),
         user when not is_nil(user) <- Accounts.find_user_by_connect_key(validated_connect_key) do
      conn
      |> put_flash(:info, "Signed in successfully.")
      |> configure_session(renew: true)
      |> clear_session()
      |> put_session(:connect_key, Accounts.connect_key(user))
      |> redirect(to: "/")
    else
      _ ->
        conn
        |> put_flash(:error, "Sign in error.")
        |> redirect(to: "/sign-in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> configure_session(renew: true)
    |> clear_session()
    |> redirect(to: "/")
  end
end
