defmodule Kai.TempController do
  use Kai.Web, :controller

  alias Kai.User

  def new(conn, params) do
    IO.puts params 
    render(conn, "your-groceries.html")
  end
end
