defmodule Kai.FoodsPrices do
  use Kai.Web, :model
  alias Kai.{Food, Price} 

  schema "foods_prices" do
    belongs_to :food, Food
    belongs_to :price, Price

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:food_id, :price_id])
    |> validate_required([:food_id, :price_id])
  end
end
