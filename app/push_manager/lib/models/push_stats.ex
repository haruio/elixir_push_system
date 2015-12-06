defmodule PushManager.Model.PushStats do
  use Ecto.Schema

  @stats_cd_published "PUB"
  @stats_cd_opened "OPN"
  @stats_cd_received "rcv"

  @primary_key {:push_id, :string, []}
  schema "push_stats" do
    field :stats_start_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :stats_end_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :ststs_cd, :string
    field :stats_cnt, :integer
  end

  def cd_published, do: @stats_cd_published 
  def cd_opened, do: @stats_cd_opened
  def cd_received, do: @stats_cd_received

  defmodule Query do
    alias PushManager.Repo
    alias PushManager.Model.PushStats
    
    def insert_published(push_id, cnt), do: Repo.insert %PushStats{push_id: push_id, ststs_cd: PushStats.cd_published, stats_cnt: cnt} 
  end
end
