defmodule Kai.Price do
  use Kai.Web, :model
  alias Kai.{Food, FoodPrices, User}

  @fields [
    :price,
    :company_id,
    :name,
    :currency,
    :currency_unit,
    :quantity,
    :quantity_unit,
    :longitude,
    :latitude,
    :url
  ]

  schema "prices" do

    many_to_many :foods, Food, join_through: FoodPrices
    belongs_to :user, User 

    field :name, :string
    field :price, :float
    field :quantity, :float
    field :quantity_unit, :string #kg || each

    field :url, :string
    field :company_id, :string
    field :currency, :string
    field :currency_unit, :string #cents
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
    |> validate_required([:price, :name])
  end
end
