defmodule Kai.PageController do
  use Kai.Web, :controller
  
  import Kai.Requirements
  alias Kai.Utils
  alias String

  @numbers ["age", "height", "weight", "activity"]
  @strings ["sex"]

  defstruct [:age, :height, :weight, :sex]

  def convert(k, v) when k in @numbers, do: {String.to_atom(k), String.to_integer(v)}
  def convert(k, v) when k in @strings, do: {String.to_atom(k), String.to_atom(v)}

  def decode(params) do 
    for {k, v} <- params, k in @numbers or k in @strings, into: %{}, do: convert(k, v)
  end

  def new(conn, json) do
    cal = json |> decode |> daily_kilo_calories


    IO.inspect cal
    render(conn, "your-groceries.html")
  end

  def index(conn, _params) do
    render conn, "index.html", current_user: get_session(conn, :current_user)
  end
end
