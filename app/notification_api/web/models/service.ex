defmodule NotificationApi.Service do
  use NotificationApi.Web, :model

  schema "service" do
    field :service_id, :string

    timestamps
  end

  @required_fields ~w(service_id)
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
