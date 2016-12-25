defmodule Kai.FoodsPricesTest do
  use Kai.ModelCase

  alias Kai.FoodsPrices

  @valid_attrs %{food_id: "some content", price_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FoodsPrices.changeset(%FoodsPrices{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FoodsPrices.changeset(%FoodsPrices{}, @invalid_attrs)
    refute changeset.valid?
  end
end
