defmodule AccountCenterWeb.UsersController do
  use AccountCenterWeb, :controller

  def login(conn, _params) do
    opts = %{page_title: "Login"}
    render(conn, :login, opts)
  end
end
