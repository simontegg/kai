defmodule Kai.Conversion do
  use Kai.Web, :model
  alias Kai.FoodPrice

  schema "conversions" do
    field :name, :string
    field :each_g, :float
    field :raw_to_cooked, :float
    has_many :food_price, FoodPrice

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
