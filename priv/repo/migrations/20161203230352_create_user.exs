defmodule Kai.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      add :weight, :integer
      add :height, :integer
      add :activity, :string
      add :sex, :string
      add :email, :string
      add :access_token, :string
    
      #vitamin sufficiency
      add :biotin_ai, :float
      add :folate_dfe_rda, :float
      add :niacin_ne_rda, :float

      add :calories, :integer


      timestamps()
    end

    create unique_index(:users, [:access_token])
    create unique_index(:users, [:email])
  end
end
