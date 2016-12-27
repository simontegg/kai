defmodule Kai.Repo.Migrations.CreateConversions do
  use Ecto.Migration

  def change do
    create table(:conversions) do
      add :food_price_id, references(:foods_prices)
      add :each_to_g, :float
      add :raw_to_cooked, :float
      add :edible_portion, :float
      
      timestamps()
    end
  end
end
