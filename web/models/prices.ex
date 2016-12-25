defmodule Kai.Prices do
  use Kai.Web, :model
  alias Kai.{Food, FoodsPrices, User}

  @fields [
    :price,
    :company_id,
    :food_description,
    :currency,
    :currency_unit,
    :quantity_unit,
    :longitude,
    :latitude
  ]

  schema "prices" do

    many_to_many :foods, Food, join_through: FoodsPrices
    belongs_to :user, User 

    field :price, :float
    field :company_id, :string
    field :food_description, :string
    field :currency, :string
    field :currency_unit, :string #cents
    field :quantity_unit, :string #kg || 100g || each
    field :longitude, :integer
    field :latitude, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:price, :food_description])
  end
end
