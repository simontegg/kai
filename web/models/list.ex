defmodule Kai.List do
  use Kai.Web, :model
  alias Kai.{User, FoodPrice, FoodQuantity, Repo, List}

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

  @spec get_by_user_id(integer) :: list
  def get_by_user_id(user_id) do
    user_id
    |> by_user_id_query
    |> Repo.all 
    |> Enum.map(&convert(&1)) 
    |> group_by
  end

  @macrocallback by_user_id_query(integer) :: Macro.t
  def by_user_id_query(user_id) do
    from(l in List,
         left_join: u in assoc(l, :user),
         left_join: fq in assoc(l, :food_quantities),
         left_join: fp in assoc(fq, :food_price),
         left_join: p in assoc(fp, :price),
         left_join: f in assoc(fp, :food),
         left_join: c in assoc(fp, :conversion),
         where: u.id == ^user_id,
         group_by: [:id, 
                    fq.quantity, 
                    fq.cost,
                    p.price, 
                    p.quantity_unit,
                    p.name, 
                    f.name, 
                    c.each_g, 
                    c.raw_to_cooked],
         select: %{
           list_id: l.id,
           cost: fq.cost, 
           quantity: fq.quantity,
           quantity_unit: p.quantity_unit,
           unit_price: p.price,
           price_name: p.name, 
           food_name: f.name,
           each_g: c.each_g,
           raw_to_cooked: c.raw_to_cooked
         })
  end

  @spec group_by(list(map)) :: list(%{foods: list(map)})
  def group_by(rows) do
    rows
    |> Enum.group_by(fn (row) -> row.list_id end)
    |> Enum.reduce([], fn ({k, v}, acc) -> 
        list = %{list_id: k, foods: v}   
        acc ++ [list] 
    end)
  end

  @spec save_list(list(map), list(map), struct) :: tuple
  def save_list(solution, foods, user) do
    foods_by_name = for food <- foods, into: %{}, do: {food.name, food}

    food_quantities = 
      solution
      |> Enum.reduce([], fn (food, acc) -> 
            food_quantity = %{
              food_price: Repo.get(FoodPrice, foods_by_name[food["name"]].id),
              quantity: String.to_integer(food["quantity"]),
              cost: String.to_integer(food["cost"])
            }

            acc ++ [food_quantity]
          end) 
      |> Enum.map(fn (params) -> 
            %FoodQuantity{} |> FoodQuantity.changeset(params) |> Repo.insert!
          end)

    params = %{
      name: "first", 
      food_quantities: food_quantities,
      user: user 
    }

    %List{} |> List.changeset(params) |> Repo.insert
  end

  @spec convert(map) :: map
  def convert(%{:quantity => quantity, 
                :each_g => each_g} = food_quantity) when not is_nil(each_g) do

    Map.put_new(food_quantity, 
                :item_quantity, 
                Float.round(quantity / each_g, 1))
  end
  def convert(%{:quantity => quantity, 
                :raw_to_cooked => r} = food_quantity) when not is_nil(r) do 

    Map.put_new(food_quantity, :raw_quantity, round(quantity / r))
  end
  def convert(food_quantity), do: food_quantity 
end
