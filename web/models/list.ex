defmodule Kai.List do
  use Kai.Web, :model
  alias Kai.{User, FoodQuantity, Repo, List}

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

  @spec get_by_user(integer) :: list
  def get_by_user (user_id) do
    query = from(l in List,
                 left_join: u in assoc(l, :user),
                 left_join: fq in assoc(l, :food_quantities),
                 left_join: fp in assoc(fq, :food_price),
                 left_join: p in assoc(fp, :price),
                 left_join: f in assoc(fp, :price),
                 left_join: c in assoc(fp, :conversion),
                 select: %{
                   user_id: u.id, 
                   price: p.price,
                   price_name: p.name, 
                   food_name: f.name,
                   each_g: c.each_g,
                   raw_to_cooked: c.raw_to_cooked
                 })

    lists = 
      query
      |> Repo.all
      |> Enum.map(&convert(&1))

  end

  @spec convert(map) :: map
  def convert(%{:quantity => quantity, :each_g => each_g} = food_quantity) do 
    Map.put_new(food_quantity, 
                :item_quantity, 
                Float.round(quantity / each_g, 1))
  end
  def convert(%{:quantity => quantity, 
                :raw_to_cooked => raw_to_cooked} = food_quantity) do 
    Map.put_new(food_quantity, 
                :raw_quantity, 
                Float.round(quantity / raw_to_cooked, 1))
  end
  def convert(food_quantity), do: food_quantity 
end
