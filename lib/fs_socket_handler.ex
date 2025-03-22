defmodule FsSocketHandler do
  @behaviour WebSock

  def init(_args) do
    IO.puts("FsSocket: init")
    {:ok, %{count: 0}}
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

  def handle_info(_info, state) do
    IO.puts("FsSocket: info")
    IO.inspect(state)
    {:ok, state}
  end

  def terminate(_reason, _state) do
    IO.puts("FsSocket: terminate")
    :ok
  end
end
