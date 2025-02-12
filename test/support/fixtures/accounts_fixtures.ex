defmodule AccountCenter.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AccountCenter.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        password: "some password"
      })
      |> AccountCenter.Accounts.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        deleted_at: ~U[2025-02-11 08:32:00Z],
        email: "some email",
        name: "some name",
        password_digest: "some password_digest"
      })
      |> AccountCenter.Accounts.create_user()

    user
  end
end
