defmodule App.Games.PlayerAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Games.Game
  alias App.Games.Player
  alias App.Questions.Question
  alias App.Questions.Answer

  @foreign_key_type Ecto.UUID

  schema "player_answers" do
    belongs_to :game, Game
    belongs_to :player, Player
    belongs_to :question, Question
    belongs_to :answer, Answer

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:game, :player, :question, :answer])
  end
end
