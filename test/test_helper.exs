ExUnit.configure(exclude: [skip: true, external: true])
ExUnit.start

# Add this line:
#Code.require_file("priv/repo/seeds.exs")

{:ok, _} = Application.ensure_all_started(:ex_machina)    
