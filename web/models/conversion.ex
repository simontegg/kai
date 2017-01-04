defmodule Kai.Conversion do
  use Kai.Web, :model
  alias Kai.FoodPrice

  schema "conversions" do
    has_many :food_price, FoodPrice
    field :each_g, :float
    field :raw_to_cooked, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:each_g, :raw_to_cooked])
  end
end
