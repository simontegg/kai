#ExUnit.configure(exclude: [feature: true])
ExUnit.start
Ecto.Adapters.SQL.Sandbox.mode(Kai.Repo, :manual)
#{:ok, _} = Application.ensure_all_started(:ex_machina)    
