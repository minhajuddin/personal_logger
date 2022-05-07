defmodule PLWeb.DashboardLive do
  use Phoenix.LiveView
  alias PL.Logs

  @impl true
  def mount(_params, %{"magic_token" => magic_token}, socket) do
    {:ok, {id, _magic_token}} = PLWeb.MagicToken.decode(magic_token)

    if connected?(socket) do
      schedule_tick()
    end

    {:ok, assign(socket, :user_id, id), temporary_assigns: [entries: []]}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, 1000)
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_tick()
    {:noreply, assign(socket, entries: Logs.list_entries_for_user(socket.assigns.user_id))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Dashboard</h1>
    <ol>
      <%= for entry <- @entries do %>
        <li><%= entry.body %></li>
      <% end %>
    </ol>
    """
  end
end
