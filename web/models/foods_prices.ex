defmodule Kai.FoodsPrices do
  use Kai.Web, :model
  alias Kai.{Conversion, Food, Price} 


  schema "foods_prices" do
    belongs_to :food, Food
    belongs_to :price, Price
    belongs_to :conversion, Conversion

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:food_id, :price_id, :conversion_id])
    |> validate_required([:food_id, :price_id])
  end
end
