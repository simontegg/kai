defmodule Kai.FoodQuantity do
  use Kai.Web, :model
  alias Kai.{FoodPrice, List}

  schema "food_quantities" do
    field :quantity, :integer
    belongs_to :list, List
    belongs_to :food_price, FoodPrice

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:quantity])
    |> Ecto.Changeset.put_assoc(:food_price, params.food_price)
    |> validate_required([:quantity])
  end
end
