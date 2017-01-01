defmodule Kai.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name,              :string
      add :age,               :integer
      add :weight,            :integer
      add :height,            :integer
      add :activity,          :integer
      add :sex,               :string
      add :email,             :string
      add :access_token,      :string
    
      add :calories,          :integer
      add :protein,           :integer
      
      #vitamin sufficiency
      add :biotin,            :float
      add :folate_dfe,        :float
      add :niacin_ne,         :float
      add :pantothenic_acid,  :float
      add :riboflavin,        :float
      add :thiamin,           :float
      add :vitamin_a,         :float
      add :vitamin_b6,        :float
      add :vitamin_b12,       :float
      add :vitamin_c,         :float
      add :vit_e_a_tocopherol,:float 
      add :vitamin_k1,        :float 

      #mineral sufficiency
      add :calcium,           :float
      add :chromium,          :float
      add :copper,            :float
      add :iodine,            :float
      add :iron,              :float
      add :magnesium,         :float
      add :manganese,         :float
      add :molybdenum,        :float
      add :phosphorus,        :float
      add :potassium,         :float
      add :selenium,          :float
      add :zinc,              :float

      timestamps()
    end

    create unique_index(:users, [:access_token])
    create unique_index(:users, [:email])
  end
end
