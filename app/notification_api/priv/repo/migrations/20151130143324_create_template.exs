defmodule NotificationApi.Repo.Migrations.CreateTemplate do
  use Ecto.Migration

  def change do
    create table(:template) do
      add :service_id, :string

      timestamps
    end

  end
end
