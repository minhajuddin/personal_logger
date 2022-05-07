defmodule PLWeb.UserAuth do
  @moduledoc """
  Provides functions to help with auth in the web layer 
  """
  import Plug.Conn

  def user_signed_in?(conn) do
    !!get_session(conn, :magic_token)
  end
end
