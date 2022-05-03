defmodule PLWeb.RegistrationController do
  use PLWeb, :controller

  alias PL.Accounts
  require Logger

  def show(conn, params) do
    render(conn, "show.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    case Accounts.create_user(email) do
      {:ok, user} ->
        conn
        |> put_session(:connect_key, Accounts.connect_key(user))
        |> redirect(to: Routes.registration_path(conn, :show))

      {:error, error} ->
        Logger.error(message: "registration_error", error: error)

        conn
        |> send_resp(500, "Error occured")
    end
  end
end
