defmodule Kai.ListTest do
  use Kai.ModelCase

  alias Kai.List

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = List.changeset(%List{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = List.changeset(%List{}, @invalid_attrs)
    refute changeset.valid?
  end
end
