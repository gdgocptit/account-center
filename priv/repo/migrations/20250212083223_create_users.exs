defmodule AccountCenter.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :password_digest, :string
      add :deleted_at, :utc_datetime, default: nil

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:email], unique: true)
    create index(:users, :deleted_at)
  end
end
