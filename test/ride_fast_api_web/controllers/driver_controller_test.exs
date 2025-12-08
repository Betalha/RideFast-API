defmodule RideFastApiWeb.DriverControllerTest do
  use RideFastApiWeb.ConnCase

  import RideFastApi.DriversFixtures

  @create_attrs %{name: "some name", status: "some status", email: "some email", phone: "some phone", password_hash: "some password_hash", created_at: ~N[2025-12-06 19:02:00]}
  @update_attrs %{name: "some updated name", status: "some updated status", email: "some updated email", phone: "some updated phone", password_hash: "some updated password_hash", created_at: ~N[2025-12-07 19:02:00]}
  @invalid_attrs %{name: nil, status: nil, email: nil, phone: nil, password_hash: nil, created_at: nil}

  describe "index" do
    test "lists all drivers", %{conn: conn} do
      conn = get(conn, ~p"/drivers")
      assert html_response(conn, 200) =~ "Listing Drivers"
    end
  end

  describe "new driver" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/drivers/new")
      assert html_response(conn, 200) =~ "New Driver"
    end
  end

  describe "create driver" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/drivers", driver: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/drivers/#{id}"

      conn = get(conn, ~p"/drivers/#{id}")
      assert html_response(conn, 200) =~ "Driver #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/drivers", driver: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Driver"
    end
  end

  describe "edit driver" do
    setup [:create_driver]

    test "renders form for editing chosen driver", %{conn: conn, driver: driver} do
      conn = get(conn, ~p"/drivers/#{driver}/edit")
      assert html_response(conn, 200) =~ "Edit Driver"
    end
  end

  describe "update driver" do
    setup [:create_driver]

    test "redirects when data is valid", %{conn: conn, driver: driver} do
      conn = put(conn, ~p"/drivers/#{driver}", driver: @update_attrs)
      assert redirected_to(conn) == ~p"/drivers/#{driver}"

      conn = get(conn, ~p"/drivers/#{driver}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, driver: driver} do
      conn = put(conn, ~p"/drivers/#{driver}", driver: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Driver"
    end
  end

  describe "delete driver" do
    setup [:create_driver]

    test "deletes chosen driver", %{conn: conn, driver: driver} do
      conn = delete(conn, ~p"/drivers/#{driver}")
      assert redirected_to(conn) == ~p"/drivers"

      assert_error_sent 404, fn ->
        get(conn, ~p"/drivers/#{driver}")
      end
    end
  end

  defp create_driver(_) do
    driver = driver_fixture()

    %{driver: driver}
  end
end
