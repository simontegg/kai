defmodule Kai.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)
      
      timestamps()
    end

  end
end
