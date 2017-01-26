defmodule Kai.Repo.Migrations.CreateNutritionPrices do
  use Ecto.Migration

  def change do
    create table(:nutrition_prices) do
      add :nutrition_id, references(:nutrition)
      add :price_id, references(:prices)

      timestamps()
    end

  end
end
