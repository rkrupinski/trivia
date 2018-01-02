defmodule App.Repo.Migrations.RemoveCanJoinField do
  use Ecto.Migration

  def change do
    alter table(:games) do
      remove :can_join
    end
  end
end
