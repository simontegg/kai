defmodule Kai.PricesTest do
  use Kai.ModelCase

  alias Kai.Prices

  @valid_attrs %{food_id: "some content", price_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Prices.changeset(%Prices{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Prices.changeset(%Prices{}, @invalid_attrs)
    refute changeset.valid?
  end
end
