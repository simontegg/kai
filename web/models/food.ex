defmodule Kai.Food do
  use Kai.Web, :model

  schema "foods" do
    field :food_id, :string
    field :category, :string
    field :name, :string
    field :d3, :float
    field :alcohol, :float
    field :alpha_carotene, :float
    field :alpha_tocepherol, :float
    field :available_carbohydrate_fsanz, :float
    field :available_carbohydrate_weight, :float
    field :beta_carotene, :float
    field :beta_tocepherol, :float
    field :biotin, :float
    field :boron, :float
    field :cadmium, :float
    field :caffine, :float
    field :calcium, :float
    field :cesium, :float
    field :chloride, :float
    field :cholecalciferol, :float
    field :cholesterol, :float
    field :chromium, :float
    field :copper, :float
    field :folate, :float
    field :energy_kcal, :integer
    field :energy_kj, :integer
    field :ergocalciferol, :float

    field :weight, :integer
    field :activity, :string
    field :sex, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :age, :weight, :activity, :sex])
    |> validate_required([:name, :age, :weight, :activity, :sex])
  end
end


#Cesium~Chloride~Cholecalciferol (Vitamin D3)~Cholesterol~Chromium~Copper~Dietary folate equivalents~Edible portion~Energy, total metabolisable (kcal)~Energy, total metabolisable (kJ)~Ergocalciferol (Vitamin D2)~Fat, total~Fatty acid 18:3~Fatty acid 18:3 omega-3~Fatty acid 20:5~Fatty acid 20:5 omega-3~Fatty acid 22:6~Fatty acid 22:6 omega-3~Fatty acids, total~Fatty acids, total long chain polyunsaturated omega-3~Fatty acids, total monounsaturated~Fatty acids, total monounsaturated trans~Fatty acids, total polyunsaturated~Fatty acids, total polyunsaturated omega-3~Fatty acids, total polyunsaturated omega-6~Fatty acids, total polyunsaturated trans~Fatty acids, total saturated~Fatty acids, total trans~Fibre, total dietary~Fibre, water-insoluble~Fibre, water-soluble~Fluoride~Folate food, naturally occurring food folates~Folate, total~Fructose~Gamma-tocopherol~Glucose~Glutamic acid~Glutamic acid (/g N)~Glutamic acid (grams)~Glycine~Glycine (/g N)~Glycine (grams)~Glycogen~Glycogen (monosaccharide equivalents)~Histidine~Histidine (/g N)~Histidine (grams)~Hydroxyproline~Hydroxyproline (/g N)~Hydroxyproline (grams)~Iodide~Iron~Isoleucine~Isoleucine (/g N)~Isoleucine (grams)~Lactic acid (grams)~Lactose~Lactose (monosaccharide equivalents)~Lead~Leucine~Leucine (/g N)~Leucine (grams)~Lithium~Lutein~Lycopene~Lysine~Lysine (/g N)~Lysine (grams)~Magnesium~Malic acid (grams)~Maltodextrin~Maltose~Maltose (monosaccharide equivalents)~Manganese~Mercury~Methionine~Methionine (/g N)~Methionine (grams)~Molybdenum~Monosaccharides, total~Niacin equivalents from tryptophan~Niacin equivalents, total~Niacin, preformed~Nickel~Nitrogen, total~Nitrogen-to-protein conversion factor~Organic acids, total (grams)~Oxalic acid (grams)~Pantothenic acid~Phenylalanine~Phenylalanine (/g N)~Phenylalanine (grams)~Phosphorus~Phytosterols, total~Polysaccharides, non-starch~Polysaccharides, non-starch, water-insoluble~Polysaccharides, non-starch, water-soluble~Potassium~Proline~Proline (/g N)~Proline (grams)~Protein, total; calculated from total nitrogen~Proximates, total~Quinic acid (grams)~Retinol~Riboflavin~Rubidium~Selenium~Serine~Serine (/g N)~Serine (grams)~Silicon (acid soluble)~Sodium~Starch, resistant~Starch, total~Starch, total (monosaccharide equivalents)~Succinic acid (grams)~Sucrose~Sucrose (monosaccharide equivalents)~Sugars, total~Sugars, total (monosaccharide equivalents)~Sulphur~Taurine~Taurine (/g N)~Taurine (grams)~Thiamin~Threonine~Threonine (/g N)~Threonine (grams)~Tin~Total carbohydrate by difference~Total carbohydrates by summation~Total fat-to-total fatty acids conversion factor~Tryptophan~Tryptophan (/g N)~Tryptophan (grams)~Tyrosine~Tyrosine (/g N)~Tyrosine (grams)~Valine~Valine (/g N)~Valine (grams)~Vanadium~Vitamin A, retinol equivalents~Vitamin B12~Vitamin B6~Vitamin C~Vitamin D; calculated by summation~Vitamin E, alpha-tocopherol equivalents~Vitamin K~Water~Zeaxanthin~Zinc
