defmodule Kai.FoodQuantityTest do
  use Kai.ModelCase

  alias Kai.FoodQuantity

  @valid_attrs %{quantity: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FoodQuantity.changeset(%FoodQuantity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FoodQuantity.changeset(%FoodQuantity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
