defmodule Kai.ListViewTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.ListView

  test "converts to a human-friendly price" do
    amount = 800 

    amount_string = ListView.render_money(amount)
    
    assert amount_string == "$8.00"
  end
  
end
