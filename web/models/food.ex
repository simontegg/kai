defmodule Kai.Food do
  use Kai.Web, :model
  alias Kai.{Price, FoodsPrices}

  @fields [
    :id,
    :name,
    :data_source,
    :category,
    :calories,
    :edible_portion,
    :protein, 
    :folate_dfe, 
    :biotin,
    :calcium,
    :cholesterol,
    :choline,
    :chromium,
    :copper,
    :fat_total,
    :o3_epa,
    :o3_dha,
    :o3_dpa,
    :iodine,
    :iron,
    :lithium,
    :magnesium,
    :manganese, 
    :mercury, 
    :molybdenum, 
    :niacin_ne, 
    :pantothenic_acid, 
    :phosphorus, 
    :potassium, 
    :riboflavin, 
    :selenium, 
    :thiamin, 
    :vitamin_a_rae, 
    :vitamin_b12, 
    :vitamin_b6, 
    :vitamin_c, 
    :vit_e_a_tocopherol, 
    :vitamin_k1, 
    :zinc 
  ]

  schema "foods" do
    many_to_many :prices, Price, join_through: FoodsPrices

    field :data_source_id, :string

    field :name, :string
    field :data_source, :string
    field :category, :string
    field :edible_portion, :float
    
    field :calories, :float
    field :protein, :float

    field :folate_dfe, :float
    field :biotin, :float
    field :calcium, :float
    field :cholesterol, :float
    field :choline, :float
    field :chromium, :float
    field :copper, :float
    field :fat_total, :float
    field :o3_epa, :float
    field :o3_dha, :float
    field :o3_dpa, :float
    field :iodine, :float
    field :iron, :float
    field :lithium, :float
    field :magnesium, :float
    field :manganese, :float
    field :mercury, :float
    field :molybdenum, :float
    field :niacin_ne, :float
    field :pantothenic_acid, :float
    field :phosphorus, :float
    field :potassium, :float
    field :riboflavin, :float
    field :selenium, :float
    field :thiamin, :float
    field :vitamin_a_rae, :float
    field :vitamin_b12, :float
    field :vitamin_b6, :float
    field :vitamin_c, :float
    field :vit_e_a_tocopherol, :float
    field :vitamin_k1, :float
    field :zinc, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:name])
  end
end

