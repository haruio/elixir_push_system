defmodule NotificationApi.Repo.Migrations.CreatePushStats do
  use Ecto.Migration

  def change do
    create table(:push_stats) do
      add :push_id, :string

      timestamps
    end

  end
end
