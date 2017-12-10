defmodule App.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Questions.Question
  alias App.Questions.Answer

  @derive {Poison.Encoder, only: [:id, :text]}

  schema "questions" do
    has_many :answers, Answer
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
