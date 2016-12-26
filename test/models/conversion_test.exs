defmodule Kai.ConversionTest do
  use Kai.ModelCase

  alias Kai.Conversion

  @valid_attrs %{each_to_g: "120.5", raw_to_cooked: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Conversion.changeset(%Conversion{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Conversion.changeset(%Conversion{}, @invalid_attrs)
    refute changeset.valid?
  end
end
