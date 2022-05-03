defmodule PLWeb.RegistrationController do
  use PLWeb, :controller

  def create(conn, %{"user" => %{"email" => email}}) do
    render(conn, "index.html", page_title: "Home")
  end
end
