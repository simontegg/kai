defmodule Kai.Repo.Migrations.CreateFoodsPrices do
  use Ecto.Migration

  def change do
    create table(:foods_prices) do
      add :food_id, references(:foods)
      add :price_id, references(:prices)
      add :each_to_g, :float
      add :raw_to_cooked, :float
      add :edible_portion, :float


      timestamps()
    end

  end
end
