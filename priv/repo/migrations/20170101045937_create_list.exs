defmodule Kai.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :user_id, references(:users, on_delete: :nothing)
      add :foods, references(:foods)

      timestamps()
    end
    create index(:lists, [:user_id])

  end
end
