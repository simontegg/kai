defmodule Kai.ReceiptTest do
  use ExUnit.Case
  #use Kai.ModelCase
  alias Kai.Requirements

  import Kai.Factory

  @tag :wip
  test "computes micronutrient requirements from biometrics" do
    IO.inspect Requirements
    user = build(:user)

    nutrients = Requirements.nutrients(user)

    IO.inspect user
    IO.inspect nutrients
    #assert nutrients.niacin_ne_rda == user.niacin_ne_rda
    Enum.each(nutrients, fn ({k, v}) -> 
      assert Map.get(nutrients, k) == Map.get(user, k)
    end)

  end


end
