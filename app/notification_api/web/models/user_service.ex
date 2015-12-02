defmodule NotificationApi.UserService do
  use NotificationApi.Web, :model

  schema "user_service" do
    field :user_seq, :integer

    timestamps
  end

  @required_fields ~w(user_seq)
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
