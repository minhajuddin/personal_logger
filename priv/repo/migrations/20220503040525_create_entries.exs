defmodule PL.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :text
      add :user_id, references("users", type: :uuid)

      timestamps()
    end
  end
end
