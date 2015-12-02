defmodule NotificationApi.UserServiceTest do
  use NotificationApi.ModelCase

  alias NotificationApi.UserService

  @valid_attrs %{user_seq: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserService.changeset(%UserService{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserService.changeset(%UserService{}, @invalid_attrs)
    refute changeset.valid?
  end
end
