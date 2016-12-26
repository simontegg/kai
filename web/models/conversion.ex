defmodule Kai.Conversion do
  use Kai.Web, :model
  alias Kai.Price

  schema "conversions" do
    belongs_to :price, Price
    field :each_to_g, :float
    field :raw_to_cooked, :float
    field :edible_portion, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:each_to_g, :raw_to_cooked])
    |> validate_required([:each_to_g, :raw_to_cooked])
  end
end
