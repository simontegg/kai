defmodule Kai.List do
  use Kai.Web, :model
  alias Kai.{User, FoodQuantity}

  schema "lists" do
    field :name, :string
    belongs_to :user, User
    has_many :food_quantities, FoodQuantity

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> Ecto.Changeset.put_assoc(:user, params.user)
    |> Ecto.Changeset.put_assoc(:food_quantities, params.food_quantities)
    |> validate_required([:food_quantities])
  end
end
