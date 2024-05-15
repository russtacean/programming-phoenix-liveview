defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    winning_num = Enum.random(1..10)

    {
      :ok,
      assign(
        socket,
        winning_num: winning_num,
        score: 0,
        isWin: false,
        message: "Make a guess:"
      )
    }
  end

  def handle_params(_unsigned_params, _uri, socket) do
    winning_num = Enum.random(1..10)

    {
      :noreply,
      assign(
        socket,
        winning_num: winning_num,
        score: 0,
        isWin: false,
        message: "Make a guess:"
      )
    }
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          phx-click="guess"
          phx-value-number={n}
          class="bg-blue-500 hover: bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <%= if @isWin do %>
      <br />
      <h2>
        Would you like to restart?
        <.link
          patch={~p"/guess"}
          class="bg-blue-500 hover: bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
        >
          Restart
        </.link>
      </h2>
    <% end %>
    <br />
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    winning_num = socket.assigns.winning_num
    isWin = String.to_integer(guess) == winning_num
    messagePrefix = "Your guess #{guess}."

    message =
      if isWin do
        "#{messagePrefix} Right. You win!"
      else
        "#{messagePrefix} Wrong. Guess again"
      end

    score =
      if isWin do
        socket.assigns.score + 10
      else
        socket.assigns.score - 1
      end

    {
      :noreply,
      assign(socket, winning_num: winning_num, message: message, score: score, isWin: isWin)
    }
  end
end
