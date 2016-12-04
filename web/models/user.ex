defmodule Kai.User do
  use Kai.Web, :model

  schema "users" do
    field :name, :string
    field :age, :integer
    field :weight, :integer
    field :activity, :string
    field :sex, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :age, :weight, :activity, :sex])
    |> validate_required([:name, :age, :weight, :activity, :sex])
  end
end
