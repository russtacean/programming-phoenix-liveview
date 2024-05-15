defmodule Pento.FAQ.FrequentlyAskedQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frequently_asked_questions" do
    field :question, :string
    field :answer, :string
    field :vote_score, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(frequently_asked_question, attrs) do
    frequently_asked_question
    |> cast(attrs, [:question, :answer, :vote_score])
    |> validate_required([:question, :answer, :vote_score])
  end
end
