defmodule Kai.UserTest do
  use Kai.ModelCase

  alias Kai.User

  @valid_attrs %{activity: "some content", age: 42, name: "some content", sex: "some content", weight: 42}
  @invalid_attrs %{}

  @tag :skip
  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  @tag :skip
  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
