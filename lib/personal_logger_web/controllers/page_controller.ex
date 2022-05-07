defmodule PLWeb.PageController do
  use PLWeb, :controller

  alias PL.Accounts

  def index(conn, _params) do
    magic_token = get_session(conn, :magic_token)

    if magic_token do
      redirect(conn, to: Routes.log_path(conn, :index))
    else
      render(conn, "index.html", page_title: "Home", user_changeset: Accounts.new_user_changeset())
    end
  end
end
