defmodule Kai.NutritionPrice do
  use Kai.Web, :model
  alias Kai.{Food, Nutrition, Price} 

  schema "nutrition_prices" do
    belongs_to :nutrition, Nutrition
    belongs_to :price, Price
    belongs_to :food, Food

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nutrition_id, :price_id, :food_id])
    |> validate_required([:food_id, :price_id])
  end
end
