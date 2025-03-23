defmodule FsSocketHandler do
  @behaviour WebSock

  def init(path: path) do
    IO.puts("FsSocket: init")
    IO.inspect(path)
    send_periodic_message(self())
    {:ok, %{count: 0, path: path}}
  end

  def handle_in({message, [opcode: :text]}, state) do
    IO.puts("FsSocket: :text message")
    IO.inspect(message)
    IO.puts("STATE:")
    IO.inspect(state)
    {:reply, :ok, {:text, "Received: #{message}"}, %{state | count: state.count + 1}}
  end

  def handle_in(message, state) do
    IO.puts("FsSocket: message")
    IO.inspect(message)
    IO.puts("STATE:")
    IO.inspect(state)
    {:ok, state}
  end

  # {:reply, {:text, "Periodic message: 0"}, %{count: 1}}
  def handle_info(:send_message, state) do
    IO.inspect(state)
    send_periodic_message(self())
    {:push, {:text, "Periodic message: #{state.count}"}, %{state | count: state.count + 1}}
  end

  def handle_info(_info, state) do
    IO.puts("FsSocket: info")
    {:ok, state}
  end

  def terminate(_reason, _state) do
    IO.puts("FsSocket: terminate")
    :ok
  end

  defp send_periodic_message(pid) do
    Process.send_after(pid, :send_message, 1_000)
  end
end
