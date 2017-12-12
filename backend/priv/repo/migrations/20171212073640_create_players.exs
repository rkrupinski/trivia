defmodule App.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      add :game_id, references(:games, on_delete: :nothing, type: :uuid), null: true

      timestamps()
    end

  end
end
