defmodule DeliveryWeb.SoundController do
  use DeliveryWeb, :controller

  alias Delivery.Library

  def index(conn, _params) do
    sounds = Library.list_sounds()
    render(conn, "index.html", sounds: sounds, loaded: false)
  end

  def loaded(conn, %{ "id" => id}) do
    sounds = Library.list_sounds()
    clip = Library.get_sound!(id)
    render(conn, "index.html", sounds: sounds, loaded: true, clip: clip)
  end

  def write(conn, params) do

    IO.puts "write!"
    IO.inspect params

    case Library.create_sound(params) do
      {:ok, _sound} ->
        conn
        |> json(%{ "result" => "success"})

      _ ->
        conn
        |> json(%{ "result" => "failure"})
    end
  end

end
