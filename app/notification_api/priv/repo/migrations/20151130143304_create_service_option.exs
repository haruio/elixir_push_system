defmodule NotificationApi.Repo.Migrations.CreateServiceOption do
  use Ecto.Migration

  def change do
    create table(:service_option) do
      add :service_id, :string

      timestamps
    end

  end
end
