defmodule Kai.ListView do
  use Kai.Web, :view

  def render_food(food) do
    IO.inspect food
    food.name
  end
end
