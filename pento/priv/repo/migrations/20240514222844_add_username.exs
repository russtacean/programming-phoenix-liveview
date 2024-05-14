defmodule Pento.Repo.Migrations.AddUsername do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :username, :string, size: 50
    end

    create unique_index(:users, [:username])
  end
end
