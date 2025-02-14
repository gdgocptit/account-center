defmodule AccountCenterWeb.Users.LoginLive do
  use AccountCenterWeb, :live_view
  use AccountCenterWeb, :verified_routes

  alias AccountCenter.User
  alias AccountCenter.Repo

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Login")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-sm">
        <img class="mx-auto h-10 w-auto" src={~p"/images/logo.png"} />
        <h2 class="mt-6 text-center text-2xl/9 font-bold tracking-tight text-gray-900">
          Sign in to your account
        </h2>
      </div>
      <div class="mt-6 sm:mx-auto sm:w-full sm:max-w-sm">
        <!-- action={~p"/users/login"} method="POST" -->
        <form phx-submit="perform_session" class="space-y-6">
          <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
          <div>
            <label for="email" class="block text-sm/6 font-medium text-gray-900">Email address</label>
            <div class="mt-2">
              <input
                type="email"
                name="session[email]"
                id="email"
                autocomplete="email"
                required
                class="block w-full rounded-lg bg-gray-100 hover:bg-gray-200 px-4 py-2 text-base text-gray-900 placeholder:text-gray-400 sm:text-sm/6 border-none outline-none focus:border-none focus:outline-none focus:ring-0"
              />
            </div>
          </div>

          <div>
            <div class="flex items-center justify-between">
              <label for="password" class="block text-sm/6 font-medium text-gray-900">Password</label>
              <div class="text-sm">
                <a
                  href="#"
                  class="font-semibold text-brand hover:text-brand hover:underline hover:underline-offset-2"
                >
                  Forgot password?
                </a>
              </div>
            </div>
            <div class="mt-2">
              <input
                type="password"
                name="session[password]"
                id="password"
                autocomplete="current-password"
                required
                class="block w-full rounded-lg bg-gray-100 hover:bg-gray-200 px-4 py-2 text-base text-gray-900 placeholder:text-gray-400 sm:text-sm/6 border-none outline-none focus:border-none focus:outline-none focus:ring-0"
              />
            </div>
          </div>

          <div>
            <input
              phx-submit="perform_session"
              type="submit"
              class="shadow-lg shadow-brand/45 flex w-full justify-center rounded-lg bg-brand px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand"
              value="Sign in"
            />
          </div>
        </form>

        <p class="mt-6 text-center text-sm/6 text-gray-500">
          <a href="#" class="font-semibold text-brand hover:underline hover:underline-offset-2">
            How can I get an account?
          </a>
        </p>
      </div>
    </div>
    """
  end

  def handle_event("perform_session", %{"session" => session_params}, socket) do
    auth_stat = try_authenticate(session_params)
    case auth_stat do
      {:noop, _} ->
        {:noreply, put_flash(socket, :error, "Invalid credentials. Please double-check your information and try again.")}
      {:ok, user} ->
        {:noreply, put_flash(socket, :info, "Logged in.")}
    end
  end

  defp try_authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)

    try_verify_password(user, password)
  end

  defp try_verify_password(nil, _) do
    {:noop, nil}
  end

  defp try_verify_password(user, password) do
    if Argon2.verify_pass(password, user.password_digest) do
      {:ok, user}
    else
      {:noop, user}
    end
  end
end
