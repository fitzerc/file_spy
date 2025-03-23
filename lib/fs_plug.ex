defmodule FsPlug do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    case File.read("lib/templates/index.html") do
      {:ok, html_content} ->
        send_resp(conn, 200, html_content)

      {:error, reason} ->
        send_resp(conn, 500, "Failed to load HTML: #{reason}")
    end
  end

  get "/websocket/:string" do
    IO.inspect(conn)

    conn
    |> WebSockAdapter.upgrade(FsSocketHandler, [path: conn.params["string"]], timeout: 60_000)
    |> halt()
  end

  get "/:string" do
    IO.puts(conn.params["string"])

    case File.read("lib/templates/spy_file.html") do
      {:ok, html_content} ->
        send_resp(conn, 200, html_content)

      {:error, reason} ->
        send_resp(conn, 500, "Failed to load HTML: #{reason}")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
