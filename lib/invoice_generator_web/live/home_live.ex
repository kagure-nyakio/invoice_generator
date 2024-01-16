defmodule InvoiceGeneratorWeb.HomeLive do
  @moduledoc false

  use InvoiceGeneratorWeb, :live_view

  alias InvoiceGeneratorWeb.IconComponents

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="text-center container-grid">
      <div class="hidden md:block h-full">
        <img src={~p"/images/section-invoice.png"} class="h-full w-full object-fit" />
      </div>

      <div class="max-w-sm md:max-w-md mx-auto">
        <div class="flex items-center justify-center gap-2">
          <h1 class="text-3xl text-[#7C5DFA] font-bold tracking-wider order-last">Invoice</h1>
          <IconComponents.logo_icon />
        </div>

        <h2 class="text-2xl text-black font-bold mt-2">Sign up to invoice</h2>

        <div class="grid gap-12 py-16">
          <.link class="border border-[#dfe3fa] mx-auto py-2 sm:py-4 rounded-full w-[80%] sm:w-[90%] flex items-center justify-center gap-2">
            <IconComponents.google_icon />
            <span>Sign up with Google</span>
          </.link>

          <.link
            class="border border-[#dfe3fa] mx-auto py-2 sm:py-4 rounded-full w-[80%] sm:w-[90%] flex items-center justify-center gap-2"
            navigate={~p"/register"}
          >
            <IconComponents.email_icon />
            <span>Continue with Email</span>
          </.link>
        </div>

        <p class="text-[#888eb0] text-sm sm:text-base mt-4 px-3">
          By creating an account, you agree to Invoice company's
          <span class="font-bold">Terms of use</span>
          and <span class="font-bold">Privacy Policy</span>.
        </p>
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
