defmodule Kai.ReceiptSlug do
  use EctoAutoslugField.Slug, from: :company, to: :slug
end

defmodule Kai.Receipt do
  use Kai.Web, :model
  use Arc.Ecto.Schema

  alias Kai.ReceiptUploader
  alias Kai.ReceiptSlug

  schema "receipts" do
    field :store_receipt_id, :string
    field :company_id, :string
    field :store_id, :string
    field :user_id, :string
    field :company, :string

    field :slug, ReceiptSlug.Type 
    field :image, ReceiptUploader.Type

    timestamps()
  end

  @required_fields ~w(company)
  @optional_fields ~w(store_receipt_id company_id store_id user_id)

  @required_file_fields ~w(image)
  @optional_file_fields ~w()


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> ReceiptSlug.maybe_generate_slug
    |> ReceiptSlug.unique_constraint
    |> cast_attachments(params, @required_file_fields)
  end

  def image_url(struct), do: ReceiptUploader.url({struct.image, struct})

end
