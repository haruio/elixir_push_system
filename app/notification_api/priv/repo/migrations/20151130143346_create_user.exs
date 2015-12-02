defmodule NotificationApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :user_seq, :integer

      timestamps
    end

  end
end
