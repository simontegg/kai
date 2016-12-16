defmodule Kai.PageController do
  use Kai.Web, :controller
  
  import Kai.Requirements
  import String
  
  alias Kai.Utils

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
    nutrients = json |> decode |> nutrients
    IO.inspect nutrients
    redirect(conn, to: "/preferences")
  end

  def serve_preferences(conn, json) do
    render(conn, "preferences.html")
  end
  
  def index(conn, _params) do
    render conn, "index.html", current_user: get_session(conn, :current_user)
  end
end
