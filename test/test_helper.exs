ExUnit.configure(exclude: [skip: true])
ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
# Add this line:
#Code.require_file("priv/repo/seeds.exs")


Ecto.Adapters.SQL.Sandbox.mode(Kai.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)    
