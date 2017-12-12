defmodule App.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :can_join, :boolean, default: true, null: false
      add :status, :string
      add :current_question_id, references(:questions, on_delete: :nothing), null: true

      timestamps()
    end

    create table(:games_questions, primary_key: false) do
      add :game_id, references(:games, type: :uuid)
      add :question_id, references(:questions)
    end
  end
end
