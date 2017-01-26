defmodule Kai.List do
  use Kai.Web, :model
  alias Kai.{User, NutritionPrice, Quantity, Repo, List}

  schema "lists" do
    field :name, :string
    belongs_to :user, User
    has_many :quantities, Quantity

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> Ecto.Changeset.put_assoc(:user, params.user)
    |> Ecto.Changeset.put_assoc(:quantities, params.quantities)
    |> validate_required([:quantities])
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
         left_join: q in assoc(l, :quantities),
         left_join: np in assoc(q, :nutrition_price),
         left_join: p in assoc(np, :price),
         left_join: n in assoc(np, :nutrition),
         left_join: f in assoc(np, :food),
         where: u.id == ^user_id,
         group_by: [:id, 
                    q.quantity, 
                    q.cost,
                    p.price, 
                    p.quantity_unit,
                    p.name, 
                    n.name, 
                    f.each_g, 
                    f.raw_to_cooked],
         select: %{
           list_id: l.id,
           cost: q.cost, 
           quantity: q.quantity,
           quantity_unit: p.quantity_unit,
           unit_price: p.price,
           price_name: p.name, 
           food_name: n.name,
           each_g: f.each_g,
           raw_to_cooked: f.raw_to_cooked
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

    quantities = 
      solution
      |> Enum.reduce([], fn (food, acc) -> 
          nutrition_price_id = foods_by_name[food["name"]].id

          quantity = %{
            nutrition_price: Repo.get(NutritionPrice, nutrition_price_id),
            quantity: String.to_integer(food["quantity"]),
            cost: String.to_integer(food["cost"])
          }

          acc ++ [quantity]
        end) 
      |> Enum.map(fn (params) -> 
          %Quantity{} |> Quantity.changeset(params) |> Repo.insert!
        end)

    params = %{
      name: "first", 
      quantities: quantities,
      user: user 
    }

    %List{} |> List.changeset(params) |> Repo.insert
  end

  @spec convert(map) :: map
  def convert(%{:quantity => q, 
                :each_g => each_g} = quantity) when not is_nil(each_g) do

    Map.put_new(quantity, :item_quantity, Float.round(q / each_g, 1))
  end
  def convert(%{:quantity => q, 
                :raw_to_cooked => r} = quantity) when not is_nil(r) do 

    Map.put_new(quantity, :raw_quantity, round(q / r))
  end
  def convert(quantity), do: quantity 
end
