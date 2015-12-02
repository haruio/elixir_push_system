defmodule NotificationApi.Repo.Migrations.CreateUserService do
  use Ecto.Migration

  def change do
    create table(:user_service) do
      add :user_seq, :integer

      timestamps
    end

  end
end
