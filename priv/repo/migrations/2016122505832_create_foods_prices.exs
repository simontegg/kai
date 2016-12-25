defmodule Kai.Repo.Migrations.CreateFoodsPrices do
  use Ecto.Migration

  def change do
    create table(:foods_prices) do
      add :food_id, references(:foods)
      add :price_id, references(:prices)

      timestamps()
    end

  end
end
