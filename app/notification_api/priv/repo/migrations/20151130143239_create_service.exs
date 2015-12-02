defmodule NotificationApi.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do
    create table(:service) do
      add :service_id, :string

      timestamps
    end

  end
end
