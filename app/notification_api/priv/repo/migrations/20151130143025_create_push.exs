defmodule NotificationApi.Repo.Migrations.CreatePush do
  use Ecto.Migration

  def change do
    create table(:push_option) do
      add :push_id, :string

      timestamps
    end

  end
end
