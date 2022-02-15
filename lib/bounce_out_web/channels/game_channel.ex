defmodule BounceOutWeb.GameChannel do
  use BounceOutWeb, :channel

  @impl true
  def join("game:lobby", payload, socket) do
    if authorized?(payload) do
      :game1 |> BounceOut.new_player()

      game = BounceOut.get_game(:game1)

      {:ok, %{playerId: game.players, players: game.max_players}, socket}
      # {:ok, %{playerId: 1, players: 2}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("player", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("launchVecs", payload, socket) do
    print_id(socket)
    broadcast_from!(socket, "launchVecs", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp print_id(socket) do
    IO.puts("SOCKET: #{inspect(socket)}\n\n")
  end
end
