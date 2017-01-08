use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :kai, Kai.Endpoint,
  secret_key_base: "TeNlDG2s3pRduGEa15RaD2/G0iZz9nCpZlRUb2vRhxWmxwqGCiF5JBJTe5oDuBR1"

# Configure your database
config :kai, Kai.Repo,
