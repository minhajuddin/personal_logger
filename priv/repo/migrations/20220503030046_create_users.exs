defmodule PL.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION citext", "DROP EXTENSION citext"

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :api_key, :uuid

      timestamps()
    end

    create index(:users, [:email], unique: true)
    create index(:users, [:api_key], unique: true)
  end
end
