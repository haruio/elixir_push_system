defmodule NotificationApi.PushOptionTest do
  use NotificationApi.ModelCase

  alias NotificationApi.PushOption

  @valid_attrs %{push_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PushOption.changeset(%PushOption{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PushOption.changeset(%PushOption{}, @invalid_attrs)
    refute changeset.valid?
  end
end
