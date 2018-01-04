defmodule AppWeb.GameController do
  use AppWeb, :controller

  alias App.Games
  alias App.Games.Game
  alias App.Games.PlayerAnswer
  import Ecto.Query, warn: false
  alias App.Repo
  require Logger

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.json", games: games)
  end

  def create(conn, game_params) do
    with {:ok, %Game{} = game} <- Games.create_game(game_params) do
      game = Games.get_game!(game.id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", game_path(conn, :show, game))
      |> render("show.json", game: game)
    end
  end

  def show(conn, params) do
    game = Games.get_game!(params["id"])

    case params["player_id"] do
      nil -> render(conn, "show.json", game: game)
      _ -> render(conn, "game_with_player_status.json", game: game, player: Games.get_player_or_none(params["player_id"]))
    end
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Games.get_game!(id)

    with {:ok, %Game{} = game} <- Games.update_game(game, game_params) do
      render(conn, "show.json", game: game)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    with {:ok, %Game{}} <- Games.delete_game(game) do
      send_resp(conn, :no_content, "")
    end
  end

  def join(conn, %{"id" => id, "player_name" => player_name}) do
    game = Games.get_game!(id)
    player = Games.join_game(id, player_name)
    render(conn, "joined.json", game: game, player: player)
  end

  def generate_answers(conn, %{"id" => id}) do
    game = Games.get_game!(id)

    PlayerAnswer
    |> Ecto.Query.where(game_id: ^game.id)
    |> Repo.delete_all

    # TODO: gemerate random answers
    foo = for question <- game.questions do
      %{question_id: question.id,
        players: for player <- game.players do 
          %{id: player.id, correct: false}
        end
      }
    end

    # foo |> inspect |> Logger.debug

    game_answers = PlayerAnswer
    |> Ecto.Query.where(game_id: ^game.id) 
    |> Repo.all
    |> Repo.preload(:question)
    |> Repo.preload(:player)
    |> Repo.preload(:answer)

    render(conn, "game_answers.json", game_answers: game_answers)
  end
end
