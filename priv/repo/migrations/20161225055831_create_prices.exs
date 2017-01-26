defmodule Kai.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :user_id, references(:users)
      #      add :nutrition_price_id, references(:foods_prices)
      add :name, :string
      add :price, :float
      add :quantity, :float
      add :quantity_unit, :string
      add :url, :string
      
      add :company_id, :string
      add :currency, :string
      add :currency_unit, :string #cents
      add :longitude, :float
      add :latitude, :float

      timestamps()
    end

  end
end
