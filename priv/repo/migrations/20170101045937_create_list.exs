defmodule Kai.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :user_id, references(:users, on_delete: :nothing)
      add :food_quantities, references(:food_quantities)

      timestamps()
    end
    create index(:lists, [:user_id])

  end
end
