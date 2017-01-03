defmodule Kai.ListView do
  use Kai.Web, :view

  def render_food(food) do
    "#{food.name} | #{food.quantity}"
  end
end
