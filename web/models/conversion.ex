defmodule Kai.Conversion do
  use Kai.Web, :model
  alias Kai.{FoodsPrices} 

  schema "conversion" do
    has_many :food_price, FoodsPrices
    field :each_to_g, :float
    field :raw_to_cooked, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:food_price_id, :each_to_g, :raw_to_cooked])
  end
end
