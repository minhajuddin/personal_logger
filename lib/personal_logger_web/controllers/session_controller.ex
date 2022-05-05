defmodule PLWeb.SessionController do
  use PLWeb, :controller

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> configure_session(renew: true)
    |> clear_session()
    |> redirect(to: "/")
  end
end
