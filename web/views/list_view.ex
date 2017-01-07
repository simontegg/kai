defmodule Kai.ListView do
  use Kai.Web, :view
  import Number.Currency

  def render_money(amount) do
    number_to_currency(amount / 100) 
  end
end
