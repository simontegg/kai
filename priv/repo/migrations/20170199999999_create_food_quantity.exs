defmodule Kai.Repo.Migrations.CreateQuantities do
  use Ecto.Migration

  def change do
    create table(:quantities) do
      add :quantity, :integer
      add :cost, :integer
      add :nutrition_price_id, references(:nutrition_prices, on_delete: :nothing)
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps()
    end
    create index(:quantities, [:nutrition_price_id])
    create index(:quantities, [:list_id])

  end
end
