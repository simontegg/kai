defmodule Kai.Nutrition do
  use Kai.Web, :model
  alias Kai.{Price, Repo, NutritionPrice}

  @nutrition_excl [:name, :edible_portion]

  @nutrients [ 
    :calories,
    :protein, 
    :folate_dfe, 
    :biotin,
    :calcium,
    :chromium,
    :copper,
    :o3_epa,
    :o3_dha,
    :o3_dpa,
    :iodine,
    :iron,
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
  
  @nutrition_fields @nutrition_excl ++ @nutrients
  @price_fields [:price, :quantity, :quantity_unit] 
  @food_fields [:each_g, :raw_to_cooked] 
  @headers @nutrition_fields ++ @price_fields ++ @food_fields
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

  schema "nutrition" do
    many_to_many :prices, Price, join_through: NutritionPrice

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
  
  @spec get_nutrition_prices() :: list
  def get_nutrition_prices do
    get_query
    |> Repo.all
    |> merge_result 
    |> set_100g_prices
    |> aggregate_nutrients
  end
  
  # TODO: query by user, location, time
  def get_query do
    from(np in NutritionPrice,
         left_join: p in assoc(np, :price),
         left_join: n in assoc(np, :nutrition),
         left_join: f in assoc(np, :food),
         select: %{
           id: np.id, 
           price: map(p, ^@price_fields),
           nutrition: map(n, ^@nutrition_fields),
           food: map(f, ^@food_fields)
         })
  end

  def merge_result(rows) do
    Enum.map(rows, fn (t) -> flatten(t, %{}) end)
  end

  @spec set_100g_prices(list) :: list
  def set_100g_prices(rows) do
    Enum.map(rows, &set_100g_price(&1))
  end

  @spec set_100g_prices(map) :: map
  def set_100g_price(row) do
    Map.put_new(row, :price_100g, price_per_edible_100g(row))
  end

  @doc "cents per edible 100 grams of food"
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :each_g => each_g,
    :edible_portion => edible_portion,
  }) when quantity_unit == "ea" do

    100
    |> Kernel./(quantity * each_g)
    |> Kernel.*(price) 
    |> Kernel./(edible_portion) 
    |> round
  end
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :edible_portion => edible_portion,
    :raw_to_cooked => raw_to_cooked
  }) do
    denominator = if quantity_unit in ["kg", "L"], do: 0.1, else: 100

    price
    |> Kernel./(quantity / denominator)
    |> Kernel./(edible_portion || 1)
    |> Kernel./(raw_to_cooked || 1)
    |> round
  end
  def price_per_edible_100g(%{
    :price => price,
    :quantity => quantity,
    :quantity_unit => quantity_unit,
    :edible_portion => edible_portion,
  }) do
    denominator = if quantity_unit in ["kg", "L"], do: 0.1, else: 100

    price
    |> Kernel./(quantity / denominator)
    |> Kernel./(edible_portion || 1)
    |> round
  end
  
  def flatten({_, v}, _) when is_nil(v), do: %{}
  def flatten(%{} = o, acc), do: Enum.reduce(o, acc, &flatten(&1, &2))
  def flatten({k, v}, acc) when is_map(v), do: flatten(v, acc)
  def flatten({k, v}, acc), do: Map.put_new(acc, k, v)

  def aggregate_nutrients(rows) do
    for row <- rows,
      do: Enum.reduce(row, %{}, &aggregate_o3_epa_dha_dpa(&1, &2))
  end
    
  def aggregate_o3_epa_dha_dpa({key, value}, acc) do
    if Enum.member?([:o3_epa, :o3_dha, :o3_dpa], key) do
      Map.update(acc, :o3_epa_dha_dpa, value, &(&1 + value))
    else 
      Map.put_new(acc, key, value)
    end
  end
end

