defmodule AccountCenter.ApplicationHelper do
  import Plug.Conn

  def current_user(conn) do
    conn |> get_session(:current_user)
  end

  def user_logged_in?(conn) do
    !!current_user(conn)
  end
end
