defmodule NotificationApi.Repo.Migrations.CreatePush do
  use Ecto.Migration

  def change do
    create table(:push) do
      add :push_id, :string

      timestamps
    end

  end
end
