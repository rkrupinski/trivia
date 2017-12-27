defmodule App.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Games.Player
  alias App.Games.Game

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "players" do
    belongs_to :game, Game

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    player
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
