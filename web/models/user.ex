defmodule Kai.User do
  use Kai.Web, :model
  use Timex
  import Hashids

  alias Kai.Repo
  
  @salt Hashids.new(salt: System.get_env("SECRET_KEY_BASE"))

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
  
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> generate_access_token
  end

  def timestamp do
    :os.system_time(:milli_seconds)
  end


  defp generate_access_token(struct) do
    now = timestamp
    token = Hashids.encode(@salt, now)

    case Repo.get_by(__MODULE__, access_token: token) do
      nil ->
        put_change(struct, :access_token, token)
      _ ->
        generate_access_token(struct)
    end
  end

end
