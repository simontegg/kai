defmodule Kai.AppController do
  use Kai.Web, :controller
  import String
  alias Kai.{Requirements, Solver, User}

  @numbers ["age", "height", "weight", "activity"]
  @strings ["sex"]

  def convert(k, v) when k in @numbers, do: {to_atom(k), to_integer(v)}
  def convert(k, v) when k in @strings, do: {to_atom(k), to_atom(v)}

  def decode(json) do 
    for {k, v} <- json, 
      k in @numbers or k in @strings, 
      into: %{}, 
      do: convert(k, v)
  end

  def create(conn, biometrics) do
    requirements =
      biometrics 
      |> decode 
      |> Requirements.nutrients(7)
      
    changeset = User.changeset(%User{}, requirements)
    
    Task.async(fn -> Solver.perform(constraints: requirements) end)
  
    case Repo.insert(changeset) do
      {:ok, _user} ->
       conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
    

    redirect(conn, to: "/preferences")
  end

  def serve_preferences(conn, json) do
    render(conn, "preferences.html")
  end
  
  def index(conn, _params) do
    IO.inspect "hitting it"
    render(
      conn, 
      "index.html", 
      state: :sent,
      current_user: get_session(conn, :current_user)
    )
  end
end
