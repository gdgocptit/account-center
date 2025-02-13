defmodule AccountCenterWeb.UsersController do
  use AccountCenterWeb, :controller

  alias AccountCenter.User
  alias AccountCenter.Repo

  def login(conn, _params) do
    opts = %{page_title: "Login"}
    render(conn, :login, opts)
  end

  def create_session(conn, %{"session" => session_params}) do
    {user, credentials_status} = try_authenticate!(session_params)
    if credentials_status do
      conn |> put_session(:current_user, user) |> put_flash(:info, "Welcome back! #{user.name} !") |> redirect(to: get_session(conn, :referer_path) || ~p"/")
    else
      conn |> put_flash(:error, "Invalid credentials !") |> render(:login)
    end
  end

  defp try_authenticate!(session_params) do
    downcase_email = session_params["email"] |> String.downcase
    user = Repo.get_by(User, email: downcase_email)

    {user, Argon2.verify_pass(session_params["password"], user.password_digest)}
  end
end
