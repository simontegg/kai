defmodule Kai.Repo do
  use Ecto.Repo, otp_app: :kai
  use Scrivener, page_size: 10
end
