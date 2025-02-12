defmodule AccountCenter.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :deleted_at, :utc_datetime, default: nil

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation, :deleted_at])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 256)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_digest, Argon2.Base.hash_password(password, Argon2.Base.gen_salt))
      _ ->
        changeset
    end
  end
end
