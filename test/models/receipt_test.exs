defmodule Kai.ReceiptTest do
  use Kai.ModelCase

  alias Kai.Receipt

  @valid_attrs %{company_id: "some content", company_name: "some content", image_url: "some content", store_id: "some content", store_receipt_id: "some content", user_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Receipt.changeset(%Receipt{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Receipt.changeset(%Receipt{}, @invalid_attrs)
    refute changeset.valid?
  end
end
