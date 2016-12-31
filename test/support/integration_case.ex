defmodule Kai.IntegrationCase do
  use ExUnit.CaseTemplate
  
  using do
    quote do
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Kai.Router.Helpers

      alias Kai.Repo

      @endpoint Kai.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kai.Repo)
  end

end

