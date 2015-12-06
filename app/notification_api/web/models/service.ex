defmodule NotificationApi.Service do
  use NotificationApi.Web, :model

  @primary_key {:service_id, :string, []}
  @derive {Phoenix.Param, key: :service_id}
  schema "service" do
    field :service_nm, :string
    field :gcm_api_key, :string
    field :apns_key, :string
    field :apns_cert, :string
    field :rest_token, :string
    field :android_token, :string
    field :ios_token, :string
    field :create_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :update_dt, Ecto.DateTime, default: Ecto.DateTime.utc
    field :create_user, :integer
    field :update_user, :integer

    # timestamps
  end

  @required_fields ~w(service_id service_nm gcm_api_key apns_key apns_cert rest_token android_token ios_token)
  @optional_fields ~w(create_dt update_dt create_user update_user)

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

defmodule NotificationApi.Service.Query do
  import Ecto.Query
  alias NotificationApi.Service

  def by_rest_token([token]), do: by_rest_token(token)
  def by_rest_token(token) do
    from s in Service,
    where: s.rest_token == ^token
  end
end
