defmodule NotificationApi.Push do
  use NotificationApi.Web, :model
  use Timex

  @primary_key {:push_id, :string, []}
  @derive {Phoenix.Param, key: :push_id}
  # @derive {Poison.Encoder, only: [:service_id, :push_id, :push_condition, :push_status, :publish_dt, :publish_start_dt,
                                  # :publish_end_dt, :body, :title, :extra, :create_user, :create_dt, :update_user,
                                  # :update_dt]}
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
    field :create_user, :integer
    field :update_user, :integer
    field :create_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :update_dt, Ecto.DateTime, default: Ecto.DateTime.utc
  end

  @required_fields ~w(push_id body title push_condition extra service_id push_status)
  @optional_fields ~w(create_user update_user)

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
      push_status: Dict.get(params, "push_status"),
      create_user: 0, # TODO user_seq 
      update_user: 0  # TODO user_seq
    }
  end
end


defmodule NotificationApi.Push.Query do
  import Ecto.Query
  alias NotificationApi.Push

  def by_service_id(service_id) do
    from p in Push,
    where: p.service_id == ^service_id,
    order_by: [desc: p.create_dt]
  end

  def filter(query, %{"status" => status}), do: query |> where([p], p.push_status == ^status)
  def filter(query, _), do: query

  def search(query, %{"searchField" => "BODY", "searchText" => text}) when is_binary(text), do: query |> where([p], like(p.body, ^"%#{text}%"))
  def search(query, %{"searchField" => "TITLE", "searchText" => text}) when is_binary(text), do: query |> where([p], like(p.title, ^"%#{text}%"))
  def search(query, _), do: query

  def by_service_id_and_push_id({service_id, push_id}) do
    from p in Push,
    where: p.service_id == ^service_id and p.push_id == ^push_id
  end
end
