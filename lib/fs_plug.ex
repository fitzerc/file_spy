defmodule FsPlug do
  import Plug.Conn

  def init(_opts) do
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world!!!")
  end
end
