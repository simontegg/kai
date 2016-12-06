defmodule Kai.User do
  use Kai.Web, :model

  alias Kai.Repo

  schema "users" do
    field :name, :string
    field :age, :integer
    field :weight, :integer
    field :sex, :string
    field :activity, :string
    field :email, :string
    field :access_token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do

    struct
    |> cast(params, [:email, :access_token])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:email])
    |> unique_constraint(:email)
  
    #    struct
    #    |> cast(params, [:name, :age, :weight, :activity, :sex])
    #    |> validate_required([:name, :age, :sex])
    #    |> validate_inclusion(:age, 18..120)
    #    |> validate_format(:email, ~r/@/)
    #    |> update_change(:email, &String.downcase/1)
    #    |> unique_constraint([:email, :access_token])
    #
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> generate_access_token
  end

  defp generate_access_token(struct) do
    token = SecureRandom.hex(30)

    case Repo.get_by(__MODULE__, access_token: token) do
      nil ->
        put_change(struct, :access_token, token)
      _ ->
        generate_access_token(struct)
    end
  end

end
