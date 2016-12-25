defmodule Kai.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :company_id, :string
      add :user_id, :string
      add :food_description, :string
      add :currency, :string
      add :currency_unit, :string #cents
      add :price, :float
      add :quantity_unit, :string

      timestamps()
    end

  end
end
