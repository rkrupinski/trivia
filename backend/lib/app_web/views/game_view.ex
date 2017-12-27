defmodule AppWeb.GameView do
  use AppWeb, :view
  alias AppWeb.GameView
  alias AppWeb.QuestionView
  alias AppWeb.PlayerView
  alias App.Games.Game

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      playing: Game.is_playing(game),
      can_join: game.can_join,
      status: game.status,
      inserted_at: game.inserted_at,
      questions: render_many(game.questions, QuestionView, "question.json"),
      players: render_many(game.players, PlayerView, "player.json")}
  end

  def render("joined.json", %{game: game, player: player}) do
    %{data:
      %{game_id: game.id,
        player_id: player.id}
    }
  end
end
