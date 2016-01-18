defmodule Flaggy.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :fb_id, :string, primary_key: true
      add :name, :string
      add :token, :string
      add :avatar, :string
      add :image, :string

      timestamps
    end

    create unique_index(:users, [:fb_id])

  end
end
