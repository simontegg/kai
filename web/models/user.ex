defmodule Kai.User do
  use Kai.Web, :model
  import Hashids

  alias Kai.Repo
  
  @salt Hashids.new(salt: System.get_env("SECRET_KEY_BASE"))

  schema "users" do
    field :name,                  :string
    field :age,                   :integer
    field :weight,                :integer
    field :height,                :integer
    field :sex,                   :string
    field :activity,              :string
    field :email,                 :string
    field :access_token,          :string

    field :calories,              :integer
    
    #vitamin sufficiency
    field :biotin_ai,             :float
    field :folate_dfe_rda,        :float
    field :niacin_ne_rda,         :float
    field :pantothenic_acid_ai,   :float
    field :riboflavin_rda,        :float
    field :thiamin_rda,           :float
    field :vitamin_a_rae_rda,     :float
    field :vitamin_b6_rda,        :float
    field :vitamin_b12_rda,       :float
    field :vitamin_c_rda,         :float
    field :vitamin_c_lp_recc,     :float #400mg/day
    field :vitamin_d_rda,         :float 
    field :vitamin_d_lp_recc,     :float #50mcg/day
    field :vit_e_a_toceperol_rda, :float 
    field :vitamin_k_ai,          :float 

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
