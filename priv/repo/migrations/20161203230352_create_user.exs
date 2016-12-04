defmodule Kai.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      add :weight, :integer
      add :activity, :string
      add :sex, :string

      timestamps()
    end

  end
end
