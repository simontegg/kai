defmodule Kai.User do
  use Kai.Web, :model
  import Hashids

  alias Kai.Repo
  
  @salt Hashids.new(salt: System.get_env("SECRET_KEY_BASE"))

  @fields [
    :name,                  
    :age,                   
    :weight,                
    :height,                
    :activity,              
    :sex,                   
    :email,                 
    :access_token,          
    :calories,              
    :protein,               
    :biotin,            
    :folate_dfe,        
    :niacin_ne,         
    :pantothenic_acid,  
    :riboflavin,        
    :thiamin,           
    :vitamin_a,         
    :vitamin_b6,        
    :vitamin_b12,       
    :vitamin_c,         
    :vit_e_a_tocopherol, 
    :vitamin_k1,         
    :calcium,           
    :chromium,          
    :copper,            
    :iodine,            
    :iron,              
    :magnesium,         
    :manganese,         
    :molybdenum,        
    :phosphorus,        
    :potassium,         
    :selenium,          
    :zinc,              
  ]

  schema "users" do
    field :name,                  :string
    field :age,                   :integer
    field :weight,                :integer
    field :height,                :integer
    field :activity,              :integer
    field :sex,                   :string
    field :email,                 :string
    field :access_token,          :string

    field :calories,              :integer
    field :protein,               :integer
    
    #vitamin sufficiency
    field :biotin,            :float
    field :folate_dfe,        :float
    field :niacin_ne,         :float
    field :pantothenic_acid,  :float
    field :riboflavin,        :float
    field :thiamin,           :float
    field :vitamin_a,         :float
    field :vitamin_b6,        :float
    field :vitamin_b12,       :float
    field :vitamin_c,         :float
    field :vit_e_a_tocopherol,:float 
    field :vitamin_k1,        :float 

    #mineral sufficiency
    field :calcium,           :float
    field :chromium,          :float
    field :copper,            :float
    field :iodine,            :float
    field :iron,              :float
    field :magnesium,         :float
    field :manganese,         :float
    field :molybdenum,        :float
    field :phosphorus,        :float
    field :potassium,         :float
    field :selenium,          :float
    field :zinc,              :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_required([])
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
