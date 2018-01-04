defmodule AppWeb.GameView do
  use AppWeb, :view
  alias AppWeb.GameView
  alias AppWeb.QuestionView
  alias AppWeb.PlayerView
  alias App.Games.Game

  require Logger

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    answers = for question <- game.questions do
      %{question_id: question.id,
        players: for player <- game.players do 
          %{id: player.id, correct: false}
        end
      }
    end

    %{id: game.id,
      can_join: Game.can_join(game),
      playing: false,
      status: game.status,
      inserted_at: game.inserted_at,
      questions: render_many(game.questions, QuestionView, "question.json"),
      players: render_many(game.players, PlayerView, "player.json"),
      answers: answers}
  end

  def render("game_with_player_status.json", %{game: game, player: player}) do
    # player |> inspect |> Logger.debug

    answers = for question <- game.questions do
      %{question_id: question.id,
        players: for player <- game.players do 
          %{id: player.id, correct: false}
        end
      }
    end

    %{id: game.id,
      can_join: Game.can_join(game),
      playing: Enum.member?(game.players, player),
      status: game.status,
      inserted_at: game.inserted_at,
      questions: render_many(game.questions, QuestionView, "question.json"),
      players: render_many(game.players, PlayerView, "player.json"),
      answers: answers}
  end

  def render("joined.json", %{game: game, player: player}) do
    %{data:
      %{game_id: game.id,
        player_id: player.id}
    }
  end

  def render("game_answers.json", %{answers: answers}) do
    answers
  end
end
