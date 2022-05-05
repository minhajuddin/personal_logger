defmodule PLWeb.PageController do
  use PLWeb, :controller

  alias PL.Accounts

  def index(conn, _params) do
    connect_key = get_session(conn, :connect_key)

    if connect_key do
      redirect(conn, to: Routes.log_path(conn, :index))
    else
      render(conn, "index.html", page_title: "Home", user_changeset: Accounts.new_user_changeset())
    end
  end
end
