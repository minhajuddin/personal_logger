defmodule PLWeb.PageController do
  use PLWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
