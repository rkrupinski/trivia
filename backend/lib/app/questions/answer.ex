defmodule App.Questions.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Questions.Answer
  alias App.Questions.Question

  @derive {Poison.Encoder, only: [:id, :text, :is_correct]}
  schema "answers" do
    belongs_to :question, Question
    field :text, :string
    field :is_correct, :boolean

    timestamps()
  end

  @doc false
  def changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:question_id, :text, :is_correct])
    |> validate_required([:question_id, :text, :is_correct])
  end
end
