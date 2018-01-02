defmodule App.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Games.Game
  alias App.Games.Player
  alias App.Questions.Question

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "games" do
    belongs_to :current_question, Question
    has_many :players, Player
    many_to_many :questions, Question, join_through: "games_questions"

    field :status, :string, default: "started"

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_length(:players, max: 2)
  end

  def can_join(game) do
    length(game.players) < 2
  end
end
