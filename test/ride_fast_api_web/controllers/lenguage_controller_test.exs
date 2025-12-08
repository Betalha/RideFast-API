defmodule RideFastApiWeb.LenguageControllerTest do
  use RideFastApiWeb.ConnCase

  import RideFastApi.LanguagesFixtures

  @create_attrs %{code: "some code", name: "some name"}
  @update_attrs %{code: "some updated code", name: "some updated name"}
  @invalid_attrs %{code: nil, name: nil}

  describe "index" do
    test "lists all lenguages", %{conn: conn} do
      conn = get(conn, ~p"/lenguages")
      assert html_response(conn, 200) =~ "Listing Lenguages"
    end
  end

  describe "new lenguage" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/lenguages/new")
      assert html_response(conn, 200) =~ "New Lenguage"
    end
  end

  describe "create lenguage" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/lenguages", lenguage: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/lenguages/#{id}"

      conn = get(conn, ~p"/lenguages/#{id}")
      assert html_response(conn, 200) =~ "Lenguage #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/lenguages", lenguage: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Lenguage"
    end
  end

  describe "edit lenguage" do
    setup [:create_lenguage]

    test "renders form for editing chosen lenguage", %{conn: conn, lenguage: lenguage} do
      conn = get(conn, ~p"/lenguages/#{lenguage}/edit")
      assert html_response(conn, 200) =~ "Edit Lenguage"
    end
  end

  describe "update lenguage" do
    setup [:create_lenguage]

    test "redirects when data is valid", %{conn: conn, lenguage: lenguage} do
      conn = put(conn, ~p"/lenguages/#{lenguage}", lenguage: @update_attrs)
      assert redirected_to(conn) == ~p"/lenguages/#{lenguage}"

      conn = get(conn, ~p"/lenguages/#{lenguage}")
      assert html_response(conn, 200) =~ "some updated code"
    end

    test "renders errors when data is invalid", %{conn: conn, lenguage: lenguage} do
      conn = put(conn, ~p"/lenguages/#{lenguage}", lenguage: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Lenguage"
    end
  end

  describe "delete lenguage" do
    setup [:create_lenguage]

    test "deletes chosen lenguage", %{conn: conn, lenguage: lenguage} do
      conn = delete(conn, ~p"/lenguages/#{lenguage}")
      assert redirected_to(conn) == ~p"/lenguages"

      assert_error_sent 404, fn ->
        get(conn, ~p"/lenguages/#{lenguage}")
      end
    end
  end

  defp create_lenguage(_) do
    lenguage = lenguage_fixture()

    %{lenguage: lenguage}
  end
end
