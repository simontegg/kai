defmodule Kai.ReceiptController do
  use Kai.Web, :controller

  alias Kai.Receipt

  def index(conn, _params) do
    receipts = Repo.all(Receipt)
    render(conn, "index.html", receipts: receipts)
  end

  def new(conn, _params) do
    changeset = Receipt.changeset(%Receipt{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"receipt" => receipt_params}) do
    changeset = Receipt.changeset(%Receipt{}, receipt_params)

    case Repo.insert(changeset) do
      {:ok, _receipt} ->
        conn
        |> put_flash(:info, "Receipt created successfully.")
        |> redirect(to: receipt_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    receipt = Repo.get!(Receipt, id)
    render(conn, "show.html", receipt: receipt)
  end

  def edit(conn, %{"id" => id}) do
    receipt = Repo.get!(Receipt, id)
    changeset = Receipt.changeset(receipt)
    render(conn, "edit.html", receipt: receipt, changeset: changeset)
  end

  def update(conn, %{"id" => id, "receipt" => receipt_params}) do
    receipt = Repo.get!(Receipt, id)
    changeset = Receipt.changeset(receipt, receipt_params)

    case Repo.update(changeset) do
      {:ok, receipt} ->
        conn
        |> put_flash(:info, "Receipt updated successfully.")
        |> redirect(to: receipt_path(conn, :show, receipt))
      {:error, changeset} ->
        render(conn, "edit.html", receipt: receipt, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    receipt = Repo.get!(Receipt, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(receipt)

    conn
    |> put_flash(:info, "Receipt deleted successfully.")
    |> redirect(to: receipt_path(conn, :index))
  end
end
