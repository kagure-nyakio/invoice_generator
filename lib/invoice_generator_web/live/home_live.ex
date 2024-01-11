defmodule InvoiceGeneratorWeb.HomeLive do
  @moduledoc false

  use InvoiceGeneratorWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>Home Live</h1>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
