defmodule App.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :text, :string

      timestamps()
    end

    create table(:answers) do
      add :question_id, references(:questions, on_delete: :nothing), null: false
      add :text, :string
      add :is_correct, :boolean

      timestamps()
    end

  end
end
