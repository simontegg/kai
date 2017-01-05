defmodule Kai.Repo.Migrations.CreateFoodQuantities do
  use Ecto.Migration

  def change do
    create table(:food_quantities) do
      add :quantity, :integer
      add :food_price_id, references(:food_prices, on_delete: :nothing)
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps()
    end
    create index(:food_quantities, [:food_price_id])
    create index(:food_quantities, [:list_id])

  end
end
