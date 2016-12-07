defmodule Kai.ReceiptControllerTest do
  use Kai.ConnCase

  alias Kai.Receipt
  @valid_attrs %{company_id: "some content", company_name: "some content", image_url: "some content", store_id: "some content", store_receipt_id: "some content", user_id: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, receipt_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing receipts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, receipt_path(conn, :new)
    assert html_response(conn, 200) =~ "New receipt"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, receipt_path(conn, :create), receipt: @valid_attrs
    assert redirected_to(conn) == receipt_path(conn, :index)
    assert Repo.get_by(Receipt, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, receipt_path(conn, :create), receipt: @invalid_attrs
    assert html_response(conn, 200) =~ "New receipt"
  end

  test "shows chosen resource", %{conn: conn} do
    receipt = Repo.insert! %Receipt{}
    conn = get conn, receipt_path(conn, :show, receipt)
    assert html_response(conn, 200) =~ "Show receipt"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, receipt_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    receipt = Repo.insert! %Receipt{}
    conn = get conn, receipt_path(conn, :edit, receipt)
    assert html_response(conn, 200) =~ "Edit receipt"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    receipt = Repo.insert! %Receipt{}
    conn = put conn, receipt_path(conn, :update, receipt), receipt: @valid_attrs
    assert redirected_to(conn) == receipt_path(conn, :show, receipt)
    assert Repo.get_by(Receipt, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    receipt = Repo.insert! %Receipt{}
    conn = put conn, receipt_path(conn, :update, receipt), receipt: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit receipt"
  end

  test "deletes chosen resource", %{conn: conn} do
    receipt = Repo.insert! %Receipt{}
    conn = delete conn, receipt_path(conn, :delete, receipt)
    assert redirected_to(conn) == receipt_path(conn, :index)
    refute Repo.get(Receipt, receipt.id)
  end
end
