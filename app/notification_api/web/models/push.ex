defmodule NotificationApi.Push do
  use NotificationApi.Web, :model

  @primary_key {:push_id, :string, []}
  @derive {Phoenix.Param, key: :push_id}
  schema "push" do
    field :service_id, :string
    field :push_condition, :string
    field :push_status, :string
    field :publish_dt, Ecto.Date
    field :publish_start_dt, Ecto.Date
    field :publish_end_dt, Ecto.Date
    field :body, :string
    field :title, :string
    field :extra, :string
    field :create_dt, Ecto.Date
    field :create_user, :integer
    field :update_dt, Ecto.Date
    field :update_user, :integer

    # timestamps([{:create_dt,:update_dt}])

  end

  @required_fields ~w(push_id body title push_condition extra service_id push_status)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    params = params |> mapper_create_push
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def mapper_create_push(params) do
    %{
      push_id: Dict.get(params, "push_id"),
      service_id: Dict.get(params, "service_id"),
      body: Dict.get(params, "message") |> Dict.get("body"),
      title: Dict.get(params, "message") |> Dict.get("title"),
      push_condition: Poison.encode!(Dict.get(params, "condition")),
      extra: Poison.encode!(Dict.get(params, "extra")),
      push_status: Dict.get(params, "push_status")
    }
  end
end
