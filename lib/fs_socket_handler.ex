defmodule FsSocketHandler do
  @behaviour WebSock

  @poll_interval 2000

  def init(path: file_path) do
    IO.puts("spy file init for path:")
    IO.inspect(file_path)

    # Read and send the initial file content line by line
    file_lines = File.stream!(file_path) |> Enum.map(&String.trim/1)
    # Start polling for changes
    send_polling_message(self())

    # push existing lines to socket
    {:push, Enum.map(file_lines, fn line -> {:text, line} end),
     %{file_path: file_path, lines: file_lines}}
  end

  # ignore incoming requests
  def handle_in(_message, state), do: {:ok, state}

  def handle_info(:poll_file, state) do
    # Schedule the next poll
    send_polling_message(self())

    # Send updated file contents
    file_lines = File.stream!(state.file_path) |> Enum.map(&String.trim/1)

    case file_lines == state.lines do
      # don't do anything if file didn't change
      true ->
        IO.puts("no change")
        {:ok, state}

      false ->
        # send new line
        IO.puts("pushing change")
        {:push, {:text, List.last(file_lines)}, %{state | lines: file_lines}}
    end
  end

  def handle_info(_info, state), do: {:ok, state}

  def terminate(_reason, _state) do
    IO.puts("spy file terminate")
    {:ok}
  end

  # Helper to schedule polling
  defp send_polling_message(socket) do
    Process.send_after(socket, :poll_file, @poll_interval)
  end
end
