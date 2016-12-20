defmodule Kai.PageController do
  use Kai.Web, :controller
  import Toniq
  alias Kai.SolverWorker
  
  import String

  alias Kai.Requirements

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

  def nutrients(conn, json) do
    constraints =
      json 
      |> decode 
      |> Requirements.nutrients
    
#Toniq.enqueue(SolverWorker, [constraints: constraints, foods: foods])
    Toniq.enqueue(SolverWorker, [constraints: constraints])

    redirect(conn, to: "/preferences")
  end

  def serve_preferences(conn, json) do
    render(conn, "preferences.html")
  end
  
  def index(conn, _params) do
    render conn, "index.html", current_user: get_session(conn, :current_user)
  end
end
