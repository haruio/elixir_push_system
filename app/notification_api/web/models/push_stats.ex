defmodule NotificationApi.PushStats do
  use NotificationApi.Web, :model

  schema "push_stats" do
    field :push_id, :string
    field :stats_start_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :stats_end_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :ststs_cd, :string
    field :stats_cnt, :integer
  end

  @required_fields ~w(push_id ststs_cd)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

defmodule NotificationApi.PushStats.Query do
  import Ecto.Query
  alias NotificationApi.PushStats
  alias Util.Parser
  alias Timex.DateFormat

  def summary_by_push_id(%{"push_id" => push_id}), do: summary_by_push_id(push_id)
  def summary_by_push_id(push_id) do
    from stats in PushStats,
    where: stats.push_id == ^push_id,
    group_by: stats.ststs_cd,
    select: [stats.ststs_cd, sum(stats.stats_cnt)]
  end

  def timeseries_by_push_id(%{"push_id" => push_id}), do: timeseries_by_push_id(push_id)
  def timeseries_by_push_id(push_id) do
    Ecto.Adapters.SQL.query(NotificationApi.Repo, "SELECT DATE_FORMAT(stats_end_dt, \"%Y-%m-%dT%H:00:00.00Z\") as stats_end_dt, ststs_cd, SUM(stats_cnt) as stats_cnt FROM `push_stats` WHERE push_id = ?  GROUP BY DATE_FORMAT(stats_end_dt, \"%Y-%m-%d %H\"), ststs_cd ORDER BY stats_end_dt DESC",[push_id])
    |> timeseries_to_json
  end

  defp timeseries_to_json({:ok, %{rows: rows}}) do
    rows
    |> Enum.map(fn([dt, cd, cnt]) -> %{"stats_dt" => dt |> Parser.iso_to_long , "stats_cd" => cd, "stats_cnt" => cnt |> Parser.decimal_to_integer } end)
    |> Enum.group_by(fn(%{"stats_cd" => cd}) -> cd  end)
  end
end


defmodule NotificationApi.PushStats.Count do
  defstruct published: 0, received: 0, opened: 0
end
