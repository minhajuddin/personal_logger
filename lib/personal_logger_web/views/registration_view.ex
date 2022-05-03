defmodule PLWeb.RegistrationView do
  use PLWeb, :view
  import Plug.Conn

  def connect_key(conn) do
    get_session(conn, :connect_key)
  end
end
