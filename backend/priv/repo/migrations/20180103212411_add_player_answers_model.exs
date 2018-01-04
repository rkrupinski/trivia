defmodule App.Repo.Migrations.AddPlayerAnswersModel do
  use Ecto.Migration

  def change do
    create table(:player_answers) do
      add :game_id, references(:games, on_delete: :nothing, type: :uuid)
      add :player_id, references(:players, on_delete: :nothing, type: :uuid)
      add :question_id, references(:questions, on_delete: :nothing)
      add :answer_id, references(:answers, on_delete: :nothing)

      timestamps()
    end
  end
end
