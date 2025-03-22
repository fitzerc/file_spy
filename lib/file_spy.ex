defmodule FileSpy do
  use Application

  def start(_type, _args) do
    server = {Bandit, plug: FsPlug, scheme: :http, port: 4000}
    Supervisor.start_link([server], strategy: :one_for_one)
  end
end
