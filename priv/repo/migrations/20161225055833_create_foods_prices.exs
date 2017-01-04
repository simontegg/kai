defmodule Kai.Repo.Migrations.CreateFoodPrices do
  use Ecto.Migration

  def change do
    create table(:food_prices) do
      add :food_id, references(:foods)
      add :price_id, references(:prices)
      add :conversion_id, references(:conversions)

      timestamps()
    end

  end
end
