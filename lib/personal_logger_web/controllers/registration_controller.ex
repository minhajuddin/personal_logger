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
        |> put_session(:magic_token, Accounts.magic_token(user))
        |> redirect(to: Routes.registration_path(conn, :show))

      {:error, changeset} ->
        conn
        |> put_view(PLWeb.PageView)
        |> render("index.html", page_title: "Home", user_changeset: changeset)
    end
  end
end
