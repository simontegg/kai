defmodule Kai.Repo.Migrations.CreateFoods do
  use Ecto.Migration

  def change do
    create table(:nutrition) do
      add :data_source_id, :string  
      add :name, :string
      add :data_source, :string
      add :category, :string
      add :edible_portion, :float
      
      add :calories, :float
      add :protein, :float

      add :folate_dfe, :float
      add :biotin, :float
      add :calcium, :float
      add :cholesterol, :float
      add :choline, :float
      add :chromium, :float
      add :copper, :float
      add :fat_total, :float
      add :o3_epa, :float
      add :o3_dha, :float
      add :o3_dpa, :float
      add :iodine, :float
      add :iron, :float
      add :lithium, :float
      add :magnesium, :float
      add :manganese, :float
      add :mercury, :float
      add :molybdenum, :float
      add :niacin_ne, :float
      add :pantothenic_acid, :float
      add :phosphorus, :float
      add :potassium, :float
      add :riboflavin, :float
      add :selenium, :float
      add :thiamin, :float
      add :vitamin_a_rae, :float
      add :vitamin_b12, :float
      add :vitamin_b6, :float
      add :vitamin_c, :float
      add :vit_e_a_tocopherol, :float
      add :vitamin_k1, :float
      add :zinc, :float

      timestamps()
    end

  end
end
