defmodule Kai.Quantity do
  use Kai.Web, :model
  alias Kai.{NutritionPrice, List}

  schema "quantities" do
    field :quantity, :integer
    field :cost, :integer
    belongs_to :list, List
    belongs_to :nutrition_price, NutritionPrice

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:quantity, :cost])
    |> Ecto.Changeset.put_assoc(:nutrition_price, params.nutrition_price)
    |> validate_required([:quantity, :cost])
  end
end
