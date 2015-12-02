defmodule NotificationApi.PushControllerTest do
  use NotificationApi.ConnCase

  alias NotificationApi.Push
  @valid_attrs %{push_id: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, push_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    push = Repo.insert! %Push{}
    conn = get conn, push_path(conn, :show, push)
    assert json_response(conn, 200)["data"] == %{"id" => push.id,
      "push_id" => push.push_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, push_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, push_path(conn, :create), push: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Push, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, push_path(conn, :create), push: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    push = Repo.insert! %Push{}
    conn = put conn, push_path(conn, :update, push), push: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Push, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    push = Repo.insert! %Push{}
    conn = put conn, push_path(conn, :update, push), push: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    push = Repo.insert! %Push{}
    conn = delete conn, push_path(conn, :delete, push)
    assert response(conn, 204)
    refute Repo.get(Push, push.id)
  end
end
