defmodule Kai.AppController do
  use Kai.Web, :controller
  import String
  import Hashids
  alias Kai.{Requirements, Solver, User}

  @numbers ["age", "height", "weight", "activity"]
  @strings ["sex"]
  @salt Hashids.new(salt: System.get_env("SECRET_KEY_BASE"), 
                    min_len: 5)

  def convert(k, v) when k in @numbers do 
    value = if is_integer(v), do: v, else: to_integer(v)
    {to_atom(k), value}
  end
  def convert(k, v) when k in @strings, do: {to_atom(k), v}

  def decode(json) do 
    for {k, v} <- json, 
      k in @numbers or k in @strings, 
      into: %{}, 
      do: convert(k, v)
  end

  def create(conn, json) do
    biometrics = decode(json)
    requirements = Requirements.nutrients(biometrics, 7)

    user_params = Map.merge(biometrics, requirements)
    changeset = User.changeset(%User{}, user_params)
    
    # Task.async(fn -> Solver.perform(constraints: requirements) end)
    case Repo.insert(changeset) do
      {:ok, user} ->
       conn |> redirect(to: list_user_path(user.id))
      {:error, changeset} ->
        IO.inspect changeset
        conn
    end
  end

  def list_user_path(id) do
    hashed_id = Hashids.encode(@salt, id)
    "/users/#{hashed_id}/lists"
  end


  def serve_preferences(conn, json) do
    render(conn, "preferences.html")
  end
  
  def index(conn, _params) do
    render(
      conn, 
      "index.html", 
      state: :sent,
      current_user: get_session(conn, :current_user)
    )
  end
end
