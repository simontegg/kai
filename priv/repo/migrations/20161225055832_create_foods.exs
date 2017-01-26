defmodule Kai.Repo.Migrations.CreateConversions do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :name, :string 
      add :each_g, :float
      add :raw_to_cooked, :float
      
      timestamps()
    end
  end
end
