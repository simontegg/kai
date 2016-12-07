defmodule Kai.Repo.Migrations.CreateReceipt do
  use Ecto.Migration

  def change do
    create table(:receipts) do
      add :store_receipt_id, :string
      add :company_id, :string
      add :store_id, :string
      add :user_id, :string
      add :image_url, :string
      add :company_name, :string

      timestamps()
    end

  end
end
