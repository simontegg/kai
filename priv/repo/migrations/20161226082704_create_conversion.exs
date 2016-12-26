defmodule Kai.Repo.Migrations.CreateConversion do
  use Ecto.Migration

  def change do
    create table(:conversions) do
      add :price_id, references(:prices)
      add :each_to_g, :float
      add :raw_to_cooked, :float
      add :edible_portion, :float

      timestamps()
    end

  end
end
