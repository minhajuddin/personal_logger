defmodule PLWeb.SessionController do
  use PLWeb, :controller
  alias PL.Accounts

  def new(conn, _params) do
    render(conn, [])
  end

  def create(conn, %{"sign_in" => %{"magic_token" => magic_token}}) do
    with {:ok, validated_magic_token} <- PLWeb.MagicToken.decode(magic_token),
         user when not is_nil(user) <- Accounts.find_user_by_magic_token(validated_magic_token) do
      conn
      |> put_flash(:info, "Signed in successfully.")
      |> configure_session(renew: true)
      |> clear_session()
      |> put_session(:magic_token, Accounts.magic_token(user))
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
