defmodule PLWeb.RegistrationView do
  use PLWeb, :view
  import Plug.Conn

  def magic_token(conn) do
    get_session(conn, :magic_token)
  end
end
