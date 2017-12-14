defmodule App.Repo.Migrations.AddDefaultStatusForGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      modify :status, :string, default: "started"
    end
  end
end
