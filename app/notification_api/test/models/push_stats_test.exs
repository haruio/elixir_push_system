defmodule NotificationApi.PushStatsTest do
  use NotificationApi.ModelCase

  alias NotificationApi.PushStats

  @valid_attrs %{push_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PushStats.changeset(%PushStats{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PushStats.changeset(%PushStats{}, @invalid_attrs)
    refute changeset.valid?
  end
end
