defmodule PentoWeb.FrequentlyAskedQuestionLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.FAQ

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage frequently_asked_question records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="frequently_asked_question-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:question]} type="text" label="Question" />
        <.input field={@form[:answer]} type="text" label="Answer" />
        <.input field={@form[:vote_score]} type="number" label="Vote score" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Frequently asked question</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{frequently_asked_question: frequently_asked_question} = assigns, socket) do
    changeset = FAQ.change_frequently_asked_question(frequently_asked_question)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"frequently_asked_question" => frequently_asked_question_params}, socket) do
    changeset =
      socket.assigns.frequently_asked_question
      |> FAQ.change_frequently_asked_question(frequently_asked_question_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"frequently_asked_question" => frequently_asked_question_params}, socket) do
    save_frequently_asked_question(socket, socket.assigns.action, frequently_asked_question_params)
  end

  defp save_frequently_asked_question(socket, :edit, frequently_asked_question_params) do
    case FAQ.update_frequently_asked_question(socket.assigns.frequently_asked_question, frequently_asked_question_params) do
      {:ok, frequently_asked_question} ->
        notify_parent({:saved, frequently_asked_question})

        {:noreply,
         socket
         |> put_flash(:info, "Frequently asked question updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_frequently_asked_question(socket, :new, frequently_asked_question_params) do
    case FAQ.create_frequently_asked_question(frequently_asked_question_params) do
      {:ok, frequently_asked_question} ->
        notify_parent({:saved, frequently_asked_question})

        {:noreply,
         socket
         |> put_flash(:info, "Frequently asked question created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
