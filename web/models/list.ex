defmodule Kai.List do
  use Kai.Web, :model
  alias Kai.{User, Food}

  schema "lists" do
    field :name, :string
    belongs_to :users, User
    has_many :foods, Food

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
