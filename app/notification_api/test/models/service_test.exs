defmodule NotificationApi.ServiceTest do
  use NotificationApi.ModelCase

  alias NotificationApi.Service

  @valid_attrs %{service_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Service.changeset(%Service{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Service.changeset(%Service{}, @invalid_attrs)
    refute changeset.valid?
  end
end
